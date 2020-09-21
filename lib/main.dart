import 'dart:convert';

import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mydemo/sizeConfig.dart';
import 'login.dart';
import 'constant.dart';
import 'userClass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User user = User();
  user.phoneNumber = "";
  user.password = "";
  final storage = new FlutterSecureStorage();
  String userT = await storage.read(key: 'user');
  if (userT != null) {
    user = User.fromJson(json.decode(userT));
  }
  //await AmapCore.init('011a00c27fd168fcca1e3f3bb7dc443d');
  await enableFluttifyLog(false);
  await AmapService.init(
      iosKey: '011a00c27fd168fcca1e3f3bb7dc443d',
      androidKey: 'af09ea1166a0e280c02679d263859be2');
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorState = new GlobalKey();
  final User user;

  const MyApp({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
              navigatorKey: navigatorState,
              routes: routes,
              theme: ThemeData(primaryColor: Colors.indigo[colorNum]),
              home: LoginPage(
                user: user,
              ));
        },
      );
    });
  }
}
