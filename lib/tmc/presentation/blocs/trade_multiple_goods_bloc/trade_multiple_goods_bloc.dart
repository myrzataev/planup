import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/data/models/multiple_trades_model.dart';
import 'package:planup/tmc/data/repositories/trade_multiple_goods_impl.dart';

part 'trade_multiple_goods_event.dart';
part 'trade_multiple_goods_state.dart';

class TradeMultipleGoodsBloc
    extends Bloc<TradeMultipleGoodsEvent, TradeMultipleGoodsState> {
  TradeMultipleGoodsImpl repoImpl;
  TradeMultipleGoodsBloc({required this.repoImpl})
      : super(TradeMultipleGoodsInitial()) {
    on<TradeMultipleGoodsEvent>((event, emit) async {
      emit(TradeMultipleGoodsLoading());
      try {
       final result = await repoImpl.multipleTrade(model: event.model);
        emit(TradeMultipleGoodsSuccess(model: result));
      } catch (e) {
        emit(TradeMultipleGoodsError(errorText: e.toString()));
      }
    });
  }
}
