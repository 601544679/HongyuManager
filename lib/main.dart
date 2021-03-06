import 'dart:convert';
import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mydemo/sizeConfig.dart';
import 'package:mydemo/splashScreen.dart';
import 'login.dart';
import 'constant.dart';
import 'userClass.dart';
import 'package:leancloud_storage/leancloud.dart';

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
  await AmapService.instance.init(
      iosKey: '011a00c27fd168fcca1e3f3bb7dc443d',
      androidKey: 'af09ea1166a0e280c02679d263859be2');
  LeanCloud.initialize(
      '24PJDWahD7Pww2cDice6F6Er-gzGzoHsz', 'mrcuLNzhXH6uJ3gTtGi0Ttg7',
      server: 'https://gcapp.hy100.com.cn');
  //LCLogger.setLevel(3); //一定要放在main不然不显示具体错误信息
  if (Platform.isAndroid) {
    //沉浸式状态栏
    //写在组件渲染之后，是为了在渲染后进行设置赋值，覆盖状态栏，写在渲染之前对MaterialApp组件会覆盖这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorState = new GlobalKey();
  final User user;

  const MyApp({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('main--build');
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
              navigatorKey: navigatorState,
              routes: routes,
              initialRoute: '/',
              theme: ThemeData(primaryColor: Colors.indigo[colorNum]),
              home: splashScreen(
                user,
              ));
        },
      );
    });
  }
}
