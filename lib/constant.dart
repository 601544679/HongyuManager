import 'mainPage.dart';
import 'mapPage.dart';
import 'releaseOrder.dart';
final int colorNum = 600;
final String home = '主页';
final String order = '订单';
final String user = '我的';
final routes = {
  "/homePage": (context) => Home(),
  "/releaseOrder": (context) => ReleaseOrder(),
};
int currentTab = 0;
String dropDownButtonValue = '0';
final String orderTabName = '订单详情';
final String userTabName = '个人信息';
final String homeTabName = '主页';
