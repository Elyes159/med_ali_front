import 'package:e_commerce_front/home/fragments/home_fragments/home_fragment.dart';
import 'package:e_commerce_front/registration/authentification/auth_cubit.dart';
import 'package:e_commerce_front/registration/authentification/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    DrawerItem('Home', Icons.home),
    DrawerItem('My Orders', Icons.shopping_bag),
    DrawerItem('My Cart', Icons.shopping_cart),
    DrawerItem('My Wishlist', Icons.favorite_outline),
    DrawerItem('My Account', Icons.account_circle),
  ];
  //declare fragments

  final HomeFragment _homeFragment = HomeFragment();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _selectedDrawerIndex == 0
            ? [
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
              ]
            : null,
        titleSpacing: 0,
        title: _selectedDrawerIndex == 0
            ? Row(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: 50,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("My store in Kodi"),
                ],
              )
            : Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
          child: SingleChildScrollView(
              child: Column(
        children: _createDrawerOptions(),
      ))),
      body: _getDrawerItemFragment(_selectedDrawerIndex),
    );
  }

  _createDrawerOptions() {
    String? email = 'Email', name = 'Fullname';
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;
    if (authState is Authenticated) {
      email = authState.userdata.email!;
      name = authState.userdata.fullname!;
    }

    var drawerOptions = <Widget>[
      UserAccountsDrawerHeader(
          accountName: Text(name), accountEmail: Text(email))
    ];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];

      drawerOptions.add(Container(
          child: ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () {
          setState(() {
            _selectedDrawerIndex = i;
          });
          Navigator.pop(context);
        },
      )));
    }
    return drawerOptions;
  }

  _getDrawerItemFragment(int selectedDrawerIndex) {
    switch (selectedDrawerIndex) {
      case 0:
        return widget._homeFragment;
      default:
        return Text("Error");
    }
  }
}
