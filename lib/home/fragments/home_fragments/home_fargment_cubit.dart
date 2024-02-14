import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_front/home/fragments/home_fragments/home_fragment_repository.dart';
import 'package:e_commerce_front/home/fragments/home_fragments/home_fragment_state.dart';
import 'package:e_commerce_front/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFragmentCubit extends Cubit<HomeFragmentState> {
  HomeFragmentCubit() : super(HomeFragmentInitial());
  HomeFragmentRepository _repository = HomeFragmentRepository();

  void loadCategories() {
    emit(CategoriesLoading());
    _repository.categories().then((response) {
      if (response.statusCode == 200) {
        List<CategoryModel> categories = (json.decode(response.body) as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        emit(CategoriesLoaded(categories));
      } else {
        emit(HomeFragmentFailed("Failed to load categories"));
      }
    }).catchError((error) {
      emit(HomeFragmentFailed("An error occurred: $error"));
    });
  }
}
