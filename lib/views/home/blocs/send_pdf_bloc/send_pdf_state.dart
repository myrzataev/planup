part of 'send_pdf_bloc.dart';

@immutable
sealed class SendPdfState {}

final class SendPdfInitial extends SendPdfState {}

final class SendPdfLoading extends SendPdfState {}

final class SendPdfSuccess extends SendPdfState {}

final class SendPdfError extends SendPdfState {}
