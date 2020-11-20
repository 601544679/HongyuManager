import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/customeRoute.dart';
import 'package:mydemo/releaseOrder.dart';
import 'package:mydemo/userClass.dart';
import 'package:mydemo/userTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mySearch.dart';
import 'homeTab.dart';
import 'orderTab.dart';
import 'logisticsCompanyTab.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List tabName = ['主页', '订单详情', '物流公司', '个人信息'];

  bool showToTopBtn;
  bool tokenIsUseful = true;
  List<Widget> currentScreen = List();
  GlobalKey stopTimer = GlobalKey();
  var _pageController = PageController();

  //点击跳转到物流公司
  _changeCurrentTab(index) {
    //print('调用了=$index');
    setState(() {
      currentTab = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('MainPage生命周期=${state}');
  }

  checkToken() async {
    User user = await User().getUser();
    var isAuthenticated;
    try {
      isAuthenticated = await LCUser.becomeWithSessionToken(user.sessionToken);
    } on LCException catch (e) {
      print('error--${e.code}--${e.code}');
    }
    print('是否有效${isAuthenticated}');
    return isAuthenticated;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentTab = 0;
    currentScreen = [
      HomeTab(
        changeCurrentTab: (index) => _changeCurrentTab(index),
        key: stopTimer,
      ),
      OrderTab(),
      logisticsCompanyTab(),
      userTab()
    ];
    print('Home--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('Home--didChangeDependencies');
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('Home--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('Home--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
    print('Home--dispose');
  }

  getToken() async {
    //getCurrent要配合LCUser.loginByMobilePhoneNumber不然本地缓存没有记录
    Future.delayed(Duration(milliseconds: 500)).then((value) async {
      LCUser currentUser = await LCUser.getCurrent();
      bool isAuthenticated = await currentUser.isAuthenticated();
      print('currentUser==${currentUser.sessionToken}');
      if (isAuthenticated) {
        // session token 有效
        print('token有效');
        if (isAuthenticated && tokenIsUseful != true) {
          setState(() {
            tokenIsUseful = true;
          });
        }
      } else {
        // session token 无效
        print('token无效');
        if (!isAuthenticated && tokenIsUseful != false) {
          setState(() {
            tokenIsUseful = false;
          });
        }
      }
    });

    //return isAuthenticated;
  }

  //设置appBar的actions[]属性
  Widget action(int currentTab) {
    //getToken();
    if (currentTab == 0) {
      return InkWell(
          onTap: () {
            Navigator.push(context, customRoute(ReleaseOrder()));
          },
          child: Padding(
            padding: EdgeInsets.only(right: setWidth(20)),
            child: Column(
              children: [
                Text(
                  '发布送货单',
                  style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(30, allowFontScalingSelf: true)),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ));
    } else if (currentTab == 1) {
      return Padding(
        padding: EdgeInsets.only(right: setWidth(38)),
        child: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: setHeight(36),
            ),
            onPressed: () async {
              /* var response = await Server().searchSuggestion();
                result = response['result'];*/
              Future<SharedPreferences> _prefs =
                  SharedPreferences.getInstance();
              final SharedPreferences preferences = await _prefs;
              final history = preferences.getStringList('historyList');
              print('历史$history');
              showSearch(
                  context: context, delegate: searchbar(history));
              //print('$result');
            }),
      );
    } else if (currentTab == 2) {
      return Text('');
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    print('currentTab: $currentTab');
    print('MainPage--build');
    print('tokenIsUseful--${tokenIsUseful}');
    return tokenIsUseful == false
        ? Scaffold(
            body: AlertDialog(
              title: Text(retryLogin),
              elevation: 3,
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/loginPage', (route) => route == null);
                  },
                  child: Text('确定'),
                )
              ],
            ),
          )
        : Scaffold(
            body: IndexedStack(
              index: currentTab,
              children: currentScreen,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentTab,
              onTap: onTabTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '主页',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.reorder),
                  label: '送货单',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car),
                  label: '物流公司',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '我的',
                ),
              ],
            ),
          );
  }

  void onTabTapped(int index) async {
    setState(() {
      currentTab = index;
    });
  }
}
