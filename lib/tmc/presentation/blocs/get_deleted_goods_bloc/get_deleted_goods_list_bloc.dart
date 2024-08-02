import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/deleted_goods_model.dart';
import 'package:planup/tmc/data/repositories/get_deleted_goods_impl.dart';

part 'get_deleted_goods_list_event.dart';
part 'get_deleted_goods_list_state.dart';

class GetDeletedGoodsListBloc
    extends Bloc<GetDeletedGoodsListEvent, GetDeletedGoodsListState> {
  GetDeletedGoodsImpl repoImpl;
  GetDeletedGoodsListBloc({required this.repoImpl})
      : super(GetDeletedGoodsListInitial()) {
    on<GetDeletedGoodsListEvent>((event, emit) async {
      emit(GetDeletedGoodsListLoading());
      try {
        final result = await repoImpl.getDeletedGoodsList();
        emit(GetDeletedGoodsListSuccess(modelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetDeletedGoodsListError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(GetDeletedGoodsListError(
              errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(GetDeletedGoodsListError(
              errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(GetDeletedGoodsListError(
              errorText: "Проверьте интернет подключение"));
        } else {
          emit(GetDeletedGoodsListError(
              errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetDeletedGoodsListError(errorText: "Что то пошло не так, попробуйте снова"));
      }
    });
  }
}
