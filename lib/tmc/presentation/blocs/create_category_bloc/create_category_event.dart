part of 'create_category_bloc.dart';

@immutable
class CreateCategoryEvent {
  final String urlRoute;
  final String productManufactureId;
  final String cost;
  final String productModelId;
  const CreateCategoryEvent(
      {required this.cost,
      required this.productManufactureId,
      required this.productModelId,
      required this.urlRoute});
}
