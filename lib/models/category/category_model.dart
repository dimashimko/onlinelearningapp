class CategoryModel {
  String? name;
  String? categoryTitle;
  String? uid;

  CategoryModel({
    this.name,
    this.categoryTitle,
    this.uid,
  });

  @override
  String toString() {
    return ' name: $name, categoryTitle: $categoryTitle, uid: $uid,';
  }

  CategoryModel.empty({
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

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categoryTitle = json['categoryTitle'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['categoryTitle'] = categoryTitle;
    data['uid'] = uid;
    return data;
  }
}
