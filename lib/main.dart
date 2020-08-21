import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/sizeConfig.dart';
import 'login.dart';
import 'mainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = {"/homePage": (context) => Home()};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
              routes: routes,
              theme: ThemeData(primaryColor: Colors.indigo[600]),
              home: LoginPage());
        },
      );
    });
  }
}
