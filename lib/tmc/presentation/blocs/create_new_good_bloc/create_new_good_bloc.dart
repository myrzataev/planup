import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';
import 'package:planup/tmc/data/repositories/create_new_good_impl.dart';

part 'create_new_good_event.dart';
part 'create_new_good_state.dart';

class CreateNewGoodBloc extends Bloc<CreateNewGoodEvent, CreateNewGoodState> {
  CreateNewGoodImpl repoImpl;
  CreateNewGoodBloc({required this.repoImpl}) : super(CreateNewGoodInitial()) {
    on<CreateNewGoodEvent>((event, emit) async {
      emit(CreateNewGoodLoading());
      try {
        final result = await repoImpl.createNewGood(
            id: event.id,
            barcode: event.barcode,
            goodStatusId: event.goodStatusId,
            productType: event.productType);
        emit(CreateNewGoodSuccess(model: result));
      } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(CreateNewGoodError(errorText: "У вас нет доступа"));
      } else {
        emit(CreateNewGoodError(errorText: "Произошла ошибка: ${e.message}"));
      }}
      catch (e) {
        emit(CreateNewGoodError(errorText: e.toString()));
      }
    });
  }
}
