import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/repositories/delete_goods_impl.dart';

part 'delete_good_event.dart';
part 'delete_good_state.dart';

class DeleteGoodBloc extends Bloc<DeleteGoodEvent, DeleteGoodState> {
  DeleteGoodsImpl repoImpl;
  DeleteGoodBloc({required this.repoImpl}) : super(DeleteGoodInitial()) {
    on<DeleteGoodEvent>((event, emit) async {
      emit(DeleteGoodLoading());
      try {
        await repoImpl.deleteGoods(id: event.id);
        emit(DeleteGoodSuccess());
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(DeleteGoodError(errorText: "У вас нет доступа"));
        } else {
          emit(DeleteGoodError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(DeleteGoodError(errorText: e.toString()));
      }
    });
  }
}
