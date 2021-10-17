class ChatMessage {
  int from;
  String message;

  ChatMessage({required this.from, required this.message});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(from: json["from"], message: json["message"]);
  }
}
