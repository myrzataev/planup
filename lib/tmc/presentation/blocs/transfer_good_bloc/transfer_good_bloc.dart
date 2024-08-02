import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/data/repositories/transfer_good_impl.dart';

part 'transfer_good_event.dart';
part 'transfer_good_state.dart';

class TransferGoodBloc extends Bloc<TransferGoodEvent, TransferGoodState> {
  TransferGoodImpl repoImpl;
  TransferGoodBloc({required this.repoImpl}) : super(TransferGoodInitial()) {
    on<TransferGoodEvent>((event, emit) async {
      emit(TransferGoodLoading());
      final result = await repoImpl.transferGood(
        sourceUserId: event.sourceUserId,
        destinationUserId: event.destinationUserId,
        goodID: event.goodID,
        tradeStatusId: event.tradeStatusId,
        comment: event.comment,
      );
      result.fold((error){
        emit(TransferGoodError(errorText: error));
      }, (transferGoodModel){
        emit(TransferGoodSuccess(model: transferGoodModel));
      });

      // try {
      //   final result = await repoImpl.transferGood(
      //     comment: event.comment,
      //       sourceUserId: event.sourceUserId,
      //       destinationUserId: event.destinationUserId,
      //       goodID: event.goodID,
      //       tradeStatusId: event.tradeStatusId);

      //   emit(TransferGoodSuccess(model: result));
      // } on DioException catch (e) {
      //   if (e.response?.statusCode == 403) {
      //     emit(TransferGoodError(errorText: "У вас нет доступа"));
      //   } else {
      //     emit(TransferGoodError(errorText: "Произошла ошибка: ${e.message}"));
      //   }
      // } catch (e) {
      //   emit(TransferGoodError(errorText: e.toString()));
      // }
    });
  }
}
