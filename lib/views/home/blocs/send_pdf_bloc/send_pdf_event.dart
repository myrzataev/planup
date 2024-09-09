part of 'send_pdf_bloc.dart';

@immutable
class SendPdfEvent {
  final String lsAbonent;
  final File pdf;
  const SendPdfEvent({required this.lsAbonent, required this.pdf});
}
