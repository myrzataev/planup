import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/data/repositories/get_my_trades_impl.dart';

part 'get_my_trades_event.dart';
part 'get_my_trades_state.dart';

class GetMyTradesBloc extends Bloc<GetMyTradesEvent, GetMyTradesState> {
  GetMyTradesImpl repositoryImpl;
  GetMyTradesBloc({required this.repositoryImpl})
      : super(GetMyTradesInitial()) {
    on<GetMyTradesEvent>((event, emit) async {
      emit(GetMyTradesLoading());
      try {
        final result = await repositoryImpl.getMyTrades(id: event.id);
        emit(GetMyTradesSuccess(modelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetMyTradesError(errorText: "У вас нет доступа"));
        } else {
          emit(GetMyTradesError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetMyTradesError(errorText: e.toString()));
      }
    });
  }
}
