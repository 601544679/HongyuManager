import 'package:flutter/material.dart';
import 'package:mydemo/OrderNetWorkWidget.dart';
import 'constant.dart';
import 'sizeConfig.dart';
import 'userclass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'server.dart';
import 'package:r_logger/r_logger.dart';

//获取订单数据
class getOrderData extends StatefulWidget {
  @override
  _getOrderDataState createState() => _getOrderDataState();
  String state;

  getOrderData(this.state);
}

class _getOrderDataState extends State<getOrderData> {
  DateTime historydate;
  var waybills;
  var waybillRecord;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              return Expanded(
                //todo 网络请求数据,传入UI
                child: OrderNetWorkWidget(
                  waybill: waybillRecord,
                ),
              );
            }
            break;
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.indigo[colorNum]),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Text('正在加载...')
              ],
            );
            break;
          case ConnectionState.active:
            print('active');
            break;
        }
      },
      future: _getData(widget.state),
    );
  }

  //todo 根据选择下拉菜单的值请求订单数据
  Future _getData(String state) async {
    waybillRecord = await Server().getWaybillByValue(state);
    //waybills = waybillRecord['result'];
    //print('返回的类型${waybillRecord.runtimeType}');
    //RLogger.instance.d(waybills.toString());
    return waybillRecord;
  }
}
