def explain_momentum(momentum, lookback):
    if momentum > 5:
        return f"MEI increased sharply over the last {lookback} intervals, showing strong positive momentum."
    elif momentum > 0:
        return f"MEI rose slightly in the last {lookback} intervals, indicating mild optimism."
    elif momentum < -5:
        return f"MEI dropped sharply over the last {lookback} intervals, signaling strong bearish pressure."
    elif momentum < 0:
        return f"MEI declined slightly over the last {lookback} intervals, suggesting weakening sentiment."
    else:
        return "MEI remained largely unchanged, showing neutral momentum."


def explain_volatility(level):
    return {
        "low": "Market sentiment is stable with minimal fluctuations.",
        "medium": "Market sentiment is moderately volatile with noticeable swings.",
        "high": "Market sentiment is highly volatile, suggesting uncertainty or rapid sentiment shifts."
    }.get(level, "Volatility level unclear.")


def explain_trend(direction):
    if "📈 rising" in direction:
        return "Overall sentiment trend is upward, indicating increasing market optimism."
    elif "📉 falling" in direction:
        return "Overall sentiment trend is downward, reflecting growing pessimism."
    else:
        return "Market sentiment trend is currently sideways or uncertain."
