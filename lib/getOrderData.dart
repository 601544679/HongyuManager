import 'package:flutter/material.dart';
import 'package:mydemo/logisticsInformation.dart';
import 'package:mydemo/orderWidget.dart';
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
                child: ListView(
              children: [OrderWidget(widget.state)],
            ));
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
      future: dd(),
    );
  }

  //请求订单数据
  Future dd() async {
    return Future.delayed(Duration(seconds: 2), () => ff());
  }
}
