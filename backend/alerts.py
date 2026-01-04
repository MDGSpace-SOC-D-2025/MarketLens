def generate_alert(mei, trend, momentum, volatility):
    alert = {
        "level": "LOW",
        "title": "Market Stable",
        "message": "",
        "factors": []
    }

    # HIGH RISK CONDITIONS 
    if trend == "📉 falling" and momentum['strength'] in ["strong bearish", "weak bearish"]:
        alert["level"] = "HIGH"
        alert["title"] = "Downside Risk Increasing"
        alert["message"] = (
            "Market momentum is weakening while trend is falling. "
            "Risk of correction or sharp move is elevated."
        )

    # MEDIUM RISK CONDITIONS 
    elif momentum['strength'] == "weak bearish" or volatility == "high":
        alert["level"] = "MEDIUM"
        alert["title"] = "Market Entering Uncertainty"
        alert["message"] = (
            "Momentum is weakening or volatility is rising. "
            "Market conditions may change soon."
        )

    # LOW RISK 
    else:
        alert["message"] = (
            "Market trend and momentum are stable. "
            "No immediate risk signals detected."
        )

    # MEI CONTEXT (EXPLANATION, NOT DECISION) 
    if mei >= 70:
        alert["factors"].append("Sentiment is greedy")
    elif mei <= 40:
        alert["factors"].append("Sentiment is fearful")
    else:
        alert["factors"].append("Sentiment is neutral")

    alert["factors"].extend([
        f"Trend: {trend}",
        f"Momentum: {momentum['value']} ({momentum['strength']})",
        f"Volatility: {volatility}"
    ])

    return alert
