import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:thevoice2/SystemUiValues.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, required this.file});

  final File file;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    final filename = basename(widget.file.path);
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      appBar: AppBar(
        title: Text(
          filename,
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: PDFView(
        filePath: widget.file.path,
        swipeHorizontal: false,
        pageSnap: true,
        autoSpacing: true,
        fitEachPage: true,

      ),
    );
  }
}
