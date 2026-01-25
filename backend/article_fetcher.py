import requests
from bs4 import BeautifulSoup

HEADERS = {
    "User-Agent": "Mozilla/5.0 (MarketLens Research Bot)"
}

def fetch_article_text(url: str, max_chars: int = 4000):
    try:
        res = requests.get(url, headers=HEADERS, timeout=6)
        if res.status_code != 200:
            return None

        soup = BeautifulSoup(res.text, "html.parser")

        # remove scripts & junk
        for tag in soup(["script", "style", "noscript"]):
            tag.decompose()

        paragraphs = [p.get_text() for p in soup.find_all("p")]
        text = "\n".join(paragraphs)
        
        return text.strip()[:max_chars]

    except Exception as e:
            print("❌ Error while fetching:", url)
            traceback.print_exc()
            return None

