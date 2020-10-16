import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/mapPage.dart';
import 'package:mydemo/waybill_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constant.dart';
import 'finishPage.dart';

//根据下拉菜单使用网络请求
GlobalKey<_OrderNetWorkWidgetState> netWorkChildKey = GlobalKey(); //一定要指定<>

class OrderNetWorkWidget extends StatefulWidget {
  final waybill;

//构造方法传入请求成功后的数据
  OrderNetWorkWidget({this.waybill, Key key});

  @override
  _OrderNetWorkWidgetState createState() => _OrderNetWorkWidgetState();
}

class _OrderNetWorkWidgetState extends State<OrderNetWorkWidget> {
  var fontSize = ScreenUtil().setSp(43, allowFontScalingSelf: true);
  var sizedBoxHeight = ScreenUtil().setHeight(23);
  List titleList = ['序号', '色号', '规格', '数量', '发货数量', '开单单位', '送货单价', '明细备注'];
  ScrollController controller = ScrollController();
  bool showToTopBtn = false;
  double position;
  var bb;
  bool tokenIsUseful = true;

  //返回顶部
  void backToTop() {
    controller.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('OrderNetWorkWidget--initState');
    controller.addListener(() {
      //print('滚动位置:${controller.offset}');
      //print('滚动位置1:${controller.initialScrollOffset}');
      setState(() {
        position = controller.offset;
      });
      if (controller.offset < 300 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (controller.offset >= 300 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(OrderNetWorkWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('OrderNetWorkWidget--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('OrderNetWorkWidget--deactivate');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('OrderNetWorkWidget--didChangeDependencies');
    bb = PageStorage.of(context).readState(context);
    if (bb != null) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('OrderNetWorkWidget--dispose');
    super.dispose();
    controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    getToken();
    if (tokenIsUseful == true) {
      print('position--$position');
      print('OrderNetWorkWidget--build');
      MyNotification(showToTopBtn).dispatch(context);
      WaybillEntity wbill = WaybillEntity().fromJson(widget.waybill);
      //wbill.result.sort((a, b) => b.departureDate.compareTo(a.departureDate));
      return ListView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          //print('类型：${wbill.result[index].runtimeType}');
          return InkWell(
            onTap: () {
              print(index);
              //根据运输状态进行跳转
              switch (wbill.result[index].status) {
                case 'inProgress':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(
                              orderNumber: wbill.result[index].waybillId)));
                  break;
                case 'Finished':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FinishPage(
                              orderNumber: wbill.result[index].waybillId)));
                  break;
              }
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(22),
                    right: ScreenUtil().setWidth(22),
                    top: ScreenUtil().setHeight(23),
                    bottom: ScreenUtil().setHeight(23)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textStyle('运输单号：', fontSize),
                        Expanded(
                          child: textStyle(
                              '${wbill.result[index].waybillId ?? '无运输单号'}',
                              fontSize),
                        )
                      ],
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textStyle('项目名称：', fontSize),
                        Expanded(
                            child: textStyle(
                                '${wbill.result[index].projectName ?? '无项目名'}',
                                fontSize))
                      ],
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textStyle('施工单位：', fontSize),
                        Expanded(
                            child: textStyle(
                                '${wbill.result[index].constructionCompanyName ?? '无施工单位'}',
                                fontSize))
                      ],
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: textStyle(
                              '${wbill.result[index].startLocationName == ' ' ? '佛山市' : wbill.result[index].startLocationName}',
                              fontSize * 2,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center),
                          flex: 2,
                        ),
                        Expanded(
                          child: goodStatus(wbill.result[index].status),
                          flex: 1,
                        ),
                        Expanded(
                          child: textStyle(
                              '${wbill.result[index].destinationName ?? '目的地'}',
                              fontSize * 2,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center),
                          flex: 2,
                        ),
                      ],
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          '司机：${wbill.result[index].driver == null ? '无司机' : wbill.result[index].driver.username}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: ScreenUtil().setWidth(44)),
                        )),
                        Expanded(
                            child: Text(
                          '业务员：${wbill.result[index].supplierContactPerson ?? '无业务员'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: ScreenUtil().setWidth(44)),
                        )),
                      ],
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textStyle('货物明细：', fontSize),
                      ],
                    ),
                    GoodsDetail(
                      index: index,
                      titleList: titleList,
                      totalList: wbill.result[index],
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textStyle('发货日期', fontSize),
                        textStyle('预计到达', fontSize),
                      ],
                    ),
                    Divider(
                      height: ScreenUtil().setHeight(23),
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textStyle(
                          '${date(wbill.result[index].departureDate ?? '无出发日期')}',
                          fontSize,
                          color: Colors.red,
                        ),
                        Container(
                          color: Colors.grey,
                          width: 1,
                          height: ScreenUtil().setHeight(90),
                        ),
                        textStyle(
                            '${wbill.result[index].estimatedArrivalTime == -1 ? '无到货日期' : date(wbill.result[index].estimatedArrivalTime)}',
                            fontSize,
                            color: Colors.green,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: wbill.result.length,
      );
    }
    //已在mainPage做了单设备登录处理这里不需要
    else if (tokenIsUseful == false) {
      return AlertDialog(
        title: Text('该账号已在新设备登录，点击重新登录'),
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
      );
    }
  }

