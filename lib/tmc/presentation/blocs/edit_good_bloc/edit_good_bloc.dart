import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';
import 'package:planup/tmc/data/repositories/edit_good_repo_impl.dart';

part 'edit_good_event.dart';
part 'edit_good_state.dart';

class EditGoodBloc extends Bloc<EditGoodEvent, EditGoodState> {
  EditGoodRepoImpl repoImpl;
  EditGoodBloc({required this.repoImpl}) : super(EditGoodInitial()) {
    on<EditGoodEvent>((event, emit) async {
      emit(EditGoodLoading());
      try {
        final result = await repoImpl.editGood(
            id: event.id,
            barcode: event.barcode,
            goodStatusId: event.goodStatusId,
            productType: event.productType,
            nazvanieID: event.nazvanieID,
            deleted: event.deleted);
        emit(EditGoodSuccess(model: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(EditGoodError(errorText: "У вас нет доступа"));
        } else {
          emit(EditGoodError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(EditGoodError(errorText: e.toString()));
      }
    });
  }
}
