import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/mapPage.dart';
import 'sizeConfig.dart';
import 'package:date_format/date_format.dart';
import 'userclass.dart';
import 'server.dart';
import 'finishPage.dart';

//根据下拉菜单使用网络请求
class OrderNetWorkWidget extends StatefulWidget {
  final waybill;

//构造方法传入请求成功后的数据
  OrderNetWorkWidget({this.waybill});

  @override
  _OrderNetWorkWidgetState createState() => _OrderNetWorkWidgetState();
}

class _OrderNetWorkWidgetState extends State<OrderNetWorkWidget> {
  String name;
  DateTime historydate;
  int count = User().numHistoryOrders();
  var waybills;
  var waybillCount;
  var fontSize = SizeConfig.heightMultiplier * 2;
  var sizedBoxHeight = SizeConfig.heightMultiplier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('订单也：${widget.waybill[0]['state']}');
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            print(index);
            //根据运输状态进行跳转
            //widget.waybill[index]['state']
            switch (widget.waybill[index]['state']) {
              case 'inProgress':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                              orderNumber: widget.waybill[index]['ID'],
                            )));
                break;
              case 'Finished':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FinishPage(number: widget.waybill[index]['ID'])));
                break;
            }
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier,
                  right: SizeConfig.widthMultiplier,
                  top: SizeConfig.heightMultiplier,
                  bottom: SizeConfig.heightMultiplier),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle('运输单号：', fontSize),
                            Expanded(
                              child: textStyle(
                                  '${widget.waybill[index]['ID'] ?? 'GCZC00025478'}',
                                  fontSize),
                            )
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        SizedBox(
                          height: SizeConfig.widthMultiplier,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle('项目名称：', fontSize),
                            Expanded(
                                child: textStyle(
                                    '${widget.waybill[index]['projectName'] ?? '云南昆明保利山水云亭二期项目1标'}',
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
                                    '${widget.waybill[index]['ConstructionUnit'] ?? '广州市东滕装饰工程有限公司(一标)'}',
                                    fontSize))
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: textStyle(
                                  '${widget.waybill[index]['startLocationName'] ?? '佛山'}',
                                  fontSize * 2,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center),
                              flex: 2,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textStyle(
                                      '${widget.waybill[index]['state'] == 'Finished' ? '已完成' : '运输中'}',
                                      fontSize,
                                      color: widget.waybill[index]['state'] ==
                                              'Finished'
                                          ? Colors.green
                                          : Colors.red),
                                  Image.asset('images/arrow.png',
                                      width: SizeConfig.widthMultiplier * 10,
                                      height: SizeConfig.heightMultiplier * 4,
                                      fit: BoxFit.cover,
                                      color: widget.waybill[index]['state'] ==
                                              'Finished'
                                          ? Colors.green
                                          : Colors.red),
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: textStyle(
                                  '${widget.waybill[index]['destinationName'] ?? '海口'}',
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
                              '司机：${widget.waybill[index]['driverName'] ?? '李玉红'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: SizeConfig.widthMultiplier * 4),
                            )),
                            Expanded(
                                child: Text(
                              '业务员：${widget.waybill[index]['supplierContactPerson'] ?? '李玉'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: SizeConfig.widthMultiplier * 4),
                            )),
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle('货品：', fontSize),
                            Expanded(
                              child: textStyle('800*800抛釉', fontSize),
                            ),
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle('发货日期：', fontSize),
                            Expanded(
                              child: textStyle(
                                  '${date(1597120000000)}', fontSize,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle('预计到达：', fontSize),
                            Expanded(
                              child: textStyle(
                                  '${date(1597350000000)}', fontSize,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: widget.waybill.length,
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
}
