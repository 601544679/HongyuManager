import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mydemo/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'sizeConfig.dart';

class logisticsCompanyTab extends StatefulWidget {
  @override
  _logisticsCompanyTabState createState() => _logisticsCompanyTabState();
}

class _logisticsCompanyTabState extends State<logisticsCompanyTab> with AutomaticKeepAliveClientMixin {
  List dropdownList = List();
  String dropDownButtonValue = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlogisticsCompany();
    print('logisticsCompanyTab--initState');
  }

  getlogisticsCompany() async {
    var result = await Server().logisticsCompanyMessage();
    //去除重复元素
    var cutRespet = Set();
    cutRespet.addAll(result['result']);
    //print('LLL=${cutRespet.toList()}');
    setState(() {
      dropdownList = cutRespet.toList();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('logisticsCompanyTab--didChangeDependencies');
  }

  @override
  void didUpdateWidget(logisticsCompanyTab oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('logisticsCompanyTab--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('logisticsCompanyTab--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('logisticsCompanyTab--dispose');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<DropdownMenuItem> dropdownMenuItemList = List();
    List<DropdownMenuItem> dropdownMenuItem() {
      for (int i = 0; i < dropdownList.length; i++) {
        dropdownMenuItemList.add(DropdownMenuItem(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dropdownList[i],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.indigo[colorNum],
                    fontSize:
                        ScreenUtil().setSp(40, allowFontScalingSelf: true)),
              ),
            ],
          ),
          value: i.toString(),
        ));
      }
      return dropdownMenuItemList;
    }

    print('logisticsCompanyTab--build');
    return dropdownList.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: Container(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(30, allowFontScalingSelf: true)),
                        value: dropDownButtonValue,
                        items: dropdownMenuItem(),
                        onChanged: (value) {
                          print('啥$value');
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
                  ),
                ),
                logisticsCompany(dropdownList[int.parse(dropDownButtonValue)])
              ],
            ),
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class logisticsCompany extends StatefulWidget {
  String companyName;

  logisticsCompany(this.companyName);

  @override
  _logisticsCompanyState createState() => _logisticsCompanyState();
}

class _logisticsCompanyState extends State<logisticsCompany> {
  int currentTab = 0;
  bool visible = false;

  getCompanyMessage() async {
    var result = await Server().companyMessage(widget.companyName);
    return result['result'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCompanyMessage(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print('还没有开始网络请求');
              return Text('还没有开始网络请求');
            case ConnectionState.active:
              print('active');
              return Text('ConnectionState.active');
            case ConnectionState.waiting:
              print('waiting');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.indigo[colorNum]),
                    ),
                    SizedBox(
                      height: setHeight(27),
                    ),
                    Text(
                      '正在加载中...',
                      style: TextStyle(color: Colors.indigo[colorNum]),
                    )
                  ],
                ),
              );
            case ConnectionState.done:
              print('done');
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(15),
                      ),
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(15),
                            right: ScreenUtil().setWidth(15),
                            top: ScreenUtil().setHeight(14),
                            bottom: ScreenUtil().setHeight(14)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'images/huoche.png',
                                  width: ScreenUtil().setWidth(75),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(37.5),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '车牌：${snapshot.data[index]['carNo'].toString().substring(0, 2)}'
                                          '•${snapshot.data[index]['carNo'].toString().substring(2)}',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(30,
                                                  allowFontScalingSelf: true)),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '载重量：${snapshot.data[index]['deadWeight']}(吨)',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(30,
                                                  allowFontScalingSelf: true)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                    );
                  },
                  itemCount: snapshot.data.length);
            default:
              return null;
          }
        });
  }

  bool showVisible(int currentTab, int index, bool visible) {
    if (currentTab == index && visible == true) {
      return true;
    } else {
      return false;
    }
  }
}
