import 'package:app/core/models/api/api_result_model.dart';

class CategoryModel extends Serializable {
  final String name;

  CategoryModel({required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(name: json['categories'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
