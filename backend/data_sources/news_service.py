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
