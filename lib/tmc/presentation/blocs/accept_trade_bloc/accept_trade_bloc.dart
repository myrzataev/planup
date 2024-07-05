import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/data/repositories/accept_trade_repo_impl.dart';

part 'accept_trade_event.dart';
part 'accept_trade_state.dart';

class AcceptTradeBloc extends Bloc<AcceptTradeEvent, AcceptTradeState> {
  AcceptTradeRepoImpl repoImpl;
  AcceptTradeBloc({required this.repoImpl}) : super(AcceptTradeInitial()) {
    on<AcceptTradeEvent>((event, emit) async {
      emit(AcceptTradeLoading());
      try {
        final result = await repoImpl.acceptTrade(id: event.id);
        emit(AcceptTradeSuccess(model: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(AcceptTradeError(errorText: "У вас нет доступа"));
        } else {
          emit(AcceptTradeError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(AcceptTradeError(errorText: e.toString()));
      }
    });
  }
}
