import time

cache={}
cache_ttl=45  #45seconds

def get_cache(code: str):
    data=cache.get(code)

    if not data:
        return None
    
    if time.time()-data['timestamp']>cache_ttl:
        del cache[code]
        return None
    
    return data

def set_cache(code: str, result: dict):
    result['timestamp']=time.time()   
    cache[code]=result