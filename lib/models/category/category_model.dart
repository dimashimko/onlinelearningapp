import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String? name;
  final String? categoryTitle;
  final String? uid;

  const CategoryModel({
    this.name,
    this.categoryTitle,
    this.uid,
  });

  //
  @override
  List<Object?> get props => [
        name,
        categoryTitle,
        uid,
      ];

  @override
  String toString() {
    return ' name: $name, categoryTitle: $categoryTitle, uid: $uid,';
  }

  const CategoryModel.empty({
    this.name,
    this.categoryTitle,
    this.uid,
  });

  CategoryModel copyWith({
    String? name,
    String? categoryTitle,
    String? uid,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      uid: uid ?? this.uid,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
      categoryTitle: json['categoryTitle'],
      uid: json['uid'],
    );
    // name = json['name'];
    // categoryTitle = json['categoryTitle'];
    // uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['categoryTitle'] = categoryTitle;
    data['uid'] = uid;
    return data;
  }
}
