def build_market_context(data):
    return f"""
    Market Snapshot:
    - MEI: {data['MEI']}
    - Trend: {data['Trend']['direction']}
    - Momentum Score: {data['Momentum Score']['value']} ({data['Momentum Score']['strength']})
    - Volatility: {data['Volatility Indicator']['level']}
    """

def chat_response(context, user_query):
    # Placeholder logic (LLM-ready)
    return f"""
    Based on current data, here's the analysis:

    {context}

    Your question: "{user_query}"

    Interpretation:
    The market conditions suggest cautious optimism with momentum-driven movement.
    """
