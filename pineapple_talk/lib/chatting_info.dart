class ChattingInfo {
  int id = -1;
  String title = '';
  String latestChat = '';
  String latestChatTime = '';
  List<int> participants = [];

  ChattingInfo(this.id, this.title, this.latestChat, this.latestChatTime, this.participants);
}