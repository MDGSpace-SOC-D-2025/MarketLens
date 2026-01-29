import os
from openai import OpenAI

_client = None  # private singleton


def get_openai_client():
    global _client
    if _client is None:
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise RuntimeError(
                "OPENAI_API_KEY is not set. Assistant feature is disabled."
            )
        _client = OpenAI(api_key=api_key)
    return _client



SYSTEM_PROMPT = """
You are MarketLens, an AI market sentiment assistant.
You explain market behavior clearly to retail investors.
You avoid financial advice.
You use simple, calm, neutral language.
You reference sentiment, trend, momentum, volatility, and recent history when relevant.
If a headline refers to unnamed investors, analysts, or sources, clearly state the source and clarify uncertainty.
Do not invent names, institutions, or positions.
If information is not explicitly available, explain the limitation.

"""


def build_prompt(market_context: dict, user_question: str) -> str:
    article_block = ""

    for a in market_context.get("expanded_articles", []):
        article_block += f"""
        Title: {a['title']}
        Source: {a['source']}
        Content:
        {a['content']}
        ---
        """

    return f"""
    Stock: {market_context['stock']}

    Market Data:
    - MEI: {market_context['mei']} ({market_context['emotion']})
    - Trend: {market_context['trend_direction']}
    - Momentum: {market_context['momentum_value']} ({market_context['momentum_strength']})
    - Volatility: {market_context['volatility']}
    - Alert: {market_context['alert_message']}

    Recent MEI History:
    {market_context['history_summary']}

    Recent News Context:
    {market_context['news_context']}

    Expanded Articles (for explanation only):
    {article_block}

    Instructions:
    - Use expanded articles only to explain context.
    - Do NOT recompute sentiment or MEI.
    - If sources are unnamed, state uncertainty clearly.
    - Do not invent investors, analysts, or institutions.

    User Question:
    {user_question}
    """



def ask_marketlens_ai(market_context: dict, user_question: str) -> str:
    client=get_openai_client()
    prompt = build_prompt(market_context, user_question)

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": prompt},
        ],
        temperature=0.4,
        max_tokens=250,
    )

    return response.choices[0].message.content.strip()
