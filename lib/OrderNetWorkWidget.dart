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
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            print(index);
            //根据运输状态进行跳转
            //widget.waybill[index]['state']
            var a = Random().nextInt(2);
            print('a值$a');
            var state = a == 0 ? '运输中' : '已完成';
            switch (state) {
              case '运输中':
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapPage()));
                break;
              case '已完成':
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FinishPage()));
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
                              child: textStyle('25225', fontSize),
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
                                child: textStyle('云南昆明保利山水云亭二期项目1标', fontSize))
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textStyle('施工单位：', fontSize),
                            Expanded(
                                child: textStyle('广州市东滕装饰工程有限公司(一标)', fontSize))
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textStyle('佛山', fontSize * 2,
                                fontWeight: FontWeight.bold),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textStyle('运输中', fontSize, color: Colors.red),
                                  Image.asset(
                                    'images/arrow.png',
                                    width: SizeConfig.widthMultiplier * 10,
                                    height: SizeConfig.heightMultiplier * 4,
                                    fit: BoxFit.cover,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                            textStyle('北京', fontSize * 2,
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              // '司机：${widget.waybill[index]['driverName'] ?? '张伟'}',
                              '司机：张伟',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: SizeConfig.widthMultiplier * 4),
                            )),
                            Expanded(
                                child: Text(
                              '业务员：陈关西',
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
                            textStyle('到货日期：', fontSize),
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
      itemCount: 2,
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
      {FontWeight fontWeight, Color color}) {
    return Text(
      data,
      style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black),
    );
  }
}
