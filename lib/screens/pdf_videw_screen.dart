import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewScreen extends StatefulWidget {
  final String languageCode;
  PdfViewScreen(this.languageCode);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  String fileName;
  PdfController pdfController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileName = widget.languageCode;
    pdfController = PdfController(
        document: PdfDocument.openAsset('assets/files/$fileName.pdf'),
        viewportFraction: 1.3);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: PdfView(
          pageSnapping: false,
          controller: pdfController,
        )),
      ),
    );
  }
}
