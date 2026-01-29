import 'package:flutter/material.dart';
import 'package:marketlens/mei_service.dart';

class ChatAssistantPage extends StatefulWidget {
  final String stockCode;
  final String? initialQuestion;
  const ChatAssistantPage({super.key, required this.stockCode, this.initialQuestion});

  @override
  State<ChatAssistantPage> createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> messages = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null) {
    _controller.text = widget.initialQuestion!;
    }

    // Initial greeting from bot
    messages.add(
      _ChatMessage(
        role: ChatRole.assistant,
        content:
            "Hi 👋 I’m MarketLens. Ask me anything about market sentiment, trends, or risks.",
            
      ),
    );
  }
//4
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() { 
      messages.add(
        _ChatMessage(role: ChatRole.user, content: text),
      );
      isLoading = true;
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final reply = await MEIService()
          .sendAssistantQuery(widget.stockCode, text);

      setState(() {
        messages.add(
          _ChatMessage(role: ChatRole.assistant, content: reply),
        );
      });
    } catch (_) {
      setState(() {
        messages.add(
          _ChatMessage(
            role: ChatRole.assistant,
            content:
                "Sorry, I ran into an issue fetching insights. Please try again.",
          ),
        );
      });
    }

    setState(() => isLoading = false);
    _scrollToBottom();
  }
//3
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) { //Wait until the ListView knows its new height, THEN scroll
    //Scroll happens after message is rendered
      if (_scrollController.hasClients) { //a scrollable widget like list view is attached
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /* Called:

After user sends a message

After assistant replies

So every new message -> auto scroll*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MarketLens 🤖"),
      ),
      body: Column(
        children: [
          // CHAT MESSAGES
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("MarketLens is thinking... 🤔"),
            ),

          // INPUT BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask about the market...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ChatRole { user, assistant }
//1
class _ChatMessage {
  final ChatRole role;
  final String content;

  _ChatMessage({required this.role, required this.content});
}
//2
class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blueAccent
              : Colors.grey.withAlpha(30),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
