import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leancloud_storage/leancloud.dart';
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

class _HomeState extends State<Home> {
  List tabName = ['主页', '订单详情', '物流公司', '个人信息'];
  List result;
  bool showToTopBtn;
  bool tokenIsUseful = true;
  List<Widget> currentScreen = [
    HomeTab(),
    OrderTab(),
    logisticsCompanyTab(),
    userTab()
  ];
  var _pageController = PageController();

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
    currentTab = 0;
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
      return Text('');
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
                  context: context, delegate: searchbar(result, history));
              //print('$result');
            }),
      );
    } else if (currentTab == 2) {
      return Text('');
    } else {
      return Text('');
    }
  }

  List<BottomNavigationBarItem> getItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(home)),
      BottomNavigationBarItem(icon: Icon(Icons.reorder), title: Text(order)),
      BottomNavigationBarItem(
          icon: Icon(Icons.directions_car), title: Text(logisticsCompanyName)),
      BottomNavigationBarItem(icon: Icon(Icons.person), title: Text(user)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    print('currentTab: $currentTab');
    print('Home--build');
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
            appBar: AppBar(
              centerTitle: true,
              title: Text(tabName[currentTab],
                  style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(40, allowFontScalingSelf: true))),
              actions: [action(currentTab)],
            ),
            body: IndexedStack(
              index: currentTab,
              children: currentScreen,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentTab,
              onTap: onTabTapped,
              items: getItems(),
            ),
          );
  }

  void onTabTapped(int index) async {
    setState(() {
      currentTab = index;
    });
  }
}
