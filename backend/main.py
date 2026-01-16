from stock_service import compute_stock_sentiment
from market_snapshot import get_market_snapshot
from data_sources.news_service import fetch_headlines, deduplicate_headlines_fuzzy, filter_relevant_headlines, weighted_sentiment, relevance_score
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from fastapi import FastAPI

from assistant_ai import ask_marketlens_ai, build_prompt
from assistant_chat import build_market_context, chat_response

from cache import get_cache, set_cache
from history import addtoMEIHistory, bootstrap_mei_history, getMEIHistory, AnalyzeHistoricalTrend
from alerts import generate_alert
from insights import generate_insight

from assistant_chat import build_market_context, chat_response

import datetime
app=FastAPI()

analyzer=SentimentIntensityAnalyzer()
'''
STOCK_HEADLINES = {
    "AAPL": ["Apple shares rise after strong iPhone sales",
        "Apple faces regulatory pressure in EU",
        "Investors bullish on Apple's AI strategy"],

    "TSLA": ["Tesla stock drops amid production concerns",
        "Elon Musk hints at new Tesla model",
        "Tesla faces increased EV competition"],
        
    "NIFTY": ["Indian markets rally as inflation cools",
        "IT stocks drag Nifty lower",
        "Banking sector boosts market sentiment"]
}'''



mei=0 
'''
@app.get("/mei")
def getMEI():
    global mei
    compound_score=0
    for headline in STOCK_HEADLINES:
        compound_score+=analyzer.polarity_scores(headline)["compound"]        
    avg_compound=compound_score/len(STOCK_HEADLINES)
    mei=int((avg_compound+1)*50)

    if mei<=25:
        trend="Strongly Bearish"
    elif mei<=40 and mei>25:
        trend="Bearish"
    elif mei<=60 and mei>40:
        trend="Uncertain/Neutral"
    elif mei<=80 and mei>60:
        trend="Bullish"
    elif mei<=100 and mei>80:
        trend="Strongly Bullish "

    return {
        'mei':mei,
        'trend':trend,
        'time': datetime.datetime.now().isoformat()    
    }
'''
@app.get("/stock/{code}")
def get_stock_sentiment(code:str):
    return compute_stock_sentiment(code)


@app.get("/stock/history/{code}")
def stock_mei_history(code:str):
    bootstrap_mei_history(code)
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
    insight=generate_insight(SentimentalTrend, SentimentalMomentumScore, SentimentalVolatilityIndicator)

    return {
        'code':code,
        'MEI':latest_mei,
        'Trend':SentimentalTrend,
        'Momentum Score':SentimentalMomentumScore,
        'Volatility Indicator': SentimentalVolatilityIndicator,
        'Alert': alert,
        'Insight':insight,
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

    history_summary = []
    for i, h in enumerate(history[-5:]):
        history_summary.append(
            f"- {len(history) - i} points ago: MEI {h['mei']}"
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
    }




    
    


