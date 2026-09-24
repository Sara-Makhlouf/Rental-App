import 'package:flutter/material.dart';

class MessageListPage extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {"name": "Alice", "lastMsg": "Hey, how are you?", "time": "2:45 PM"},
    {"name": "Bob", "lastMsg": "Let's meet tomorrow.", "time": "1:30 PM"},
    {
      "name": "Charlie",
      "lastMsg": "Sent you the documents.",
      "time": "12:15 PM",
    },
    {"name": "Diana", "lastMsg": "Thanks for your help!", "time": "Yesterday"},
  ];

  MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages"), backgroundColor: Colors.teal),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return chatTile(
            context,
            chat["name"]!,
            chat["lastMsg"]!,
            chat["time"]!,
          );
        },
      ),
    );
  }

  Widget chatTile(
    BuildContext context,
    String name,
    String lastMsg,
    String time,
  ) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(
          time,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
