import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/sizeConfig.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
              theme: ThemeData(primaryColor: Colors.indigo[600]),
              home: LoginPage());
        },
      );
    });
  }
}
