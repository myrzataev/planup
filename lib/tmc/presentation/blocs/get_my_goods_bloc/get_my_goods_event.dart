part of 'get_my_goods_bloc.dart';

@immutable
class GetMyGoodsEvent {
  final String? productType;
  const GetMyGoodsEvent({this.productType});
}
