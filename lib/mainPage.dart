import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mySearch.dart';
import 'sizeConfig.dart';
import 'homeTab.dart';
import 'orderTab.dart';
import 'userTab.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tabName = ['主页', '订单详情', '公司'];
  List result;
  bool showToTopBtn;
  List<Widget> currentScreen = [HomeTab(), OrderTab(), UserTab()];
  var _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTab = 0;
  }

  Widget action(int currentTab) {
    if (currentTab == 0) {
      return Text('');
    } else if (currentTab == 1) {
      return IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () async {
            /* var response = await Server().searchSuggestion();
                result = response['result'];*/
            Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
            final SharedPreferences preferences = await _prefs;
            final history = preferences.getStringList('historyList');
            print('历史$history');
            showSearch(context: context, delegate: searchbar(result, history));
            //print('$result');
          });
    } else if (currentTab == 2) {
      return UnconstrainedBox(
          child: Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(54)),
              child: InkWell(
                  child: Wrap(
                    children: [Icon(Icons.exit_to_app), Text('退出')],
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    final storage = new FlutterSecureStorage();
                    await storage.deleteAll();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/loginPage", (route) => route == null);
                  })));
    }
  }

  List<BottomNavigationBarItem> getItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(home)),
      BottomNavigationBarItem(icon: Icon(Icons.reorder), title: Text(order)),
      BottomNavigationBarItem(
          icon: Icon(Icons.directions_car), title: Text(user)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('currentTab: $currentTab');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(tabName[currentTab]),
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

  void onTabTapped(int index) {
    setState(() {
      currentTab = index;
    });
  }
}
