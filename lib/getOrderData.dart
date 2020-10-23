import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/OrderNetWorkWidget.dart';
import 'LogUtils.dart';
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

  getOrderData(this.state, {Key key}) : super(key: key);
}

class _getOrderDataState extends State<getOrderData> {
  DateTime historydate;
  var waybills;
  var waybillRecord;
  var saveFutureBuilder;
  Future getData;


  //被父组件调用的方法
  chidFunction() {
    print('我被父组件调用了');
    // netWorkChildKey.currentState.backToTop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('getOrderData--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('getOrderData--didChangeDependencies');
  }

  @override
  void didUpdateWidget(getOrderData oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('getOrderData--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('getOrderData--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('getOrderData--dispose');
  }

  @override
  Widget build(BuildContext context) {
    print('getOrderData--build');
    return FutureBuilder(
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print('done');
            //print('done---${snapshot.hashCode}');
            //print('done---${snapshot.data}');
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              print('hasData');
              // 请求成功，显示数据
              return Expanded(
                //todo 网络请求数据,传入UI
                child: OrderNetWorkWidget(
                  waybill: waybillRecord,
                  key: netWorkChildKey,
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
    var responseBody;
    waybillRecord = await Server().getWaybillByValue(state);
    //waybills = waybillRecord['result'];
    print('返回的类型---${waybillRecord.runtimeType}');
    return waybillRecord;
  }

}
