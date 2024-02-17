class MessageData{
  String? message;
  String? imageUrl;
  int? likes;
  int? shares;
  String? userImage;
  String? userName;
  String? id;

  MessageData.jsonFrom(snapshot):
      message = snapshot['message'],
      imageUrl = snapshot['imageUrl'],
      likes = snapshot['likes'],
      shares = snapshot['shares'],
      userName = snapshot['userName'],
      userImage = snapshot['userImage'],
      id = snapshot['id'];
}