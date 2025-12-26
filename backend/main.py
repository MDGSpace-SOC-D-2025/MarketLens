from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from fastapi import FastAPI
from cache import get_cache, set_cache
import datetime
app=FastAPI()

analyzer=SentimentIntensityAnalyzer()

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
}


mei=0 

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

@app.get("/stock/{code}")
def get_stock_sentiment(code:str):
    code=code.upper()

    if code not in STOCK_HEADLINES:
        return {'error':'Unknown stock: not traceable'}
    
    result=get_cache(code)

    if result:
        return result
    
    print("📈 MEI CALCULATING FOR STOCK CODE", code)

    
    headlines=STOCK_HEADLINES[code]
    global mei
    compound_score=0
    for headline in headlines:
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
    
    result={
        "code":code,
        "mei":mei,
        "trend":trend,
        "headlines":headlines        
    }
    set_cache(code, result)
    return result



