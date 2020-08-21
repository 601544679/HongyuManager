import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'logisticsInformation.dart';
import 'orderWidget.dart';

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  String order = '订单详情';
  int colorNum = 600;
  String value = '0';
  List<DropdownMenuItem> dropdownMenuItem = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier ,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
                value: value,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      '所有订单',
                      style: TextStyle(
                          color: Colors.indigo[colorNum],
                          fontSize: SizeConfig.widthMultiplier * 5),
                    ),
                    value: '0',
                  ),
                  DropdownMenuItem(
                      child: Text(
                        '运输中',
                        style: TextStyle(
                            color: Colors.indigo[colorNum],
                            fontSize: SizeConfig.widthMultiplier * 5),
                      ),
                      value: '1'),
                  DropdownMenuItem(
                      child: Text(
                        '已完成',
                        style: TextStyle(
                            color: Colors.indigo[colorNum],
                            fontSize: SizeConfig.widthMultiplier * 5),
                      ),
                      value: '2')
                ],
                onChanged: (value) {
                  print(value);
                  setState(() {
                    this.value = value;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.indigo[colorNum],
                  size: SizeConfig.heightMultiplier * 4,
                ),
              ))
            ],
          ),
          Expanded(
              child: ListView(
            children: [OrderWidget(this.value)],
          ))
        ],
      ),
    );
  }

  String _string(String value) {
    switch (value) {
      case '0':
        return '所有订单';
        break;
      case '1':
        return '运输中';
        break;
      case '2':
        return '已完成';
        break;
    }
  }
}
