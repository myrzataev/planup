import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/data/repositories/get_users_trade_histrory_impl.dart';

part 'get_user_trade_history_event.dart';
part 'get_user_trade_history_state.dart';

class GetUserTradeHistoryBloc
    extends Bloc<GetUserTradeHistoryEvent, GetUserTradeHistoryState> {
  GetUsersTradeHistroryImpl repoImpl;
  GetUserTradeHistoryBloc({required this.repoImpl})
      : super(GetUserTradeHistoryInitial()) {
    on<GetUserTradeHistoryEvent>((event, emit) async {
      emit(GetUserTradeHistoryLoading());

      try {
        final result = await repoImpl.getUsersTradeHistory();

        emit(GetUserTradeHistorySuccess(modelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetUserTradeHistoryError(errorText: "У вас нет доступа"));
        } else {
          emit(GetUserTradeHistoryError(
              errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetUserTradeHistoryError(errorText: e.toString()));
      }
    });
  }
}
