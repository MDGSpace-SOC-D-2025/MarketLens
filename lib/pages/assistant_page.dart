import 'package:flutter/material.dart';
import 'package:marketlens/pages/bot_ask_anything.dart';

class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MarketLens Assistant "),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            
            //
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 121, 165, 241).withValues(alpha: .08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hi, I’m MarketLens ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "I analyze market sentiment, trends, risks, and news to help you understand what’s really happening — in simple words.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(221, 255, 255, 255),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            //  SUGGESTED PROMPTS
            const Text(
              "You can ask things like:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            _PromptChip(text: "Why is sentiment falling today?"),
            _PromptChip(text: "Is this stock risky right now?"),
            _PromptChip(text: "Explain the MEI chart in simple terms"),
            _PromptChip(text: "What should I watch out for today?"),

            const Spacer(),

            //  PRIMARY CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text(
                  "Start Conversation",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ChatAssistantPage(stockCode: "AAPL"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///  Prompt Chip Widget
class _PromptChip extends StatelessWidget {
  final String text;

  const _PromptChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline,
              size: 18, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
