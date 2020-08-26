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
            var state = '运输中';
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
                            Text(
                              //'运输单号：${widget.waybill[index]['ID']}',
                              '运输单号：25225',
                              style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              //'${widget.waybill[index]['startLocationName']}',
                              '佛山',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.heightMultiplier * 4),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    //widget.waybill[index].state,
                                    '运输中',
                                    style: TextStyle(color: Colors.red),
                                  ),
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
                            Text(
                              //'${widget.waybill[index]['destinationName'] ?? '北京'}',
                              '北京',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.heightMultiplier * 4),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              // '司机：${widget.waybill[index]['driverName'] ?? '张伟'}',
                              '司机：张伟 ',
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
                        SizedBox(
                          height: SizeConfig.widthMultiplier,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '项目名称: 碧桂园',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: SizeConfig.heightMultiplier * 2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '施工单位: 珠海华润',
                              style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                //widget.waybill[index]['message'] ?? '800*800',
                                '货品：800*800抛釉',
                                style: TextStyle(
                                    fontSize: SizeConfig.heightMultiplier * 2)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '发货日期: ${date(1597120000000)}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: SizeConfig.heightMultiplier * 2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '预计到达: ${date(1597350000000)}',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: SizeConfig.heightMultiplier * 2),
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
}
