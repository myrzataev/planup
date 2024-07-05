part of 'edit_good_bloc.dart';

@immutable
class EditGoodEvent {
  final String id;
  final String barcode;
  final String goodStatusId;
  final String productType;
  final File? photo;
  final String deleted;
  final String nazvanieID;

  const EditGoodEvent(
      {required this.id,
      required this.barcode,
      required this.goodStatusId,
      required this.productType,
      required this.deleted,
      required this.nazvanieID,
      this.photo});
}
