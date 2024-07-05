part of 'get_manufactures_list_bloc.dart';

@immutable
sealed class GetManufacturesListState {}

final class GetManufacturesListInitial extends GetManufacturesListState {}

final class GetManufacturesListLoading extends GetManufacturesListState {}

final class GetManufacturesListSuccess extends GetManufacturesListState {
  final List<ManufactureModel> listModel;
  GetManufacturesListSuccess({required this.listModel});
}

final class GetManufacturesListError extends GetManufacturesListState {
  final String errorText;
  GetManufacturesListError({required this.errorText});
}
