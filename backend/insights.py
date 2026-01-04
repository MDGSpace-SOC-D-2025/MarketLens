def generate_insight(trend_direction, momentum_score, volatility_level):
    # Strong Bullish Momentum
    if trend_direction == "📈 rising" and momentum_score >= 70 and volatility_level in ["low", "medium"]:
        return {
            "title": "Strong Bullish Momentum",
            "message": "Market shows strong bullish momentum with controlled volatility. Trend-following strategies may perform well.",
            "confidence": "High",
            "type": "positive"
        }

    # Speculative Rally Warning
    if trend_direction == "📈 rising" and momentum_score >= 70 and volatility_level == "high":
        return {
            "title": "Speculative Rally",
            "message": "Rising prices with high volatility suggest speculative behavior. Risk of sharp pullbacks is elevated.",
            "confidence": "Medium",
            "type": "warning"
        }

    # High-Risk Bearish Phase
    if trend_direction == "📉 falling" and volatility_level == "high":
        return {
            "title": "High-Risk Bearish Phase",
            "message": "Market sentiment is deteriorating rapidly. Capital preservation is advised.",
            "confidence": "High",
            "type": "danger"
        }

    # Uncertain / Range-Bound Market
    return {
        "title": "Uncertain Market",
        "message": "Market lacks clear direction. Waiting for confirmation may reduce risk.",
        "confidence": "Low",
        "type": "neutral"
    }
