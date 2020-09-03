import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'server.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';

//查看已完成订单的详细信息
class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
  String number;

  FinishPage({this.number});
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print('done');
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              print('hasData');
              // 请求成功，显示数据
              return ImageBuilder(snapshot.data);
            }
            break;
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.indigo[colorNum]),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    Text('正在加载...')
                  ],
                ),
              ),
            );
            break;
          case ConnectionState.active:
            print('active');
            break;
        }
      },
      future: imageFuture(),
    );
  }

  imageFuture() async {
    var a = await Server().getFinishImage(widget.number);
    print('aaa:${a['result']}');
    return a['result'];
  }
}

class ImageBuilder extends StatefulWidget {
  final data;

  ImageBuilder(this.data);

  @override
  _ImageBuilderState createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  List s = ['工地现场图', '运货单号', '顺丰单号'];
  var fontSize = SizeConfig.heightMultiplier * 2;
  var fontSize1 = SizeConfig.heightMultiplier * 2.5;
  var flex1 = 1;
  var flex2 = 2;
  var textAlign = TextAlign.right;
  var containerWidth = SizeConfig.widthMultiplier * 94;

  @override
  Widget build(BuildContext context) {
    print('data是: ${widget.data}');
    List list = [
      '送货日期',
      //departureDate                                2020-09-02
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
      //sendQuantity                     28
      '跟单通知发货|数量(块)',
      //quantity                         28
      '跟单通知发货|M2',
      //M2                                    7.56
      '自定义打印|送货单价(块) ',
      //unitPrice                      12.7683
      '托板总数',
      //palletsNumber
      '物流结算|发货重量（吨）',
      //ShippingWeight                  0.168
      '明细备注',
      //detailedRemarks
      '装车备注',
      //loadingRemarks                               和坚487单,要求带搬运，穿着整齐，长裤，带安全帽，反光衣，
      // 不能抽烟，送货时间早上10点30以后，下午3点半之后！要求今天到货
    ];
    List dd = [
      date(widget.data['allMessage']['departureDate']) ?? date(1597120000000),
      widget.data['allMessage']['logisticsOrderNo'] ?? 'SDFE123658',
      widget.data['allMessage']['waybill_ID'],
      widget.data['allMessage']['XK_NO']??"XK48948948",
      widget.data['allMessage']['company_ID'] ?? '云南保晟房地产开发有限公司',
      widget.data['allMessage']['projectName'] ?? '云南昆明保利山水云亭二期项目1标',
      widget.data['allMessage']['constructionCompanyName'] ??
          '广州市东滕装饰工程有限公司(一标)',
      widget.data['allMessage']['projectAddress'] ?? '昆明市呈贡区黄陂土片区保利山水云亭',
      widget.data['allMessage']['supplierContactPerson'] ?? '金凯鹏',
      widget.data['allMessage']['supplierContactPhone'] ?? '18654723369',
      widget.data['allMessage']['constructionSiteContactPerson'] ?? '高德伟',
      widget.data['allMessage']['constructionSiteContactPhone'] ??
          '13952654785',
      widget.data['allMessage']['ModeOfTransport'] ?? '汽运',
      widget.data['allMessage']['carNo'] ?? '粤ABF949',
      widget.data['allMessage']['containerNo'] ?? 'containerNo',
      widget.data['allMessage']['materialsNumber'] ?? 'FT200-318-0',
      widget.data['allMessage']['client_ID'] ?? 'HG60816',
      widget.data['allMessage']['size'] ?? '450x600',
      widget.data['allMessage']['billingColor'] ??
          'YA0601(和坚487单-万科佛山星都荟园林景观工程)',
      widget.data['allMessage']['BillingUnit'] ?? '块',
      widget.data['allMessage']['sendQuantity'] == null
          ? '28'
          : widget.data['allMessage']['sendQuantity'].toString(), //int
      widget.data['allMessage']['quantity'] == null
          ? '28'
          : widget.data['allMessage']['quantity'].toString(), //int
      widget.data['allMessage']['M2'] ?? '7.56', //string
      widget.data['allMessage']['unitPrice'] == null
          ? '12.7683'
          : widget.data['allMessage']['unitPrice'].toString(), //double
      widget.data['allMessage']['palletsNumber'] ?? '10',
      widget.data['allMessage']['ShippingWeight'] == null
          ? '0.168'
          : widget.data['allMessage']['ShippingWeight'].toString(), //double
      widget.data['allMessage']['detailedRemarks'] ?? '',
      widget.data['allMessage']['loadingRemarks'] ??
          '和坚487单,要求带搬运，穿着整齐，长裤，带安全帽，反光衣，不能抽烟，送货时间早上10点30以后，下午3点半之后！要求今天到货',
    ];
    print(
        'logisticsOrderNo: ${widget.data['allMessage']['logisticsOrderNo'].runtimeType}');
    print('waybill_ID: ${widget.data['allMessage']['waybill_ID'].runtimeType}');
    print('company_ID: ${widget.data['allMessage']['company_ID'].runtimeType}');
    print(
        'projectName: ${widget.data['allMessage']['projectName'].runtimeType}');
    print(
        'constructionCompany: ${widget.data['allMessage']['constructionCompany'].runtimeType}');
    print(
        'projectAddress: ${widget.data['allMessage']['projectAddress'].runtimeType}');
    print(
        'supplierContactPerson: ${widget.data['allMessage']['supplierContactPerson'].runtimeType}');
    print(
        'supplierContactPhone: ${widget.data['allMessage']['supplierContactPhone'].runtimeType}');
    print(
        'ModeOfTransport: ${widget.data['allMessage']['ModeOfTransport'].runtimeType}');
    print('carNo: ${widget.data['allMessage']['carNo'].runtimeType}');
    print(
        'containerNo: ${widget.data['allMessage']['containerNo'].runtimeType}');
    print(
        'materialsNumber: ${widget.data['allMessage']['materialsNumber'].runtimeType}');
    print('client_ID: ${widget.data['allMessage']['client_ID'].runtimeType}');
    print('size: ${widget.data['allMessage']['size'].runtimeType}');
    print(
        'billingColor: ${widget.data['allMessage']['billingColor'].runtimeType}');
    print(
        'BillingUnit: ${widget.data['allMessage']['BillingUnit'].runtimeType}');
    print(
        'sendQuantity: ${widget.data['allMessage']['sendQuantity'].runtimeType}');
    print('quantity: ${widget.data['allMessage']['quantity'].runtimeType}');
    print('M2: ${widget.data['allMessage']['M2'].runtimeType}');
    print('unitPrice: ${widget.data['allMessage']['unitPrice'].runtimeType}');
    print(
        'palletsNumber: ${widget.data['allMessage']['palletsNumber'].runtimeType}');
    print(
        'ShippingWeight: ${widget.data['allMessage']['ShippingWeight'].runtimeType}');
    print(
        'detailedRemarks: ${widget.data['allMessage']['detailedRemarks'].runtimeType}');
    print(
        'loadingRemarks: ${widget.data['allMessage']['loadingRemarks'].runtimeType}');

    return Scaffold(
      appBar: AppBar(
        title: Text('订单完成情况'),
      ),
      body: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3,
              top: SizeConfig.heightMultiplier,
              right: SizeConfig.widthMultiplier * 3,
              bottom: SizeConfig.heightMultiplier),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle(list[index], fontSize),
                          ],
                        ),
                        Container(
                            width: containerWidth,
                            child: textStyle(dd[index], fontSize1,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                      ],
                    );
                  },
                  itemCount: list.length,
                ),
                Divider(color: Colors.grey),
                Container(
                    child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      //color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s[index],
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 3),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier,
                          ),
                          InkWell(
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.network(
                                widget.data['imageUrl'][index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: '${s[index]}',
                                  toastLength: Toast.LENGTH_SHORT);
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return dialogImageBuilder(
                                        widget.data['imageUrl'], index);
                                  });
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier,
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: widget.data['imageUrl'].length,
                ))
              ],
            ),
          )),
    );
  }

//日期转换
  String date(int millTime) {
    DateTime a = DateTime.fromMillisecondsSinceEpoch(millTime);
    a.year;
    a.month;
    a.day;
    return (formatDate(
        DateTime(a.year, a.month, a.day), [yyyy, '年', mm, '月', dd, '日']));
  }

  Text textStyle(String data, double fontSize, {FontWeight fontWeight}) {
    return Text(
      '$data',
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.normal, fontSize: fontSize),
    );
  }
}

class dialogImageBuilder extends StatefulWidget {
  List imageList = List();
  int index;

  dialogImageBuilder(this.imageList, this.index);

  @override
  _dialogImageBuilderState createState() => _dialogImageBuilderState();
}

class _dialogImageBuilderState extends State<dialogImageBuilder> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: DragScaleContainer(
          doubleTapStillScale: true,
          child: Image.network(
            widget.imageList[widget.index],
            //scale: scale,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
