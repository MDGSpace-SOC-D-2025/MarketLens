import requests
import os

NEWS_API_KEY = os.getenv("NEWS_API_KEY")



from difflib import SequenceMatcher

def normalize(text: str):
    return text.lower().strip()


def is_similar(a: str, b: str, threshold=0.8):
    return SequenceMatcher(None, a, b).ratio() >= threshold


def deduplicate_headlines_fuzzy(articles):
    unique = []
    seen_titles = []

    for article in articles:
        title = article.get("title", "")
        if not title:
            continue

        norm = normalize(title)  #error

        if not any(is_similar(norm, s) for s in seen_titles):
            seen_titles.append(norm)
            unique.append(article)

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

def fetch_headlines(query: str, limit: int = 100):
    if not NEWS_API_KEY:
        return []

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

        structured = []
        for a in articles:
            if not a.get("title"):
                continue

            structured.append({
                "title": a["title"],
                "source": a["source"]["name"] if a.get("source") else "Unknown",
                "author": a.get("author"),
                "url": a.get("url"),
                "published_at": a.get("publishedAt"),
                "description": a.get("description"),
            })

        return structured

    except Exception:
        return []

def filter_relevant_headlines(articles, min_score=1):
    filtered = []

    for article in articles:
        title = article.get("title", "")
        if not title:
            continue

        score = relevance_score(title)
        if score >= min_score:
            filtered.append(article)

    return filtered


def weighted_sentiment(articles, analyzer):
    total_weighted = 0
    total_weight = 0

    for a in articles:
        title = a["title"]
        sentiment = analyzer.polarity_scores(title)["compound"]
        weight = relevance_score(title)

        if weight <= 0:
            continue

        total_weighted += sentiment * weight
        total_weight += weight

    if total_weight == 0:
        return 0.0

    return total_weighted / total_weight



