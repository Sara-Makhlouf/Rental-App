import 'package:flutter/material.dart';
import 'package:rental_appartment/core/services/message_service.dart';
import 'package:rental_appartment/data/models/message.dart';

class OwnerChatPage extends StatefulWidget {
  final int bookingId;
  final int myUserId;
  final int userId;
  final String otherName;

  const OwnerChatPage({
    super.key,
    required this.bookingId,
    required this.myUserId,
    required this.userId,
    required this.otherName,
  });

  @override
  State<OwnerChatPage> createState() => _OwnerChatPageState();
}

class _OwnerChatPageState extends State<OwnerChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
    // تحديث تلقائي كل 4 ثواني
    Future.delayed(const Duration(milliseconds: 500), () {
      _autoRefresh();
    });
  }

  void _autoRefresh() async {
    await fetchMessages();
    Future.delayed(const Duration(seconds: 4), _autoRefresh);
  }

  Future<void> fetchMessages() async {
    try {
      final fetched = await MessageService.getMessages(widget.bookingId);
      setState(() => messages = fetched);
      // Scroll to bottom
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      print("Fetch messages error: $e");
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      await MessageService.sendMessage(7, text);
      _controller.clear();
      fetchMessages();
    } catch (e) {
      print("Send message error: $e");
    }
  }

  Widget _bubble(MessageModel msg) {
    final bool isMe = msg.isMine(widget.myUserId);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.deepPurple : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.message,
              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              msg.time,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherName),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) => _bubble(messages[index]),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
              top: 8,
            ),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
