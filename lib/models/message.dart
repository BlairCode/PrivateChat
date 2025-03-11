/// Model class representing a chat message.
class Message {
  final int? id; // Nullable, as it’s assigned by the database for new messages
  final String content;
  final bool isSentByMe;
  final DateTime timestamp;

  Message({
    this.id, // Optional, null for new messages
    required this.content,
    required this.isSentByMe,
    required this.timestamp,
  });
}
