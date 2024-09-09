import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

class PdfService {
  Future<File> createAndCompressPdf(List<File?> images, {required String fileName}) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    return compute(_createAndCompressPdf,
        {'images': images.map((e) => e?.path).toList(), 'tempPath': tempPath, "fileName": fileName});
  }

  static Future<File> _createAndCompressPdf(Map<String, dynamic> params, ) async {
    final List<String?> imagePaths = params['images'] as List<String?>;
    final tempPath = params['tempPath'] as String;
    final fileName = params["fileName"] as String;

    final pdf = pw.Document();

    for (var imagePath in imagePaths) {
      if (imagePath != null) {
        final imageFile = File(imagePath);
        final imageBytes = await imageFile.readAsBytes();
        img.Image? decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          img.Image resizedImage = img.copyResize(decodedImage, width: 800);
          final resizedImageBytes =
              Uint8List.fromList(img.encodeJpg(resizedImage, quality: 75));
          final pdfImage = pw.MemoryImage(resizedImageBytes);

          pdf.addPage(pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(pdfImage));
            },
          ));
        }
      }
    }

    final file = File("$tempPath/$fileName.pdf");
    await file.writeAsBytes(await pdf.save());

    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    print("File size: ${fileSizeInMB.toStringAsFixed(2)} MB");

    return file;
  }
}
