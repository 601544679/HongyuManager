import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/logisticsInformation.dart';
import 'sizeConfig.dart';
import 'package:date_format/date_format.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
  String state;

  OrderWidget(this.state);
}

class _OrderWidgetState extends State<OrderWidget> {
  List<Widget> widgetList = List();
  Widget content;

  @override
  Widget build(BuildContext context) {
    widgetList.clear();
    for (var value in ff()) {
      // ignore: unrelated_type_equality_checks
      if (value.isFinish == int.parse(widget.state) ||
          int.parse(widget.state) == 0) {
        widgetList.add(Card(
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
                            '运输单号：${value.orderNumber}',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier ,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${value.Departure}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.heightMultiplier * 4),
                          ),
                          Text(
                            '状态',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2),
                          ),
                          Text(
                            '${value.destination}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.heightMultiplier * 4),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(
                            '司机：${value.driverName}',textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: SizeConfig.widthMultiplier * 4),
                          )),
                          Container(
                            height: SizeConfig.heightMultiplier * 8,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value.state,
                                  style: TextStyle(
                                      color: value.isFinish == 1
                                          ? Colors.red
                                          : Colors.green),
                                ),
                                Image.asset(
                                  'images/arrow.png',
                                  width: SizeConfig.widthMultiplier * 10,
                                  height: SizeConfig.heightMultiplier * 4,
                                  fit: BoxFit.cover,
                                  color: value.isFinish == 1
                                      ? Colors.red
                                      : Colors.green,
                                )
                              ],
                            ),
                          ),
                          Expanded(child: Text(
                            '项目：${value.projectName}',textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: SizeConfig.widthMultiplier * 4),
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text('送货单信息',style: TextStyle(fontSize: SizeConfig.widthMultiplier*4))],
                      ),
                      SizedBox(
                        height: SizeConfig.widthMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(value.message,style: TextStyle(fontSize: SizeConfig.heightMultiplier*2)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            date(value.orderTime),
                            style: TextStyle(color: Colors.red,fontSize: SizeConfig.heightMultiplier*2),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
      }
    }
    content = Column(children: widgetList);
    return content;
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
