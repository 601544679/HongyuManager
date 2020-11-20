import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'getOrderData.dart';
import 'mySearch.dart';
import 'server.dart';
import 'package:mydemo/OrderNetWorkWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTab extends StatefulWidget {
  final showBtn;

  OrderTab({this.showBtn});

  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab>
    with AutomaticKeepAliveClientMixin {
  bool showToTopBtn = false;
  String dropDownButtonValue = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('OrderTab--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('OrderTab--didChangeDependencies');
  }

  @override
  void didUpdateWidget(OrderTab oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('OrderTab--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('OrderTab--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('OrderTab--dispose');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('OrderTab--build');
    List<DropdownMenuItem> dropdownMenuItemList = List();
    List<String> title = [
      '所有订单',
      '运输中',
      '已完成',
    ];
    List<DropdownMenuItem> dropdownMenuItem() {
      for (int i = 0; i < title.length; i++) {
        dropdownMenuItemList.add(DropdownMenuItem(
          child: Container(
            child: Text(
              title[i],
              style: TextStyle(
                  color: Colors.indigo[colorNum],
                  fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true)),
            ),
          ),
          value: i.toString(),
        ));
      }
      return dropdownMenuItemList;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true),
                fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: setWidth(38)),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: setWidth(45),
                ),
                onPressed: () async {
                  /* var response = await Server().searchSuggestion();
                result = response['result'];*/
                  Future<SharedPreferences> _prefs =
                      SharedPreferences.getInstance();
                  final SharedPreferences preferences = await _prefs;
                  final history = preferences.getStringList('historyList');
                  print('历史$history');
                  showSearch(context: context, delegate: searchbar(history));
                  //print('$result');
                }),
          )
        ],
      ),
      body: Container(
        color: Colors.white12,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: TextStyle(
                        fontSize:
                            ScreenUtil().setSp(30, allowFontScalingSelf: true)),
                    value: dropDownButtonValue,
                    items: dropdownMenuItem(),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        dropDownButtonValue = value;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.indigo[colorNum],
                      size: setHeight(54),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getOrderData(
                  dropDownButtonValue,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
