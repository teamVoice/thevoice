class PdfModel{
  String? title;

  PdfModel({required this.title});

  PdfModel.fromList(snapshot) :
        title = snapshot.data()['title'];
}