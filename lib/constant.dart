import 'mainPage.dart';
final int colorNum = 600;
final String home = '主页';
final String order = '订单';
final String user = '我的';
final routes = {"/homePage": (context) => Home()};
int currentTab = 0;
String dropDownButtonValue = '0';
String orderTabName = '订单详情';
String userTabName = '个人信息';
String homeTabName = '主页';