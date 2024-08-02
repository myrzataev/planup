import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/data/repositories/get_all_goods_impl.dart';

part 'get_all_goods_event.dart';
part 'get_all_goods_state.dart';

class GetAllGoodsBloc extends Bloc<GetAllGoodsEvent, GetAllGoodsState> {
  GetAllGoodsImpl reposImpl;
  GetAllGoodsBloc({required this.reposImpl}) : super(GetAllGoodsInitial()) {
    on<GetAllGoodsEvent>((event, emit) async {
      emit(GetAllGoodsLoading());
      try {
        final result =
            await reposImpl.getAllGoods(event.skip, event.productType);
        emit(GetAllGoodsSuccess(allGoodsModelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetAllGoodsError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(GetAllGoodsError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(GetAllGoodsError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(GetAllGoodsError(errorText: "Проверьте интернет подключение"));
        } else {
          emit(GetAllGoodsError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetAllGoodsError(errorText: "Что то пошло не так, попробуйте снова"));
      }
    });
  }
}
