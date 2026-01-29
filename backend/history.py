MEIHistory={}  #{'code':[{mei:value, date:date},{mei:value, date:date},{mei:value, date:date}]}
               #Act like Queue, Front End --> Dequeue
                                #Rear End --> Enqueue

MEIHistory_maxEntires=40

from mei_from_price import compute_mei_from_prices
from trend_explain import explain_momentum, explain_trend, explain_volatility
from datetime import datetime, timedelta

def addtoMEIHistory(code: str, result: dict):
    if code in MEIHistory:
        MEIHistory[code].append({'mei':result['mei'], 'timestamp': datetime.now()})
        if len(MEIHistory[code])>MEIHistory_maxEntires:
            MEIHistory[code].pop(0)

    if code not in MEIHistory:
        MEIHistory[code]=[]
        MEIHistory[code].append({'mei':result['mei'], 'timestamp': datetime.now()})

def getMEIHistory(code: str):
    
    if code in MEIHistory:
        return MEIHistory[code]
    else:
        return []
        
class AnalyzeHistoricalTrend:
    def __init__(self, code:str, history:list):
        self.code=code
        self.history=history
    
    def sentiment_trend(self):
        if len(self.history)<2:
            return {
                'direction':'Unknown',
                'explanation':'NA'                
            }
        first=self.history[0]['mei']
        latest=self.history[-1]['mei']
        change=latest-first

        if change>0:
            
            return {
                'direction':'📈 rising',  
                'explanation': explain_trend('📈 rising')           
            }
        if change<0:
            return {
                'direction':'📉 falling',
                'explanation': explain_trend('📉 falling')
            }
        if change==0:
            return {
                'direction':'➖ flat', 
                'explanation': explain_trend('➖ flat')           
            }
    def sentiment_momentum_score(self):
        lookback_window=5

        if len(self.history) <= lookback_window:
            return {
                "value": 0,
                "strength": "insufficient data",
                'explanation':'NA'
            }


        latest=self.history[-1]['mei']
        mei_n_points_ago=self.history[-lookback_window]['mei']
        momentum=latest-mei_n_points_ago

        if momentum > 5:
            strength = "strong"
        elif momentum > 0:
            strength = "weak"
        elif momentum < -5:
            strength = "strong bearish"
        elif momentum < 0:
            strength = "weak bearish"
        else:
            strength = "neutral"

        return {
            "value": momentum,
            "strength": strength,       
            'explanation':explain_momentum(momentum, lookback_window)                
        }
    
    def sentimetal_volatility_indicator(self):
        if len(self.history) < 3:
            return {                
                "level": "insufficient data",
                'explanation':'NA'
            }
        changes = []

        for i in range(1, len(self.history)):
            diff = abs(self.history[i]["mei"] - self.history[i-1]["mei"])
            changes.append(diff)

        volatility = sum(changes)/len(changes)

        if volatility > 7:
            level = "high"
        elif volatility > 3:
            level = "medium"
        else:
            level = "low"

        return {
            "level": level,
            'explanation':explain_volatility(level)
        }

import yfinance as yf

def fetch_yahoo_history(code: str):
    ticker = yf.Ticker(code)      #Bind this Python object to this stock symbol

    df = ticker.history(period="1d", interval="1h")

    if df.empty:
        df = ticker.history(period="30d", interval="1d")

    history = []
    for ts, row in df.iterrows():
        history.append({
            "timestamp": ts.to_pydatetime(),  #ts=2024-01-26 10:37:00
                                                #datetime(2024, 1, 26, 10, 37),
            "price": float(row["Close"])
        })

    return history


def bootstrap_mei_history(code: str):
    if code in MEIHistory and len(MEIHistory[code]) >= 5:
        return

    if code not in MEIHistory:
        MEIHistory[code] = []

    raw = fetch_yahoo_history(code)
    if not raw:
        return

    buckets = {}
    for entry in raw:
        bucket = entry["timestamp"].replace(
            minute=0, second=0, microsecond=0
        ) 
        bucket -= timedelta(hours=bucket.hour % 2)   #epresents a duration or difference between two dates or time
        buckets.setdefault(bucket, []).append(entry["price"])
        '''
        {
  datetime(2024,1,26,10,0): [182.3, 182.7, 183.1],
  datetime(2024,1,26,12,0): [181.9, 181.4],
}

        '''

    for ts in sorted(buckets.keys()): #time ordered
        prices = buckets[ts]
        if len(prices) < 2:
            continue

        mei = int(round(compute_mei_from_prices(prices)))
        MEIHistory[code].append({
            "mei": mei,
            "timestamp": ts
        })

        if len(MEIHistory[code]) > MEIHistory_maxEntires:
            MEIHistory[code].pop(0)

