import 'mainPage.dart';
import 'releaseOrder.dart';
import 'login.dart';

final int colorNum = 600;
final String home = '主页';
final String order = '订单';
final String user = '公司';
final routes = {
  "/homePage": (context) => Home(),
  "/loginPage": (context) => LoginPage(),
  "/releaseOrder": (context) => ReleaseOrder(),
};
int currentTab = 0;
String dropDownButtonValue = '0';
final String orderTabName = '订单详情';
final String userTabName = '公司';
final String homeTabName = '主页';
