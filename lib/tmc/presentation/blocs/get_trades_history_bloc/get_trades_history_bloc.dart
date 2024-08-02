import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/data/repositories/get_trade_hitory_impl.dart';

part 'get_trades_history_event.dart';
part 'get_trades_history_state.dart';

class GetTradesHistoryBloc
    extends Bloc<GetTradesHistoryEvent, GetTradesHistoryState> {
  GetTransactionsHitoryImpl repoImpl;
  GetTradesHistoryBloc({required this.repoImpl})
      : super(GetTradesHistoryInitial()) {
    on<GetTradesHistoryEvent>((event, emit) async {
      emit(GetTradesHistoryLoading());
      try {
        final result = await repoImpl.getTransferHistoty();
        emit(GetTradesHistorySuccess(modelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetTradesHistoryError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(GetTradesHistoryError(
              errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(GetTradesHistoryError(
              errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(GetTradesHistoryError(
              errorText: "Проверьте интернет подключение"));
        } else {
          emit(GetTradesHistoryError(
              errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetTradesHistoryError(errorText: "Что то пошло не так, попробуйте снова"
        // e.toString()
        ));
      }
    });
  }
}
