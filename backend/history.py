MEIHistory={}  #{'code':[{mei:value, date:date},{mei:value, date:date},{mei:value, date:date}]}
               #Act like Queue, Front End --> Dequeue
                                #Rear End --> Enqueue

MEIHistory_maxEntires=20

import datetime

def addtoMEIHistory(code: str, result: dict):
    if code in MEIHistory:
        MEIHistory[code].append({'mei':result['mei'], 'timestamp': datetime.datetime.now()})
        if len(MEIHistory[code])>MEIHistory_maxEntires:
            MEIHistory[code].pop(0)

    if code not in MEIHistory:
        MEIHistory[code]=[]
        MEIHistory[code].append({'mei':result['mei'], 'timestamp': datetime.datetime.now()})

def getMEIHistory(code: str):
    
    if code in MEIHistory:
        return MEIHistory[code]
    else:
        return None
        

    