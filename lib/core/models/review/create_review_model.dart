import 'package:app/core/models/api/api_result_model.dart';

class CreateReviewModel extends Serializable {
  final String id;
  final String name;
  final String review;
  CreateReviewModel({
    required this.id,
    required this.name,
    required this.review,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'review': review,
    };
  }
}
