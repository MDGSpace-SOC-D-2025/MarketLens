import 'package:flutter/material.dart';
import 'package:marketlens/mei_service.dart';

class ChatAssistantPage extends StatefulWidget {
  final String stockCode;
  const ChatAssistantPage({super.key, required this.stockCode});

  @override
  State<ChatAssistantPage> createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  String response = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ask MarketLens 🤖")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ask anything about the market...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);

                final reply = await MEIService()
                    .sendAssistantQuery(widget.stockCode, _controller.text);

                setState(() {
                  response = reply;
                  isLoading = false;
                });
              },
              child: const Text("Ask"),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (response.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(response),
                ),
              )
          ],
        ),
      ),
    );
  }
}
