class GoodStatusesModel {
  final int id;
  final String name;
  GoodStatusesModel({required this.id, required this.name});
}

abstract class GoodStatusesData {
  static List<GoodStatusesModel> goodStatusesList = [
    GoodStatusesModel(id: 1, name: "На складе"),
    GoodStatusesModel(id: 2, name: "У НУ"),
    GoodStatusesModel(id: 3, name: "У СИ")
  ];
}
