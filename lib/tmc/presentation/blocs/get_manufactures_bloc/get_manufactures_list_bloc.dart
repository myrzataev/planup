import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:planup/tmc/data/repositories/get_manufactures_list.dart';

part 'get_manufactures_list_event.dart';
part 'get_manufactures_list_state.dart';

class GetManufacturesListBloc
    extends Bloc<GetManufacturesListEvent, GetManufacturesListState> {
  GetManufacturesListRepoImpl repoImpl;
  GetManufacturesListBloc({required this.repoImpl})
      : super(GetManufacturesListInitial()) {
    on<GetManufacturesListEvent>((event, emit) async {
      emit(GetManufacturesListLoading());
      try {
        final result =
            await repoImpl.getManufacturesList(urlRoute: event.urlRoute);
        emit(GetManufacturesListSuccess(listModel: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetManufacturesListError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(GetManufacturesListError(
              errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(GetManufacturesListError(
              errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(GetManufacturesListError(
              errorText: "Проверьте интернет подключение"));
        } else {
          emit(GetManufacturesListError(
              errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetManufacturesListError(errorText:"Что то пошло не так, попробуйте снова"));
      }
    });
  }
}
