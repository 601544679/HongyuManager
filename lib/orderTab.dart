import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'getOrderData.dart';
import 'mySearch.dart';
import 'server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  List<DropdownMenuItem> dropdownMenuItem = List();
  List result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orderTabName),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () async {
                /* var response = await Server().searchSuggestion();
                result = response['result'];*/
                Future<SharedPreferences> _prefs =
                    SharedPreferences.getInstance();
                final SharedPreferences preferences = await _prefs;
                final history = preferences.getStringList('historyList');
                print('历史$history');
                showSearch(
                    context: context, delegate: searchbar(result, history));
                //print('$result');
              })
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                style: TextStyle(
                    fontSize:
                        ScreenUtil().setSp(45, allowFontScalingSelf: true)),
                value: dropDownButtonValue,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      '所有订单',
                      style: TextStyle(
                          color: Colors.indigo[colorNum],
                          fontSize: ScreenUtil()
                              .setSp(55, allowFontScalingSelf: true)),
                    ),
                    value: '0',
                  ),
                  DropdownMenuItem(
                      child: Text(
                        '运输中',
                        style: TextStyle(
                            color: Colors.indigo[colorNum],
                            fontSize: ScreenUtil()
                                .setSp(55, allowFontScalingSelf: true)),
                      ),
                      value: '1'),
                  DropdownMenuItem(
                      child: Text(
                        '已完成',
                        style: TextStyle(
                            color: Colors.indigo[colorNum],
                            fontSize: ScreenUtil()
                                .setSp(55, allowFontScalingSelf: true)),
                      ),
                      value: '2')
                ],
                onChanged: (value) {
                  print(value);
                  setState(() {
                    dropDownButtonValue = value;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.indigo[colorNum],
                  size: ScreenUtil().setHeight(90),
                ),
              ))
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [getOrderData(dropDownButtonValue)],
          ))
        ],
      ),
    );
  }
}
