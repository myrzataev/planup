import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/goods_model.dart';
import 'package:planup/tmc/data/repositories/get_my_goods_impl.dart';

part 'get_my_goods_event.dart';
part 'get_my_goods_state.dart';

class GetMyGoodsBloc extends Bloc<GetMyGoodsEvent, GetMyGoodsState> {
  GetMyGoodsImpl repoImpl;
  GetMyGoodsBloc({required this.repoImpl}) : super(GetMyGoodsInitial()) {
    on<GetMyGoodsEvent>((event, emit) async {
      emit(GetMyGoodsLoading());
      try {
        final result = await repoImpl.getMyGoods(event.productType);
        emit(GetMyGoodsSuccess(modelList: result));
      } catch (e) {
        emit(GetMyGoodsError(errorText: e.toString()));
      }
    });
  }
}
