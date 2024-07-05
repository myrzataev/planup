import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/data/repositories/deny_trade_impl.dart';

part 'deny_trade_event.dart';
part 'deny_trade_state.dart';

class DenyTradeBloc extends Bloc<DenyTradeEvent, DenyTradeState> {
  DenyTradeImpl repoImpl;
  DenyTradeBloc({required this.repoImpl}) : super(DenyTradeInitial()) {
    on<DenyTradeEvent>((event, emit) async {
      emit(DenyTradeLoading());
      try {
        final result =
            await repoImpl.denyTrade(comment: event.comment, id: event.id);
        emit(DenyTradeSuccess(model: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(DenyTradeError(errorText: "У вас нет доступа"));
        } else {
          emit(DenyTradeError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(DenyTradeError(errorText: e.toString()));
      }
    });
  }
}
