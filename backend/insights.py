def trend_insight(trend: dict, history: list):
    if len(history) < 3:
        return None

    slope = history[-1]["mei"] - history[0]["mei"]

    if slope > 8:
        title = "Strong Uptrend"
        severity = "low"
        insight_type = "positive"
    elif slope > 0:
        title = "Weak Uptrend"
        severity = "medium"
        insight_type = "neutral"
    elif slope < -8:
        title = "Strong Downtrend"
        severity = "high"
        insight_type = "danger"
    else:
        title = "Sideways Market"
        severity = "low"
        insight_type = "neutral"

    return {
        "id": "trend",
        "title": title,
        "message": f"MEI changed by {slope} points over the observed period.",
        "confidence": "High",
        "severity": severity,
        "type": insight_type,
        "metrics": {
            "slope": slope,
            "direction": trend["direction"]
        }
    }


def momentum_insight(momentum: dict):
    value = momentum["value"]

    if value > 8:
        title = "Strong Momentum Expansion"
        severity = "low"
        insight_type = "positive"
    elif value > 0:
        title = "Weak Momentum"
        severity = "medium"
        insight_type = "neutral"
    elif value < -8:
        title = "Sharp Momentum Breakdown"
        severity = "high"
        insight_type = "danger"
    else:
        title = "Momentum Deceleration"
        severity = "medium"
        insight_type = "warning"

    return {
        "id": "momentum",
        "title": title,
        "message": f"Momentum score over lookback window is {value}.",
        "confidence": "High",
        "severity": severity,
        "type": insight_type,
        "metrics": {
            "value": value,
            "lookback": 5
        }
    }


def volatility_insight(volatility: dict):
    level = volatility["level"]

    if level == "high":
        title = "Volatility Expansion"
        severity = "high"
        insight_type = "danger"
    elif level == "medium":
        title = "Moderate Volatility"
        severity = "medium"
        insight_type = "warning"
    else:
        title = "Stable Volatility"
        severity = "low"
        insight_type = "positive"

    return {
        "id": "volatility",
        "title": title,
        "message": f"Market volatility is currently classified as {level}.",
        "confidence": "High",
        "severity": severity,
        "type": insight_type,
        "metrics": {
            "level": level
        }
    }


def risk_insight(trend: dict, momentum: dict, volatility: dict):
    risk_score = 0

    if volatility["level"] == "high":
        risk_score += 2
    if momentum["value"] < 0:
        risk_score += 1
    if trend["direction"] == "📉 falling":
        risk_score += 2

    if risk_score >= 4:
        title = "High Risk Environment"
        severity = "high"
        insight_type = "danger"
    elif risk_score >= 2:
        title = "Elevated Risk"
        severity = "medium"
        insight_type = "warning"
    else:
        title = "Low Risk Conditions"
        severity = "low"
        insight_type = "positive"

    return {
        "id": "risk",
        "title": title,
        "message": f"Composite risk score evaluated at {risk_score}.",
        "confidence": "Medium",
        "severity": severity,
        "type": insight_type,
        "metrics": {
            "risk_score": risk_score
        }
    }


def generate_insights(trend, momentum, volatility, history):
    insights = [
        trend_insight(trend, history),
        momentum_insight(momentum),
        volatility_insight(volatility),
        risk_insight(trend, momentum, volatility),
    ]

    # Remove None safely
    return [i for i in insights if i is not None]
