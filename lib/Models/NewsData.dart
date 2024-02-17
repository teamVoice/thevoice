class NewsData {
  final String title;
  final String content;
  final String urlToImage;

  const NewsData(
      {required this.title, required this.content, required this.urlToImage});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "title": String title,
        "content": String content,
        "urlToImage": String urlToImage
      } =>
        NewsData(title: title, urlToImage: urlToImage, content: content),
      _ => throw const FormatException("Failed to load news data!"),
    };
  }
}
