def generate_alert(mei, trend, momentum, volatility):
    reason = (
    f"MEI is {mei}, momentum is {momentum}, "
    f"and volatility is {volatility}"
    )

    factors={
        'mei':mei,
        'momentum':momentum,
        'volatility':volatility
    }

    if mei <= 25:
        return {"level": "critical", "message": "🚨 Extreme fear detected in the market", "reason":reason, "factors":factors}

    if mei >= 80:
        return {"level": "critical", "message": "🚨 Extreme greed — market overheating", "reason":reason, "factors":factors}

    if trend == "down" and volatility == "high":
        return {"level": "critical", "message": "🚨 Panic risk: falling trend with high volatility", "reason":reason, "factors":factors}

    if 25 < mei <= 40:
        return {"level": "warning", "message": "⚠️ Fear zone — investors are cautious", "reason":reason, "factors":factors}

    if 60 <= mei < 75:
        return {"level": "warning", "message": "⚠️ Greed building — watch for reversals", "reason":reason, "factors":factors}

    return {"level": "info", "message": "ℹ️ Market sentiment stable", "reason":reason, "factors":factors}
