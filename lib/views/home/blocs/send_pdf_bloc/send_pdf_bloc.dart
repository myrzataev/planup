import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planup/views/home/repositories/send_pdf_repo.dart';

part 'send_pdf_event.dart';
part 'send_pdf_state.dart';

class SendPdfBloc extends Bloc<SendPdfEvent, SendPdfState> {
  SendPdfRepo repo;
  SendPdfBloc({required this.repo}) : super(SendPdfInitial()) {
    on<SendPdfEvent>((event, emit) async {
      emit(SendPdfLoading());
      try {
        await repo.sendPDF(pdf: event.pdf, lsAbonent: event.lsAbonent);
        emit(SendPdfSuccess());
      } catch (e) {
        emit(SendPdfError());
      }
    });
  }
}