//判断运输状态
  Widget goodStatus(String status) {
    switch (status) {
      case 'inProgress':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textStyle('运输中', fontSize, color: Colors.red),
            Image.asset('images/arrow.png',
                width: ScreenUtil().setWidth(108),
                height: ScreenUtil().setHeight(90),
                fit: BoxFit.cover,
                color: Colors.red),
          ],
        );
        break;
      case 'Finished':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textStyle('已完成', fontSize, color: Colors.green),
            Image.asset('images/arrow.png',
                width: ScreenUtil().setWidth(108),
                height: ScreenUtil().setHeight(90),
                fit: BoxFit.cover,
                color: Colors.green),
          ],
        );
        break;
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textStyle('待分配', fontSize, color: Colors.lime),
            Image.asset('images/arrow.png',
                width: ScreenUtil().setWidth(108),
                height: ScreenUtil().setHeight(90),
                fit: BoxFit.cover,
                color: Colors.lime),
          ],
        );
        break;
    }
  }
}

Text textStyle(String data, double size,
    {FontWeight fontWeight, Color color, TextAlign textAlign}) {
  return Text(
    data,
    style: TextStyle(
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black,
    ),
    textAlign: textAlign ?? TextAlign.start,
  );
}

//todo 写控件传值
class GoodsDetail extends StatefulWidget {
  int index;
  WaybillResult totalList;
  List titleList;

  GoodsDetail({this.index, this.totalList, this.titleList});

  @override
  _GoodsDetailState createState() => _GoodsDetailState();
}

List<DataColumn> dataColumn(List titleList) {
  List<DataColumn> columnList = List();
  //print('标题长度---${titleList.length}');
  for (int i = 0; i < titleList.length; i++) {
    //print('标题--${titleList[i]}');
    columnList.add(DataColumn(
        label: Row(
      children: [
        Text(
          titleList[i],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    )));
  }
  return columnList;
}

List<DataRow> dataRow(List contentList) {
  List<DataRow> rowList = List();
  for (var value in contentList) {
    List<DataCell> cellList = List();
    for (int i = 0; i < value.length; i++) {
      cellList.add(DataCell(Text(value[i].toString())));
    }
    rowList.add(DataRow(cells: cellList));
  }

  return rowList;
}

class _GoodsDetailState extends State<GoodsDetail> {
  @override
  Widget build(BuildContext context) {
    List allList = List();
    for (int i = 0; i < widget.totalList.xkNo.length; i++) {
      List cutList = List();
      cutList.add(i + 1);
      cutList.add(widget.totalList.billingColor[i].contains('(') == true
          ? widget.totalList.billingColor[i]
              .substring(0, widget.totalList.billingColor[i].indexOf('('))
          : '');
      cutList.add(widget.totalList.size[i]);
      cutList.add(widget.totalList.quantity[i]);
      cutList.add(widget.totalList.sendQuantity[i]);
      cutList.add(widget.totalList.billingUnit[i]);
      //cutList.add(widget.totalList.unitPrice[i]);
      cutList.add('');
      cutList.add(widget.totalList.detailedRemarks[i]);
      allList.add(cutList);
    }
    //print('裁剪--${allList}');

    //RLogger.instance.d(widget.totalList.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          //columnSpacing: ScreenUtil().setWidth(60),
          dataRowHeight: ScreenUtil().setHeight(68),
          headingRowHeight: ScreenUtil().setHeight(90),
          columns: dataColumn(widget.titleList),
          rows: dataRow(allList)),
    );
  }
}

class MyNotification extends Notification {
  bool showTopButton;

  MyNotification(this.showTopButton);
}
