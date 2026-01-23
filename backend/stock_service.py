from data_sources.news_service import (
    fetch_headlines,
    deduplicate_headlines_fuzzy,
    filter_relevant_headlines,
    weighted_sentiment,
)
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from cache import get_cache, set_cache
from history import addtoMEIHistory

analyzer = SentimentIntensityAnalyzer()

def compute_stock_sentiment(code: str):
    code = code.upper()

    cached = get_cache(code)
    if cached:
        return cached

    raw_headlines = fetch_headlines(code)
    deduped = deduplicate_headlines_fuzzy(raw_headlines)
    headlines = filter_relevant_headlines(deduped)

    if not headlines:
        result = {
            "code": code,
            "mei": 50,
            "trend": "Uncertain",
            "headlines": [],
        }
        set_cache(code, result)
        return result

    avg_compound = weighted_sentiment(headlines, analyzer)
    mei = int((avg_compound + 1) * 50)

    if mei <= 25:
        trend = "Strongly Bearish"
    elif mei <= 40:
        trend = "Bearish"
    elif mei <= 60:
        trend = "Uncertain/Neutral"
    elif mei <= 80:
        trend = "Bullish"
    else:
        trend = "Strongly Bullish"

    result = {
        "code": code,
        "mei": mei,
        "trend": trend,
        "headlines": headlines,
    }

    addtoMEIHistory(code, result)
    set_cache(code, result)
    return result
