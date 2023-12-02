import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/city_selector_view.dart';
import '../views/city_view.dart';

class AppRoute {
  final Widget page;
  final String title;
  final bool hasAnimation;

  AppRoute(this.page, this.title, this.hasAnimation);

  Future<T?> go<T>(BuildContext context) {
    return Navigator.push<T>(
        context,
        // MaterialPageRoute(builder: (context) => page),
        hasAnimation
            ? PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 250),
        )
            : MaterialPageRoute(builder: (context) => page));
  }

  Future<T?> checkGo<T>({
    required BuildContext context,
    required bool Function() check,
  }) {
    if (check()) {
      return go(context);
    }
    return Future.value(null);
  }

  static AppRoute city() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.grey));
    return AppRoute(CityViewPageProvider(), 'city', true);
  }

  static AppRoute citySelector() {
    return AppRoute(CitySelectorViewPage(), 'citySelector', true);
  }


}
