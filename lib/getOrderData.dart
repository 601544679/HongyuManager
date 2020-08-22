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
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
            return Expanded(
                //    child: ListView(
                //  children: [
                //    //使用本地数据生成的UI
                //    //OrderWidget(widget.state),
                //  ],
                //)
              //网络请求UI,传入数据
              child: OrderNetWorkWidget(),
                );
          }
        } else {
          // 请求未结束，显示loading
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
