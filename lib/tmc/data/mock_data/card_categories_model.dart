// class CategoriesCardModel {
//   final String name;
//   final String value;
//   final String manufactures;
//   final String model;
//   CategoriesCardModel({required this.name, required this.value, required this.manufactures, required this.model});
// }

// abstract class CardCategoriesCardData {
//   static List<CategoriesCardModel> categoriesList = [
//     CategoriesCardModel(name: "cable", value: "Кабель", manufactures: "cable_manufactures", model: "cable_models"),
//     CategoriesCardModel(name: "adapter", value: "Адаптер", manufactures: "adapter_manufactures", model: "adapter_models"),
//     CategoriesCardModel(name: "media_converter", value: "Медиа конвертер", manufactures: "media_converter_manufactures",model: "media_converter_models"),
//     CategoriesCardModel(name: "odf", value: "ODF", manufactures: "odf_manufactures", model: "odf_models"),
//     CategoriesCardModel(name: "onu", value: "ONU", manufactures: "onu_manufactures", model: "onu_manufactures"),
//     CategoriesCardModel(name: "patch_cord", value: "Патч корд", manufactures: "patch_cord_manufactures", model: "patch_cord_models"),
//     CategoriesCardModel(name: "set_top_box", value: "Приставка", manufactures: "set_top_box_manufactures", model: "set_top_box_models"),
//     CategoriesCardModel(name: "sfp_module", value: "Модуль SFP", manufactures:"sfp_module_manufactures" , model: "sfp_module_models"),
//     CategoriesCardModel(name: "splitter", value: "Разделитель", manufactures: "splitter_manufactures", model: "splitter_models"),
//     CategoriesCardModel(name: "straight_bracket", value: "Кронштейн", manufactures: "straight_bracket_manufactures", model: "straight_bracket_models"),
//     CategoriesCardModel(name: "utp_cable", value: "UTP модель",  manufactures: "utp_cable_manufactures", model: "utp_cable_models"),
//   ];
// }


// To parse this JSON data, do
//
//     final categoriesCardModel = categoriesCardModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesCardModel> categoriesCardModelFromJson(String str) => List<CategoriesCardModel>.from(json.decode(str).map((x) => CategoriesCardModel.fromJson(x)));

String categoriesCardModelToJson(List<CategoriesCardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesCardModel {
    String? type;
    Translations? translations;

    CategoriesCardModel({
        this.type,
        this.translations,
    });

    factory CategoriesCardModel.fromJson(Map<String, dynamic> json) => CategoriesCardModel(
        type: json["type"],
        translations: json["translations"] == null ? null : Translations.fromJson(json["translations"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "translations": translations?.toJson(),
    };
}

class Translations {
    String? en;
    String? ru;

    Translations({
        this.en,
        this.ru,
    });

    factory Translations.fromJson(Map<String, dynamic> json) => Translations(
        en: json["en"],
        ru: json["ru"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
        "ru": ru,
    };
}
