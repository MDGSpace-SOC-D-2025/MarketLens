# MarketLens 
### AI-Powered Market Sentiment & Insight Platform

MarketLens is a full-stack market sentiment analysis platform that combines
real-time news sentiment, historical price behavior, and AI-generated insights
to help users understand market emotion rather than predict prices.

Instead of giving financial advice, MarketLens focuses on explaining:
- how the market is behaving,
- what direction sentiment is moving,
- how strong the momentum is,
- and how volatile recent conditions have been.

The system is designed for retail investors and learners who want
clear, explainable market intelligence.

### Core Features

- 📈 **Market Emotion Index (MEI)**
  - A normalized 0–100 sentiment index derived from:
    - weighted news sentiment
    - historical price movement
  - Designed for interpretability, not prediction

- 📰 **Smart News Analysis**
  - Fetches market-relevant headlines
  - Deduplicates similar news using fuzzy matching
  - Filters low-signal headlines
  - Assigns relevance-weighted sentiment scores

- 🧠 **Historical Trend Analysis**
  - Tracks MEI over time
  - Computes:
    - sentiment trend (rising / falling / flat)
    - momentum strength
    - volatility level

- 🚨 **Alert System**
  - Generates alerts based on:
    - extreme sentiment
    - momentum shifts
    - volatility spikes
  - Displays factors contributing to alerts

- 🤖 **AI Market Assistant**
  - Uses contextual market data
  - Explains trends in plain language
  - Explicitly avoids financial advice

- 📱 **Flutter Frontend**
  - Live MEI gauge
  - Trend charts and sparklines
  - News cards with AI follow-up
  - Clean, reactive UI

### Frontend
- Flutter (Dart)
- Provider + ChangeNotifier (State Management)
- fl_chart (Charts & Sparklines)

### Backend
- Python
- FastAPI (REST API)
- VADER Sentiment Analysis
- Yahoo Finance (historical price data)
- NewsAPI (market headlines)
- BeautifulSoup (article extraction)

### AI
- OpenAI API (context-aware market explanations)

### Architecture
- Client–Server model
- In-memory caching with TTL
- Modular service-based backend

### Backend Setup

1. Clone the repository
2. Create a virtual environment
3. Install dependencies
```bash
pip install -r requirements.txt
```
4. Set Environment Variables (see configuration)
5. Run the Server

uvicorn main:app --reload

### Frontend Setup
1. Navigate to the Flutter project
2. Install dependencies
```bash
flutter pub get
```
3. Run the app
```bash
flutter pub get
```


---
##  Usage

```markdown
- Select or search for a stock symbol
- View:
  - current Market Emotion Index
  - historical sentiment trend
  - momentum and volatility indicators
- Browse filtered market news
- Tap a news card to:
  - read the full article
  - ask the AI assistant about its impact
- View alerts and system-generated insights
```

## Configuration / Environment Variables

The following environment variables are required:

- `NEWS_API_KEY`  
  Used to fetch market news headlines

- `OPENAI_API_KEY`  
  Used by the AI market assistant

Example (Linux / macOS):

```bash
export NEWS_API_KEY=your_key_here
export OPENAI_API_KEY=your_key_here
```

---

##  Screenshots / Demo


### Screenshots

- MEI Gauge
- Trend Chart
- News Page
- Insights Page
- AI Assistant Response

## Project Structure
marketlens/
│
├── frontend/
│   ├── main.dart
│   ├── market_state.dart
│   ├── pages/
│   ├── widgets/
│
├── backend/
│   ├── main.py
│   ├── stock_service.py
│   ├── news_service.py
│   ├── history.py
│   ├── market_snapshot.py
│   ├── assistant_ai.py
│   ├── alerts.py
│   └── insights.py
│
└── README.md

## Known Issues / Limitations

- MEI history is stored in memory (resets on server restart)
- News availability depends on NewsAPI limits
- AI assistant responses depend on external API availability
- Price-based MEI is sensitive to low-liquidity data
- This project does NOT provide financial advice

## Roadmap
### Planned Improvements

- Persistent database for MEI history
- Multi-stock comparison view
- Sector-level sentiment analysis
- Rate-limit handling and retry logic
- Dark/light theme toggle








