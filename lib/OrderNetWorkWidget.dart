import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/logisticsInformation.dart';
import 'sizeConfig.dart';
import 'package:date_format/date_format.dart';

//根据下拉菜单使用网络请求
class OrderNetWorkWidget extends StatefulWidget {
  @override
  _OrderNetWorkWidgetState createState() => _OrderNetWorkWidgetState();
//构造方法传入请求成功后的数据
}

class _OrderNetWorkWidgetState extends State<OrderNetWorkWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
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
                            '运输单号：${ff()[index].orderNumber}',
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
                            '${ff()[index].Departure}',
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
                            '${ff()[index].destination}',
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
                            '司机：${ff()[index].driverName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: SizeConfig.widthMultiplier * 4),
                          )),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ff()[index].state,
                                  style: TextStyle(
                                      color: ff()[index].isFinish == 1
                                          ? Colors.red
                                          : Colors.green),
                                ),
                                Image.asset(
                                  'images/arrow.png',
                                  width: SizeConfig.widthMultiplier * 10,
                                  height: SizeConfig.heightMultiplier * 4,
                                  fit: BoxFit.cover,
                                  color: ff()[index].isFinish == 1
                                      ? Colors.red
                                      : Colors.green,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '项目：${ff()[index].projectName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: SizeConfig.widthMultiplier * 4),
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('送货单信息',
                              style: TextStyle(
                                  fontSize: SizeConfig.widthMultiplier * 4))
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.widthMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(ff()[index].message,
                              style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            date(ff()[index].orderTime),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: SizeConfig.heightMultiplier * 2),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: ff().length,
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
