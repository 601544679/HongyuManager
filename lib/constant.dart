import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/userClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'mainPage.dart';
import 'releaseOrder.dart';

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

//releaseOrder
//发布订单没有车牌号码，司机接单后才添加车牌号码
List list = [
  '送货日期',
  //departureDate           number                2020-09-02
  '物流单号',
  //logisticsOrderNo                              GCWL00018834
  '送货单编号',
  //waybill_ID                                 GCZC00021371
  '销售单号',
  //XK_NO                                        XK0007549849
  '名义客户',
  //company_ID                                   佛山万科置业有限公司(佛山万科星都荟项目)
  '项目部名称',
  //projectName                                佛山万科置业有限公司
  '施工单位',
  //constructionCompanyName                      广州市景晖园林景观工程有限公司
  '项目地址',
  //projectAddress                               广东省佛山市顺德区龙洲路北（骏马修车厂附近）
  '业务员名称',
  //supplierContactPerson                      李啟然
  '业务员电话',
  //supplierContactPhone                       13827798161
  '收货人姓名',
  //constructionSiteContactPerson              王永淦
  '收货人电话',
  //constructionSiteContactPhone               13725285112
  '运输方式',
  //ModeOfTransport                              汽运
  '车牌号码',
  //carNo
  '装车柜号',
  //containerNo
  '物料号',
  //materialsNumber                                FT200-318-0
  '客户编码',
  //client_ID                                    HG60816
  '规格',
  // size                                            450x600
  '开单|色号',
  //billingColor                                YA0601(和坚487单-万科佛山星都荟园林景观工程)
  '跟单通知发货|开单单位',
  //BillingUnit                      块
  '跟单通知发货|发货数量',
  //sendQuantity        number       28
  '跟单通知发货|数量(块)',
  //quantity            number       28
  '跟单通知发货|M2',
  //M2                                    7.56
  '自定义打印|送货单价(块) ',
  //unitPrice          number        12.7683
  '托板总数',
  //palletsNumber       number
  '物流结算|发货重量（吨）',
  //ShippingWeight      number            0.168
  '明细备注',
  //detailedRemarks
  '装车备注',
  //loadingRemarks                               和坚487单,要求带搬运，穿着整齐，长裤，带安全帽，反光衣，
  // 不能抽烟，送货时间早上10点30以后，下午3点半之后！要求今天到货
];
List<String> jsonTitle = [
  'departureDate',
  'logisticsOrderNo',
  'waybill_ID',
  'XK_NO',
  'company_ID',
  'projectName',
  'constructionCompanyName',
  'projectAddress',
  'supplierContactPerson',
  'supplierContactPhone',
  'constructionSiteContactPerson',
  'constructionSiteContactPhone',
  'ModeOfTransport',
  'carNo',
  'containerNo',
  'materialsNumber',
  'client_ID',
  'size',
  'billingColor',
  'BillingUnit',
  'sendQuantity',
  'quantity',
  'M2',
  'unitPrice',
  'palletsNumber',
  'ShippingWeight',
  'detailedRemarks',
  'loadingRemarks'
];

List<String> driverMessage = [
  'logisticsOrderNo',
  'waybill_ID',
  'carNo',
  'company_ID',
  'company',
  'mobilePhoneNumber',
  'username',
  'identityNo',
  'estimatedArrivalTime'
];

//finishPage
List titleList = [
  '送货日期',
  //departureDate           number                2020-09-02
  '物流单号',
  //logisticsOrderNo                              GCWL00018834
  '送货单编号',
  //waybill_ID                                 GCZC00021371
  '名义客户',
  //company_ID                                   佛山万科置业有限公司(佛山万科星都荟项目)
  '项目部名称',
  //projectName                                佛山万科置业有限公司
  '施工单位',
  //constructionCompanyName                      广州市景晖园林景观工程有限公司
  '项目地址',
  //projectAddress                               广东省佛山市顺德区龙洲路北（骏马修车厂附近）
  '业务员名称',
  //supplierContactPerson                      李啟然
  '业务员电话',
  //supplierContactPhone                       13827798161
  '收货人姓名',
  //constructionSiteContactPerson              王永淦
  '收货人电话',
  //constructionSiteContactPhone               13725285112
  '运输方式',
  //ModeOfTransport                              汽运
  '车牌号码',
  //carNo
  '装车柜号',
  //containerNo
];
List arrayTitleList = [
  '序号',
  '销售单号',
  //XK_NO                                                                                                                               a.result.allMessage.xkNo ?? "无销售单号",
  '物料号',
  //materialsNumber                                FT200-318-0
  '客户编码',
  //client_ID                                    HG60816
  '规格',
  // size                                            450x600
  '开单|色号',
  //billingColor                                YA0601(和坚487单-万科佛山星都荟园林景观工程)
  '跟单通知发货|开单单位',
  //BillingUnit                      块
  '跟单通知发货|发货数量',
  //sendQuantity        number       28
  '跟单通知发货|数量(块)',
  //quantity            number       28
  '跟单通知发货|M2',
  //M2                                    7.56
  '自定义打印|送货单价(块) ',
  //unitPrice          number        12.7683
  '托板总数',
  //palletsNumber       number
  '物流结算|发货重量（吨）',
  //ShippingWeight      number            0.168
  '明细备注',
  //detailedRemarks
  '装车备注',
  //loadingRemarks                               和坚487单,要求带搬运，穿着整齐，长裤，带安全帽，反光衣，
];

//日期转换
String date(int millTime) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(millTime);
  time.year;
  time.month;
  time.day;
  return (formatDate(DateTime(time.year, time.month, time.day),
      [yyyy, '年', mm, '月', dd, '日']));
}

//地址转经纬度
changeLat(String address) async {
  final geocodeList =
      await AmapSearch.instance.searchGeocode(address, city: place(address));
  //final geocodeList = await AmapSearch.instance.searchGeocode(address, city: place(address));
  return geocodeList[0].latLng;
}

//返回目的地发货地
String place(String location) {
  if (location.contains('省')) {
    //省
    return location.substring(
        location.indexOf('省') + 1,
        location.indexOf('市') == -1
            ? location.indexOf('县') + 1
            : location.indexOf('市') + 1);
  } else if (location.contains('自治')) {
    //少数民族自治区
    return location.substring(
        location.indexOf('区') + 1, location.indexOf('市') + 1);
  } else if (location.contains('特别')) {
    //港澳
    return location.substring(0, 2);
  } else if (location.contains('北京') ||
      location.contains('天津') ||
      location.contains('上海') ||
      location.contains('重庆')) {
    //直辖市
    return location.substring(0, location.indexOf('市') + 1);
  } else {
    //不规则
    return location.substring(0, 2);
  }
}

//添加到历史记录
putHistory(String historyItem) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences preferences = await _prefs;
  List<String> history = preferences.getStringList('historyList');
  if (history != null) {
    if (history.length >= 10) {
      print('长度${history.length}');
      history.removeAt(0);
      print('剪$history');
      history.add(historyItem);
      print('加$history');
    } else {
      history.add(historyItem);
      print('否则$history');
    }
  } else {
    history = List();
    history.add(historyItem);
  }
  await preferences.setStringList('historyList', history);
}
