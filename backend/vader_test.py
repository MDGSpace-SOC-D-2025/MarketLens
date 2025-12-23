from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

analyzer = SentimentIntensityAnalyzer()

headlines = [
    "Markets rally as inflation cools",
    "Tech stocks fall amid recession fears",
    "Investors remain cautious ahead of Fed meeting",
    "Strong earnings boost market confidence"
]

print("Individual Sentiment Scores:")
for h in headlines:
    scores = analyzer.polarity_scores(h)
    print(f"\nHeadline: {h}")
    print(scores)

def sentiment_to_mei(compound):
    return int((compound + 1) * 50)

compounds = [analyzer.polarity_scores(h)["compound"] for h in headlines]
average_sentiment = sum(compounds) / len(compounds)
mei = sentiment_to_mei(average_sentiment)

print("\n📊 MARKET EMOTION INDEX (MEI):", mei)
