class ChartRoomModel {
  String? chatRoomId;
  List<String>? participants;

  ChartRoomModel({this.chatRoomId, this.participants});
  ChartRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["chatRoomId"];
    participants = map["participants"];
  }
  Map<String, dynamic> toMap() {
    return {"chatRoomId": chatRoomId, "participants": participants};
  }
}
