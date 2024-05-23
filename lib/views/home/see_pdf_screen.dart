import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_file/internet_file.dart';
// import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:pdfx/pdfx.dart';

class PdfScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfScreen({super.key, required this.pdfUrl});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late PdfControllerPinch controller;
  // late PdfViewerController _controller;

  @override
  void initState() {
    try {
      controller = PdfControllerPinch(
          document: PdfDocument.openData(InternetFile.get(
              "https://drive.usercontent.google.com/download?id=1exSWPCdwgc7uKH7gc-H1hRsd0DfVB6kH&export=download&authuser=0")));
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle error, for example, display an error message to the user
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PDF"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                color: Colors.white,
                semanticLabel: 'Bookmark',
              ),
              onPressed: () {
                // _pdfViewerKey.currentState?.openBookmarkView();
              },
            ),
          ],
        ),
        body: 
        // PdfViewer.openFutureFile(
        //   // Accepting function that returns Future<String> of PDF file path
        //   () async => (await DefaultCacheManager().getSingleFile(
        //           'https://github.com/espresso3389/flutter_pdf_render/raw/master/example/assets/hello.pdf'))
        //       .path,
        //   // viewerController: controller,
        //   onError: (err) => print(err),
        //   params: const PdfViewerParams(
        //     padding: 10,
        //     minScale: 1.0,
        //     // scrollDirection: Axis.horizontal,
        //   ),
        // )
        Column(
          children: [
            Expanded(
                child: PdfViewPinch(
                    builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                      options: const DefaultBuilderOptions(),
                      documentLoaderBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      pageLoaderBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      errorBuilder: (_, error) =>
                          Center(child: Text(error.toString())),
                    ),
                    controller: controller)),
          ],
        )
        );
  }
}
