import 'dart:convert';
import 'dart:io';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mydemo/constant.dart';
import 'sizeConfig.dart';
import 'package:r_logger/r_logger.dart';
import 'server.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

//发布订单
class ReleaseOrder extends StatefulWidget {
  @override
  _ReleaseOrderState createState() => _ReleaseOrderState();
}

class _ReleaseOrderState extends State<ReleaseOrder>
    with AmapSearchDisposeMixin {
  Map<String, dynamic> map = {};
  final _releaseFormKey = GlobalKey<FormState>();
  List valueList = List();
  List splited = List();
  List splited1 = List();
  List allSplited = List();
  List rowToList = List();
  List cutList = List();
  List mapList = List();
  Map<String, dynamic> rowMap = Map();
  Map<String, dynamic> allMap = Map();
  bool visible = false;
  double latitude = 0;
  double longitude = 0;

  List valueToMap = List();

  TextInputType _textInputType(int index) {
    switch (index) {
      case 20:
      case 21:
      case 23:
      case 24:
      case 25:
        return TextInputType.number;
        break;
      default:
        return TextInputType.text;
        break;
    }
  }

  List<TextInputFormatter> textInputFormatter(int index) {
    List<TextInputFormatter> tt = [
      FilteringTextInputFormatter.allow(RegExp("[0-9.\n]"))
    ];
    List<TextInputFormatter> tt1 = [];
    switch (index) {
      case 20:
      case 21:
      case 23:
      case 24:
      case 25:
        return tt;
        break;
      default:
        return tt1;
        break;
    }
  }

  checkPermission() async {
    bool status = await Permission.storage.isGranted;
    if (status) {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        readExcel(result.files.single.path);
      }
    } else {
      Permission.storage.request();
    }
  }

  readExcel(String filePath) async {
    var file = filePath;
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    cutList.clear();
    rowToList.clear();
    mapList.clear();
    allMap.clear();
    rowMap.clear();
    //遍历Excel
    for (var table in excel.tables.keys) {
      print('table：${table}');
      print('maxCols：${excel.tables[table].maxCols}');
      print('maxRows：${excel.tables[table].maxRows}');
      for (var row in excel.tables[table].rows) {
        for (int i = 0; i < row.length; i++) {
          if (row[i] == null) {
            row[i] = '';
          }
          //print('${i}---${row[i]}');
        }
        rowToList.add(row);
      }
    }
    //裁剪去掉标题
    cutList = rowToList.sublist(1, rowToList.length - 1);
    //cutList = rowToList.sublist(1, 5);
    valueToMap.clear();
    //格式处理
    var lating;
    for (var value in cutList) {
      List allList = List();
      for (int i = 0; i < value.length; i++) {
        List valueToList = List();
        if (i == 0) {
          value[i] = DateTime.parse(value[i]).millisecondsSinceEpoch;
          allList.add(value[i]);
        } else if (i == 3 || i > 14) {
          valueToList = [value[i]];
          allList.add(valueToList);
        } else {
          allList.add(value[i]);
        }
      }
      valueToMap.add(allList);
    }
    //转化为map
    List aa = List();
    aa.clear();
    int success = 0;
    int failed = 0;
    Fluttertoast.showToast(msg: '开始上传', toastLength: Toast.LENGTH_SHORT);
    for (var value in valueToMap) {
      Map<String, dynamic> map = {};
      map = Map.fromIterables(jsonTitle, value);
      //print('map----${map}');
      //print('地址 ${map['projectAddress']}');
      if (map['projectAddress'] != '-') {
        lating = await changeLat(map['projectAddress']);
        print('值1 ${lating.latitude},${lating.longitude}');
        Map<String, dynamic> map2 = {};
        map2 = {"__type": "GeoPoint"};
        map2.addAll({'latitude': lating.latitude});
        map2.addAll({'longitude': lating.longitude});
        map.addAll({'destination': map2});
        map.addAll({"destinationName": place(map['projectAddress'])});
      }
      bool result = true;
      var responseBody;
      print('当前请求$map');
      if (result) {
        responseBody = await Server().releaseByExcel(map);
        print('结果--$responseBody');
        if (responseBody != null) {
          setState(() {
            result = true;
          });
          print('responseBody$responseBody');
          if (responseBody['result'].toString().contains('success')) {
            setState(() {
              success++;
            });
          } else {
            setState(() {
              failed++;
            });
          }
        }
      }
    }

    Fluttertoast.showToast(
        msg: '成功上传$success条数据,失败$failed条', toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    var _controllers = <TextEditingController>[];
    for (var i = 0; i < list.length; i++) {
      var _controller = new TextEditingController();
      _controllers.add(_controller);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('发布订单'),
        actions: [
          MaterialButton(
            onPressed: () {
              checkPermission();
            },
            child: Text(
              '从Excel导入',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.widthMultiplier * 2,
            SizeConfig.heightMultiplier,
            SizeConfig.widthMultiplier * 2,
            SizeConfig.heightMultiplier),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('订单内容',
                      style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2,
                          fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier,
              ),
              TextField(
                maxLines: null,
                //智能识别，裁剪
                onChanged: (value) async {
                  splited = value.split(" ");
                  splited1 = value.split('\n');
                  for (int i = 0; i < splited1.length; i++) {
                    splited = splited1[i].toString().split(" ");
                    allSplited.add(splited);
                  }
                  //print('allSplited:${allSplited}');
                  //print('splited1:${splited1}');
                  //print('splited1:${splited1.length}');
                  //print('识别：${splited}');
                  //print('list长度${list.length}');
                  for (var value in allSplited) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i] == '') {
                        value[i] = ' ';
                      }
                      if (_controllers[i].text == "") {
                        _controllers[i].text = value[i];
                      } else if (_controllers[i].text != value[i] ||
                          i == 3 ||
                          i == 19 ||
                          i == 24 ||
                          i == 26 ||
                          i == 27) {
                        _controllers[i].text =
                            _controllers[i].text + '\n' + value[i];
                      }
                    }
                    //print('value${value}');
                  }
                },
                decoration: InputDecoration(
                    hintText: '请粘贴复制的订单内容',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: SizeConfig.widthMultiplier),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(
                height: SizeConfig.widthMultiplier,
              ),
              Form(
                key: _releaseFormKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}:${list[index]}',
                              style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.widthMultiplier,
                        ),
                        TextFormField(
                          // ignore: missing_return
                          //todo 指定输入类型有bug
                          keyboardType: TextInputType.multiline,
                          inputFormatters: textInputFormatter(index),
                          controller: _controllers[index],
                          textInputAction: TextInputAction.newline,
                          validator: (value) {
                            //print('value${value}');
                            if (value.isEmpty) {
                              return '请输入${list[index]}';
                            }
                            return null;
                          },
                          onSaved: (value) async {
                            //valueList.add(value);
                            Map<String, dynamic> map1 = {};
                            switch (index) {
                              case 0:
                                map1 = {
                                  jsonTitle[index]: DateTime.parse(value)
                                      .millisecondsSinceEpoch
                                };
                                break;
                              case 3:
                              case 15:
                              case 16:
                              case 17:
                              case 18:
                              case 19:
                              case 20:
                              case 21:
                              case 22:
                              case 23:
                              case 24:
                              case 25:
                              case 26:
                              case 27:
                                List ll = List();
                                for (int i = 0;
                                    i < value.split('\n').length;
                                    i++) {
                                  ll.add(value.split('\n')[i] == " "
                                      ? ''
                                      : value.split('\n')[i]);
                                }
                                map1 = {jsonTitle[index]: ll};
                                break;
                              default:
                                map1 = {
                                  jsonTitle[index]: value == " " ? '' : value
                                };
                                break;
                            }
                            map.addAll(map1);
                            // todo 缺发货地
                            map.addAll({
                              "destinationName": place(_controllers[7].text)
                            });

                            //RLogger.instance.d(jsonEncode(map), tag: 'wer');
                            //print(place('香港特别行政区中西区薄扶林道'));
                            //print(place('西藏自治区拉萨市'));
                            //print(place('北京市东城区景山前街4号'));
                            //print(place('广东省广州市天河区东站路1号'));
                          },
                          decoration: InputDecoration(
                              hintText: '请输入${list[index]}',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: SizeConfig.heightMultiplier,
                                      color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              hintStyle: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 1.5)),
                          maxLines: null,
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        )
                      ],
                    );
                  },
                  itemCount: list.length,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FlatButton(
        color: Colors.indigo[colorNum],
        textColor: Colors.white,
        onPressed: () async {
          //todo 发布订单
          //print("7777${_controllers[7].text}");
          if (_releaseFormKey.currentState.validate()) {
            _releaseFormKey.currentState.save();
            //print('TextFiled信息: ${valueList}');
            //print('map信息: ${map}');
            //print('map信息: ${jsonEncode(map)}');
            var lating = await changeLat(_controllers[7].text);
            print('值1 ${lating.latitude},${lating.longitude}');
            Map<String, dynamic> map2 = {};
            map2 = {"__type": "GeoPoint"};
            map2.addAll({'latitude': lating.latitude});
            map2.addAll({'longitude': lating.longitude});
            map.addAll({'destination': map2});
            var result = await Server().releaseWaybill(map);
            print('结果$result');
            switch (result['result']) {
              case '订单已存在':
                Fluttertoast.showToast(
                    msg: result['result'], toastLength: Toast.LENGTH_SHORT);
                break;
              case 'success':
                Fluttertoast.showToast(
                    msg: '订单发布成功', toastLength: Toast.LENGTH_SHORT);
                break;
              default:
                Fluttertoast.showToast(
                    msg: result['result'], toastLength: Toast.LENGTH_SHORT);
                break;
            }

            //RLogger.instance.d(jsonEncode(map), tag: 'ff');
          }
        },
        child: Text(
          '发布订单',
          style: TextStyle(
              fontSize: SizeConfig.heightMultiplier * 2,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //地址转经纬度
  changeLat(String address) async {
    final geocodeList =
        await AmapSearch.instance.searchGeocode(address, city: place(address));
    return geocodeList[0].latLng;
  }

  //返回目的地发货地
  String place(String location) {
    if (location.contains('省')) {
      //省
      return location.substring(
          location.indexOf('省') + 1,
          location.indexOf('市') == -1
              ? location.indexOf('县') + 1
              : location.indexOf('市') + 1);
    } else if (location.contains('自治')) {
      //自治区
      return location.substring(
          location.indexOf('区') + 1, location.indexOf('市') + 1);
    } else if (location.contains('特别')) {
      //港澳
      return location.substring(0, 2);
    } else if (location.contains('北京') ||
        location.contains('天津') ||
        location.contains('上海') ||
        location.contains('重庆')) {
      return location.substring(0, location.indexOf('市') + 1);
    } else {
      //不规则
      return location.substring(0, 2);
    }
  }
}
