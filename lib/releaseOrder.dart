import 'dart:convert';
import 'dart:io';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/constant.dart';
import 'sizeConfig.dart';
import 'package:r_logger/r_logger.dart';
import 'server.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'uploadDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constant.dart';

//发布订单
class ReleaseOrder extends StatefulWidget {
  @override
  _ReleaseOrderState createState() => _ReleaseOrderState();
}

class _ReleaseOrderState
    extends State<ReleaseOrder> /*with AmapSearchDisposeMixin*/ {
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
  bool tokenIsUseful = true;
  var _controllers = <TextEditingController>[];
  List driverMessage = [
    '派车单单号',
    '送货单号',
    '车牌号码',
    '运输公司',
    '公司名称',
    '司机电话',
    '司机姓名',
    '证件号码',
    '道路运输证',
    '从业资格证',
    '预计到达日'
  ];

  //判断是司机表还是送货单表
  String firstTitle;

  //滚动监听
  ScrollController scrollController = ScrollController();
  bool showToTopBtn = false;
  double position;
  var bb;

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

//excel格式一定要xlsx
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
      print('table：$table');
      print('maxCols：${excel.tables[table].maxCols}');
      print('maxRows：${excel.tables[table].maxRows}');
      //判断是司机表还是送货单表
      setState(() {
        firstTitle = excel.tables[table].rows[0][0].toString();
      });
      for (var row in excel.tables[table].rows) {
        for (int i = 0; i < row.length; i++) {
          if (row[i] == null) {
            row[i] = '';
          }
          print('$i---${row[i]}');
        }
        rowToList.add(row);
      }
    }
    print('标题----$firstTitle');
    //裁剪去掉标题
    //cutList = rowToList.sublist(1, rowToList.length - 1);
    cutList = rowToList.sublist(1, 12);
    valueToMap.clear();
    if (firstTitle == '送货日期') {
      //格式处理
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
    } else {
      //上传司机信息
      for (var value in cutList) {
        List allList = List();
        for (int i = 0; i < value.length; i++) {
          List valueToList = List();
          if (i == 0 ||
              i == 1 ||
              i == 24 ||
              i == 25 ||
              i == 27 ||
              i == 28 ||
              i == 29 ||
              i == 25) {
            valueToList.add(value[i]);
          }
        }
        valueToMap.add(allList);
      }
    }

    //转化为map
    List aa = List();
    aa.clear();
    Fluttertoast.showToast(msg: '开始上传', toastLength: Toast.LENGTH_SHORT);
    /* showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return uploadDialog(valueToMap, firstTitle == '送货日期' ? true : false);
        });*/
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('ReleaseOrder--didChangeDependencies');
    bb = PageStorage.of(context).readState(context);
    if (bb != null) {}
  }

  @override
  void didUpdateWidget(ReleaseOrder oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('ReleaseOrder--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('ReleaseOrder--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('ReleaseOrder--dispose');
    AmapSearch.instance.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ReleaseOrder--initState');
    scrollController.addListener(() {
      print('滚动位置:${scrollController.offset}');
      print('滚动位置1:${scrollController.initialScrollOffset}');
      setState(() {
        position = scrollController.offset;
      });
      if (scrollController.offset < 300 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (scrollController.offset >= 300 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  getToken() async {
    //getCurrent要配合LCUser.loginByMobilePhoneNumber不然本地缓存没有记录
    Future.delayed(Duration(milliseconds: 500)).then((value) async {
      LCUser currentUser = await LCUser.getCurrent();
      bool isAuthenticated = await currentUser.isAuthenticated();
      print('currentUser==${currentUser.sessionToken}');
      if (isAuthenticated) {
        // session token 有效
        print('token有效');
        if (isAuthenticated && tokenIsUseful != true) {
          setState(() {
            tokenIsUseful = true;
          });
        }
      } else {
        // session token 无效
        print('token无效');
        if (!isAuthenticated && tokenIsUseful != false) {
          setState(() {
            tokenIsUseful = false;
          });
        }
      }
    });

    //return isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    print('ReleaseOrder--build');
    for (var i = 0; i < list.length; i++) {
      var _controller = new TextEditingController();
      _controllers.add(_controller);
    }
    getToken();
    return tokenIsUseful == false
        ? Scaffold(
            body: AlertDialog(
              title: Text('该账号已在新设备登录，点击重新登录'),
              elevation: 3,
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/loginPage', (route) => route == null);
                  },
                  child: Text('确定'),
                )
              ],
            ),
          )
        : Scaffold(
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
                  ScreenUtil().setWidth(22),
                  ScreenUtil().setHeight(23),
                  ScreenUtil().setWidth(22),
                  ScreenUtil().setHeight(23)),
              child: SingleChildScrollView(
                //todo bug监听滚动不能填充，解决TextFromFiled的controller变量放在build外面
                controller: scrollController,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('订单内容',
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(47, allowFontScalingSelf: true),
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(23),
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
                          //print('长度---${_controllers[20].text}');
                        }
                      },
                      decoration: InputDecoration(
                          hintText: '请粘贴复制的订单内容',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: ScreenUtil().setWidth(18)),
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
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
                                        fontSize: ScreenUtil().setSp(47,
                                            allowFontScalingSelf: true),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
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
                                    case 20:
                                    case 21:
                                    case 22:
                                    case 23:
                                    case 24:
                                    case 25:
                                      List ll = List();
                                      for (int i = 0;
                                          i < value.split('\n').length;
                                          i++) {
                                        ll.add(value.split('\n')[i] == " "
                                            ? ''
                                            : double.parse(
                                                value.split('\n')[i]));
                                      }
                                      map1 = {jsonTitle[index]: ll};
                                      break;
                                    case 3:
                                    case 15:
                                    case 16:
                                    case 17:
                                    case 18:
                                    case 19:
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
                                        jsonTitle[index]:
                                            value == " " ? '' : value
                                      };
                                      break;
                                  }
                                  map.addAll(map1);
                                  // todo 缺发货地
                                  map.addAll({
                                    "destinationName":
                                        place(_controllers[7].text)
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
                                            width: ScreenUtil().setWidth(18),
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    hintStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(40,
                                            allowFontScalingSelf: true))),
                                maxLines: null,
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(23),
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
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Container(
              height: ScreenUtil().setHeight(350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                      visible: showToTopBtn,
                      child: Container(
                        height: ScreenUtil().setHeight(100),
                        width: ScreenUtil().setHeight(100),
                        child: FloatingActionButton(
                          elevation: 0,
                          onPressed: () {
                            scrollController.animateTo(0,
                                duration: Duration(seconds: 1),
                                curve: Curves.ease);
                          },
                          child: Icon(Icons.arrow_upward),
                        ),
                      )),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  FlatButton(
                    color: Colors.indigo[colorNum],
                    textColor: Colors.white,
                    onPressed: () async {
                      //todo 发布订单
                      //print("7777${_controllers[7].text}");
                      if (_releaseFormKey.currentState.validate()) {
                        _releaseFormKey.currentState.save();
                        //print('TextFiled信息: ${valueList}');
                        print('map信息: ${map}');
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
                                msg: result['result'],
                                toastLength: Toast.LENGTH_SHORT);
                            break;
                          case 'success':
                            Fluttertoast.showToast(
                                msg: '订单发布成功', toastLength: Toast.LENGTH_SHORT);
                            break;
                          default:
                            Fluttertoast.showToast(
                                msg: result['result'],
                                toastLength: Toast.LENGTH_SHORT);
                            break;
                        }

                        RLogger.instance.d(jsonEncode(map), tag: 'ff');
                      }
                    },
                    child: Text(
                      '发布订单',
                      style: TextStyle(
                          fontSize: ScreenUtil()
                              .setSp(47, allowFontScalingSelf: true),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
