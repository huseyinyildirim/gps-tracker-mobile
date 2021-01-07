//region Core
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/member/login.dart';
import 'package:gps_tracker_mobile/pages/checkout/cart.dart';
import 'package:gps_tracker_mobile/pages/catalog/categories.dart';
import 'package:gps_tracker_mobile/pages/member/favorites.dart';
import 'package:gps_tracker_mobile/pages/home.dart';
//endregion

//region Widgets
import 'package:gps_tracker_mobile/core/widgets/custom_navbar_widget.dart';
//endregion

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavBarWidget(),
    );
  }
}

class NavBarWidget extends StatefulWidget {

  NavBarWidget({Key key}) : super(key: key);

  @override
  _NavBarWidgetState createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {

  PersistentTabController _controller;
  SharedPreferences _sharedPreferences;

  bool _isLogin;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _isLogin = _sharedPreferences.getBool(StorageKey.isLogin) != null ? _sharedPreferences.getBool(StorageKey.isLogin) : false;

      setState(() {});
    });

    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      CategoriesPage(),
      FavoritesPage(),
      CartPage(),
      LoginPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Keşfet"),
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
        //isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu),
        title: ("Kategoriler"),
        activeColor: Colors.teal,
        inactiveColor: Colors.grey,
        //isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: ("Favorilerim"),
        activeColor: Colors.deepOrange,
        inactiveColor: Colors.grey,
        //isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Sepetim"),
        activeColor: Colors.indigo,
        inactiveColor: Colors.grey,
        //isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.supervised_user_circle),
        title: ("Hesabım"),
        activeColor: Colors.indigo,
        inactiveColor: Colors.grey,
        //isTranslucent: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.grey.shade100,
        handleAndroidBackButtonPress: true,
        onItemSelected: (int) {
          setState(() {});
        },
        customWidget: CustomNavBarWidget(
          items: _navBarsItems(),
          onItemSelected: (index) {
            setState(() {
              _controller.index = index;

              if (_isLogin == false && index == 2) {
                _controller.index = 4;
              }

              if (_isLogin == false && index == 3) {
                _controller.index = 4;
              }
            });
          },
          selectedIndex: _controller.index,
        ),
        itemCount: 5,
        navBarStyle: NavBarStyle.custom,
      //popAllScreensOnTapOfSelectedTab: true,
    );
  }
}

