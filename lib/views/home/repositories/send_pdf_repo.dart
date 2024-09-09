import 'dart:io';

import 'package:dio/dio.dart';

class SendPdfRepo {
  final Dio dio;
  SendPdfRepo({required this.dio});
  Future<void> sendPDF({required File pdf, required String lsAbonent}) async {
    String fileName = pdf.path.split('/').last;

    final response =
        await dio.post("http://planup.skynet.kg:8000/planup/uploadhydra/",
            data: FormData.fromMap({
              "ls_abonent": lsAbonent,
              "file": await MultipartFile.fromFile(pdf.path, filename: fileName)
            }));
   
  }
}
