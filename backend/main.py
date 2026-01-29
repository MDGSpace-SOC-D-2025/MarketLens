from stock_service import compute_stock_sentiment
from market_snapshot import get_market_snapshot
from data_sources.news_service import fetch_headlines, deduplicate_headlines_fuzzy, filter_relevant_headlines, weighted_sentiment, relevance_score
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from fastapi import FastAPI

from article_fetcher import fetch_article_text

from assistant_ai import ask_marketlens_ai, build_prompt


from cache import get_cache, set_cache
from history import addtoMEIHistory, bootstrap_mei_history, getMEIHistory, AnalyzeHistoricalTrend
from alerts import generate_alert
from insights import generate_insights



import datetime
app=FastAPI()

analyzer=SentimentIntensityAnalyzer()

mei=0 

@app.get("/stock/{code}")
def get_stock_sentiment(code:str):
    return compute_stock_sentiment(code)


@app.get("/stock/history/{code}")
def stock_mei_history(code:str):
    bootstrap_mei_history(code)
    history = getMEIHistory(code)

    latest = get_cache(code)
    if latest:
        if not history or history[-1]['mei'] != latest['mei']:
            history.append({
                "mei": latest["mei"],
                "timestamp": datetime.datetime.now()
            })
    return {
        'code':code,
        'history': getMEIHistory(code)
    }

@app.get("/stock/historical_trend/{code}")
def stock_mei_historical_trend(code:str):
    history=getMEIHistory(code)
    
    a=AnalyzeHistoricalTrend(code, getMEIHistory(code))
    SentimentalTrend=a.sentiment_trend()
    SentimentalMomentumScore=a.sentiment_momentum_score()
    SentimentalVolatilityIndicator=a.sentimetal_volatility_indicator()

    if not history:
        return {
            'code': code,
            'MEI': 50,
            'Trend': {
                'direction': 'Unknown',
                'explanation': 'Insufficient data'
            },
            'Momentum Score': {
                'value': 0,
                'strength': 'insufficient data',
                'explanation': 'NA'
            },
            'Volatility Indicator': {
                'level': 'insufficient data',
                'explanation': 'NA'
            },
            'Alert': {
                'title': 'No alert',
                'message': 'Not enough historical data',
                'level': 'info',
                'factors': []
            },
            'Insight': {
                'title': 'No insight',
                'message': 'Collecting more data',
                'type': 'neutral'
            }
        }

    
    latest_mei=history[-1]['mei']

    alert=generate_alert(latest_mei, SentimentalTrend['direction'], SentimentalMomentumScore, SentimentalVolatilityIndicator['level'])
    insights = generate_insights(
    SentimentalTrend,
    SentimentalMomentumScore,
    SentimentalVolatilityIndicator,
    history
)

    return {
        'code':code,
        'MEI':latest_mei,
        'Trend':SentimentalTrend,
        'Momentum Score':SentimentalMomentumScore,
        'Volatility Indicator': SentimentalVolatilityIndicator,
        'Alert': alert,
        'Insight':insights,
    }

@app.post('/assistant_chat')
def assistant_chat(payload:dict):
    code = payload["stock"]
    question = payload["question"]

    if not question:
        return {"reply": "Please ask a question."}

    market_context = build_market_context(code)
    try:
        reply = ask_marketlens_ai(market_context, question)
    except RuntimeError:
        # fallback explanation
        reply = (
            "AI assistant is currently unavailable. "
            "Based on market data, sentiment is "
            f"{market_context['emotion']} with "
            f"{market_context['trend_direction']} trend."
        )

    return {"reply": reply}

def build_market_context(code: str):
    snapshot = get_market_snapshot(code)
    history = snapshot["history"]
    news = snapshot.get("news", [])
    expanded_articles = []

    for a in news[:2]:  # STRICT LIMIT
        if a.get("url"):
            content = fetch_article_text(a["url"])
            if content:
                expanded_articles.append({
                    "title": a["title"],
                    "source": a.get("source", "Unknown"),
                    "content": content[:1200]  # keep prompt tight
                })

    history_summary = []
    for i, h in enumerate(history[-5:]):
        history_summary.append(
            f"- {len(history) - i} points ago: MEI {h['mei']}"
        )

    news_context = []
    for a in news[:3]:  # limit context
        news_context.append(
            f"- {a['title']} (Source: {a.get('source', 'Unknown')})"
        )

    mei = snapshot["mei"]

    


    return {
        "stock": code,
        "mei": mei,
        "emotion": "Fear" if mei < 40 else "Greed" if mei > 60 else "Neutral",
        "trend_direction": snapshot["trend_analysis"]["direction"],
        "momentum_value": snapshot["momentum"]["value"],
        "momentum_strength": snapshot["momentum"]["strength"],
        "volatility": snapshot["volatility"]["level"],
        "alert_message": snapshot["alert"]["message"],
        "history_summary": "\n".join(history_summary),
        "news_context": "\n".join(news_context),
        "expanded_articles":expanded_articles
    }





    
    


