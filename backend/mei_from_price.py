import numpy as np

def compute_mei_from_prices(prices, window=20):
    """
    Market Emotion Index (MEI) from a list of prices.

    prices : list[float]  -> ordered oldest → latest
    window : int          -> lookback window for volatility

    returns : float       -> MEI in range [-100, 100]
    """

    # Safety checks
    if prices is None or len(prices) < window + 1:
        return 0.0

    prices = np.array(prices, dtype=float)

    # Step 1: compute returns
    returns = np.diff(prices) / prices[:-1]

    # Step 2: latest price change
    latest_return = returns[-1]

    # Step 3: rolling volatility
    volatility = np.std(returns[-window:])

    if volatility == 0:
        return 0.0

    # Step 4: normalize & bound
    mei = np.tanh(latest_return / volatility) * 100

    return round(float(mei), 2)
