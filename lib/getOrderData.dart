import 'package:flutter/material.dart';
import 'package:mydemo/logisticsInformation.dart';
import 'package:mydemo/OrderNetWorkWidget.dart';
import 'constant.dart';
import 'sizeConfig.dart';

class getOrderData extends StatefulWidget {
  @override
  _getOrderDataState createState() => _getOrderDataState();
  String state;

  getOrderData(this.state);
}

class _getOrderDataState extends State<getOrderData> {
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
                //网络请求UI,传入数据
                child: OrderNetWorkWidget(),
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
      future: _getData(),
    );
  }

  //根据选择下拉菜单的值请求订单数据
  Future _getData() async {
    return Future.delayed(Duration(seconds: 2), () => ff());
  }
}
