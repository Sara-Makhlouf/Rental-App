import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rental_appartment/core/services/message_service.dart';
import 'package:rental_appartment/data/models/message.dart';
import 'package:rental_appartment/screens2/bubble.dart';

class ChatScreen extends StatefulWidget {
  final int bookingId;
  final int currentUserId;

  const ChatScreen({
    super.key,
    required this.bookingId,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); 
  bool loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadMessages();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      loadMessages(isAutoRefresh: true);
    });
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); 
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMessages({bool isAutoRefresh = false}) async {
    try {
      final fetchedMessages = await MessageService.getMessages(
       7,
      );

      if (mounted) {
        setState(() {
          messages = fetchedMessages;
          loading = false;
        });

        if (!isAutoRefresh) {
          scrollToBottom();
        }
      }
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    try {
      await MessageService.sendMessage(widget.bookingId, text);
      controller.clear();
      await loadMessages(); 
      scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل إرسال الرسالة، تأكد من الاتصال')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثة'),
        backgroundColor: Colors.deepPurple, 
      ),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? const Center(child: Text('لا توجد رسائل بعد'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return MessageBubble(
                        message: msg.message,
                        isMe: msg.senderId == widget.currentUserId,
                        time: msg.createdAt,
                      );
                    },
                  ),
          ),
          buildInput(),
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 6,
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.deepPurple,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: send,
            ),
          ),
        ],
      ),
    );
  }
}
