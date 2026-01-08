import requests
import os

NEWS_API_KEY = os.getenv("NEWS_API_KEY")

def fetch_headlines(query: str, limit: int = 5):
    if not NEWS_API_KEY:
        return ["News API key not configured"]

    url = "https://newsapi.org/v2/everything"
    params = {
        "q": query,
        "language": "en",
        "sortBy": "publishedAt",
        "pageSize": limit,
        "apiKey": NEWS_API_KEY,
    }

    try:
        response = requests.get(url, params=params, timeout=5)
        data = response.json()

        articles = data.get("articles", [])
        headlines = [a["title"] for a in articles if a.get("title")]

        return headlines or ["No major market news found"]

    except Exception as e:
        return ["Failed to fetch news"]
    


from difflib import SequenceMatcher

def normalize(text):
    return text.lower().strip()

def is_similar(a, b, threshold=0.8):
    return SequenceMatcher(None, a, b).ratio() >= threshold

def deduplicate_headlines_fuzzy(headlines):
    unique = []
    seen_normalized = []

    for h in headlines:
        norm = normalize(h)

        if not any(is_similar(norm, s) for s in seen_normalized):
            seen_normalized.append(norm)
            unique.append(h)

    return unique

HIGH_IMPACT = {
    "earnings", "revenue", "profit", "guidance",
    "fed", "inflation", "interest rates",
    "crash", "rally", "surge", "plunge",
    "acquisition", "merger", "layoffs"
}

MEDIUM_IMPACT = {
    "stock", "shares", "market", "index",
    "growth", "demand", "forecast"
}

LOW_SIGNAL = {
    "opinion", "interview", "rumors", "speculation"
}

def relevance_score(headline):
    text = headline.lower()
    score = 0

    for word in HIGH_IMPACT:
        if word in text:
            score += 2

    for word in MEDIUM_IMPACT:
        if word in text:
            score += 1

    for word in LOW_SIGNAL:
        if word in text:
            score -= 1

    return score

def filter_relevant_headlines(headlines, min_score=1):
    scored = [
        (h, relevance_score(h))
        for h in headlines
    ]

    filtered = [
        h for h, score in scored
        if score >= min_score
    ]

    return filtered

def weighted_sentiment(headlines, analyzer):
    total_weighted = 0
    total_weight = 0

    for h in headlines:
        sentiment = analyzer.polarity_scores(h)["compound"]
        weight = relevance_score(h)

        
        if weight <= 0:     # ignore weak or noisy headlines
            continue

        total_weighted += sentiment * weight
        total_weight += weight

    if total_weight == 0:
        return 0.0

    return total_weighted / total_weight


