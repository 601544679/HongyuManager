import 'package:amap_map_fluttify/amap_map_fluttify.dart';

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


