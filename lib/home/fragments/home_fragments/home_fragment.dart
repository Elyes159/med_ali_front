import 'package:e_commerce_front/home/fragments/home_fragments/home_fargment_cubit.dart';
import 'package:e_commerce_front/home/fragments/home_fragments/home_fragment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeFragmentInitial) {
          BlocProvider.of<HomeFragmentCubit>(context).loadCategories();
          return CircularProgressIndicator();
        }
        if(state is CategoriesLoaded)
        return ListView.builder(itemCount: state.categories.length, itemBuilder: (_, index) {
          return Text(state.categories[index].name!);
        });
      },

                return CircularProgressIndicator();

    );
  }
}
