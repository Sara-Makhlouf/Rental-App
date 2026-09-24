class MessageModel {
  final int id;
  final int senderId;
  final String message;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: int.parse(
        json['sender_id'].toString(),
      ), 
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool isMine(int currentUserId) => senderId == currentUserId;

  String get time =>
      "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}";
}
