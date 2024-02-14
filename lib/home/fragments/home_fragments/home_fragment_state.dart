import 'package:e_commerce_front/models/category_model.dart';

abstract class HomeFragmentState {}

class HomeFragmentInitial extends HomeFragmentState {}

class CategoriesLoading extends HomeFragmentState {}

class CategoriesLoaded extends HomeFragmentState {
  List<CategoryModel> categories;
  CategoriesLoaded(this.categories);
}

class HomeFragmentFailed extends HomeFragmentState {
  String message;

  HomeFragmentFailed(this.message);
}
