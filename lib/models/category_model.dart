class CategoryModel {
  String? id;
  String categoryName;

  CategoryModel({this.id, required this.categoryName,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      categoryName: map['categoryName'],
    );
  }
}
