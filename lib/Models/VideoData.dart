class VideoData{
  String videoUrl;
  String title;
  String thumbnail;

  VideoData({required this.title, required this.videoUrl, required this.thumbnail});

  Map<String, dynamic> toJson() => {"videoUrl" : videoUrl, "title" : title, "thumbnail" : thumbnail};

  VideoData.fromList(snapshot) :
      videoUrl = snapshot.data()['videoUrl'],
      title = snapshot.data()['title'],
      thumbnail = snapshot.data()['thumbnail'];

}