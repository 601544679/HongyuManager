import 'package:flutter/material.dart';
import 'package:mydemo/OrderNetWorkWidget.dart';
import 'constant.dart';
import 'sizeConfig.dart';
import 'userclass.dart';
import 'server.dart';

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
                  waybill: waybills,
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
    switch (widget.state) {
      case '0':
        //state=0获取所有订单
        waybillRecord = await Server().getAllWaybill();
        break;
      case '1':
        //state=1获取运输中订单
        waybillRecord = await Server().getWaybillTransport();
        break;
      case '2':
        //state=2获取已完成订单
        waybillRecord = await Server().getWaybillHistory();
        break;
    }
    waybills = waybillRecord['result'];
    return 1;
  }
}
