import 'dart:developer';

import 'package:online_learning_app/models/category/category_model.dart';

List<String> getUidsCategories(
  Set<String> categories,
  List<CategoryModel> categoryList,
) {
  // log('*** getUidsCategories');
  // log(categories.toString());
  // log(categoryList.toString());

  List<String> result = [];
  for (CategoryModel category in categoryList) {
    if (categories.contains(category.name)) {
      if (category.uid != null) {
        result.add(category.uid!);
      }
    }
  }
  return result;
}
