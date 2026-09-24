import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/screens2/chat.dart';

class OwnerInboxPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();



  OwnerInboxPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المحادثات الواردة")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where(
              'ownerId',
              isEqualTo: authController.user.value?['id']?.toString() ?? '',
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatData = chats[index];
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(chatData['userName']), 
                subtitle: Text(chatData['lastMessage']), 
                onTap: () {
                  Get.to(
                    () => OwnerChatPage(
                      bookingId: chatData['bookingId'],
                      myUserId: chatData['ownerId'],
                      userId: chatData['userId'], 
                      otherName: chatData['userName'],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
