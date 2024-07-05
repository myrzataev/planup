part of 'create_new_good_bloc.dart';

@immutable
class CreateNewGoodEvent {
  final String id;
  final String barcode;
  final String goodStatusId;
  final String productType;
  final File? photo;
  const CreateNewGoodEvent(
      {required this.id,
      required this.barcode,
      required this.goodStatusId,
      required this.productType,
      this.photo});
}
