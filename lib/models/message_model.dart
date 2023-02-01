class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel(
      {this.messageId, this.sender, this.text, this.seen, this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon
    };
  }
}
