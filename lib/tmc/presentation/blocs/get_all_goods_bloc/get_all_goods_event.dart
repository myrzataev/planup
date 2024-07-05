part of 'get_all_goods_bloc.dart';

@immutable
 class GetAllGoodsEvent {
  final String skip;
  final String? productType;
 const GetAllGoodsEvent({required this.skip, this.productType});
}
