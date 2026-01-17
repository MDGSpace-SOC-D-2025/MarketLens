from alerts import generate_alert
from insights import generate_insights
from history import AnalyzeHistoricalTrend, getMEIHistory
from cache import get_cache
from stock_service import compute_stock_sentiment

def get_market_snapshot(code: str):
    latest = get_cache(code) or compute_stock_sentiment(code)
    history = getMEIHistory(code) or []

    analyzer = AnalyzeHistoricalTrend(code, history)

    trend = analyzer.sentiment_trend()
    momentum = analyzer.sentiment_momentum_score()
    volatility = analyzer.sentimetal_volatility_indicator()

    alert = generate_alert(
        latest["mei"],
        trend["direction"],
        momentum,
        volatility["level"],
    )

    insights = generate_insights(
    trend,
    momentum,
    volatility,
    history
)


    return {
        "code": code,
        "mei": latest["mei"],
        "trend": latest["trend"],
        "headlines": latest["headlines"],
        "history": history,
        "trend_analysis": trend,
        "momentum": momentum,
        "volatility": volatility,
        "alert": alert,
        "insight": insights,
    }
