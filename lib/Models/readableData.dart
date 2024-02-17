class ReadableData{
  String pdfUrl;
  String title;

  ReadableData({required this.title, required this.pdfUrl});

  Map<String, dynamic> toJson() => {"pdfUrl" : pdfUrl, "title" : title};

  ReadableData.fromList(snapshot) :
      pdfUrl = snapshot.data()['pdfUrl'],
      title = snapshot.data()['title'];
}