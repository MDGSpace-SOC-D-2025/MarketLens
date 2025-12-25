from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from fastapi import FastAPI
import datetime
app=FastAPI()

analyzer=SentimentIntensityAnalyzer()

headlines = [
    "Market rally as inflation cools",
    "Investors remain cautious ahead of Fed meeting",
    "Strong Earnings boost market confidence"
]

mei=0 

@app.get("/mei")
def getMEI():
    global mei
    compound_score=0
    for headline in headlines:
        compound_score+=analyzer.polarity_scores(headline)["compound"]        
    avg_compound=compound_score/len(headlines)
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


