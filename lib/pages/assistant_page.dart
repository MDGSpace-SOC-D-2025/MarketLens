import 'package:flutter/material.dart';
import 'package:marketlens/pages/bot_ask_anything.dart';
import 'package:marketlens/mei_service.dart';

class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Assistant 🤖"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            AssistantButton(
              icon: Icons.trending_up,
              title: "Explain Market Trend",
              subtitle: "Why is the market behaving this way?",
              
                onTap: () async {
                  final explanation = await MEIService().fetchMEItrend("AAPL");
                  String Trend_explain=explanation['Trend']['explanation'];
                  String Mom_explain= explanation['Momentum Score']['explanation'];
                  String Vol_explain=explanation['Volatility Indicator']['explanation'];
                  String final_explanation='$Trend_explain $Mom_explain $Vol_explain';

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Market Explanation"),
      content: Text(final_explanation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Got it"),
        ),
      ],
    ),
  );
},
// Explain trend
              
            ),

            AssistantButton(
              icon: Icons.flash_on,
              title: "Momentum Breakdown",
              subtitle: "Understand momentum & strength",
              onTap: () {
                // 
              },
            ),

            AssistantButton(
              icon: Icons.warning_amber_rounded,
              title: "Risk & Alerts",
              subtitle: "What risks should I know?",
              onTap: () {
                // 
              },
            ),

            AssistantButton(
              icon: Icons.chat_bubble_outline,
              title: "Ask Anything",
              subtitle: "Free-form market questions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatAssistantPage(stockCode: "AAPL"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class AssistantButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AssistantButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

