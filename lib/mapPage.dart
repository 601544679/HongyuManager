//import 'package:amap_location/amap_location.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/LogUtils.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'server.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
  String orderNumber;

  MapPage({this.orderNumber});
}

class _MapPageState extends State<MapPage> {
  AmapController amapController;
  int count;
  List<dynamic> resultList = List();

  //游标，记录上一次查询的位置
  String cursor;
  var a = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
    print('MapPage--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('MapPage--didChangeDependencies');
  }

  @override
  void didUpdateWidget(MapPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('MapPage--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('MapPage--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('MapPage--dispose');
  }

  getCount() async {
    print('getCount');
    LCQuery<LCObject> query = LCQuery('positionInfo');
    print('waybill_ID=${widget.orderNumber}');
    query.whereEqualTo('waybill_ID', widget.orderNumber);
    int count = await query.count();
    print('总数=$count');
    setState(() {
      this.count = count;
      print('总数1=$count');
    });
    var result = await Server()
        .getAll('positionInfo', 'waybill_ID', widget.orderNumber, false);
    setState(() {
      cursor = result["cursor"];
      print('类型=${result.runtimeType}');
      resultList.addAll(result['results']);
    }); //计算要遍历多少次
    int frequency = count ~/ (result["results"].length); //~/(取整)
    print('result.length=${result["results"].length}');
    print('cursor=$cursor');
    print('frequency=$frequency');
    if (cursor == 'null') {
      return resultList;
    } else {
      for (int i = 0; i < frequency; i++) {
        var result = await Server().getAll(
            'positionInfo', 'waybill_ID', widget.orderNumber, true,
            cursor: cursor);
        print('result.length=${result["results"].length}');
        setState(() {
          resultList.addAll(result["results"]);
        });
        print('结果=$result');
        LogUtils.d('结果=', '$resultList');
      }
      print('遍历长度=${resultList.length}');
      //resultList.sort((a, b) => b.createAt.compareTo(a.createAt));
      return resultList;
    }
  }

  _loadWaybill() async {
    print('_loadWaybill');
    var result = await Server().getWaybillAdmin(widget.orderNumber);
    print('地图类型: ${result.runtimeType}');
    return result;
    //return 1;
  }

  @override
  Widget build(BuildContext context) {
    print('MapPage--build');
    print('传入的订单号${widget.orderNumber}');
    return Scaffold(
      body: FutureBuilder(
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
              if (snapshot.hasError)
                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text('运货追踪'),
                  ),
                  body: InkWell(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off_outlined,
                            size: setWidth(200),
                            color: Colors.indigo[colorNum],
                          ),
                          SizedBox(
                            height: setHeight(20),
                          ),
                          Text(
                            '网络错误,点击重试',
                            style: TextStyle(
                              fontSize: ScreenUtil()
                                  .setSp(30, allowFontScalingSelf: true),
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[colorNum],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        a = '1';
                      });
                    },
                  ),
                );
              return MapScreen(
                waybill: snapshot.data,
                latLngList: resultList,
              );
            default:
              return null;
          }
        },
        future: _loadWaybill(),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
  final waybill;
  final latLngList;

  MapScreen({Key key, this.waybill, this.latLngList}) : super(key: key);
}

class _MapScreenState extends State<MapScreen> {
  bool tokenIsUseful = true;
  String fontFamily = 'Montserrat';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //停止监听定位、销毁定位
    super.dispose();
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
        setState(() {
          tokenIsUseful = true;
        });
      } else {
        // session token 无效
        print('token无效');
        setState(() {
          tokenIsUseful = false;
        });
      }
    });

    //return isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    print('类型====${widget.waybill.runtimeType}');
    //print("目的地：${widget.waybill['result']['destination']['latitude']}");
    //print("目的地：${widget.waybill['result']['destination']['longitude']}");
    /* List<LatLng> latLngList = List();
    for (int i = 0; i < widget.latLngList.length; i++) {
      LatLng latLng = LatLng(
          widget.latLngList[i]['position']['latitude'].toDouble(),
          widget.latLngList[i]['position']['longitude'].toDouble());
      latLngList.add(latLng);
    }*/
    List titleList = ['送货单号：', '送货地址：', '收货人：', '收货人电话：'];
    if (tokenIsUseful == false) {
      return AlertDialog(
        title: Text(retryLogin),
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
      );
    } else if (tokenIsUseful == true) {
      //token有效就不会存在这种情况
      /*if (widget.waybill.runtimeType == int) {
        return AlertDialog(
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
        );
      }*/
      List contentList = [
        widget.waybill['result']['ID'],
        widget.waybill['result']['address'],
        widget.waybill['result']['receiver'],
        widget.waybill['result']['receiverPhone']
      ];
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '运货追踪',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true)),
          ),
          centerTitle: true,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: setHeight(1334),
              child: AmapView(
                mapType: MapType.Standard,
                zoomLevel: 15,
                showCompass: true,
                showScaleControl: true,
                showZoomControl: true,
                rotateGestureEnabled: true,
                autoRelease: true,
                scrollGesturesEnabled: true,
                tiltGestureEnabled: true,
                zoomGesturesEnabled: true,
                maskDelay: Duration(milliseconds: 500),
                centerCoordinate: LatLng(
                    widget.latLngList[widget.latLngList.length - 1]['position']
                        ['latitude'],
                    widget.latLngList[widget.latLngList.length - 1]['position']
                        ['longitude']),
                markers: makeOptions(),
                onMapCreated: (controller) async {
                  await controller?.showMyLocation(MyLocationOption(
                      myLocationType: MyLocationType.Follow,
                      interval: Duration(seconds: 10)));
                  /*await controller
                      .addPolyline(PolylineOption(latLngList: latLngList));*/
                  await controller.showTraffic(true);
                  await controller.showCompass(true);
                  //await controller.showLocateControl(true);
                  await controller.showScaleControl(true);
                  await controller.showZoomControl(true);
                },
              ),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(setWidth(0)),
                width: setWidth(750),
                decoration: BoxDecoration(
                  boxShadow: [
                    //阴影效果
                    BoxShadow(
                      offset: Offset(0, 0), //阴影在X轴和Y轴上的偏移
                      color: Colors.grey, //阴影颜色
                      blurRadius: 3.0, //阴影程度
                      spreadRadius: 0, //阴影扩散的程度 取值可以正数,也可以是负数
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Material(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  shadowColor: Colors.grey,
                  color: Color(0xffffffff),
                  elevation: 2,
                  child: Padding(
                      padding: EdgeInsets.all(setWidth(38)),
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                titleList[index],
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(35, allowFontScalingSelf: true),
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff485158)),
                              ),
                              Expanded(
                                child: Text(
                                  index == 2
                                      ? '    ' + contentList[index]
                                      : contentList[index],
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(35,
                                          allowFontScalingSelf: true),
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff485158)),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: titleList.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: setHeight(14),
                          );
                        },
                      )),
                ),
              ),
              bottom: setHeight(0),
            )
          ],
        ),
      );
    }
  }

  List<MarkerOption> makeOptions() {
    List<MarkerOption> marks = [];
    for (int i = 0; i < widget.latLngList.length; i++) {
      //print('获取:${widget.waybill['result']['latitude'][i].toDouble()}');
      //print('长度:${widget.waybill['result']['latitude'].length}');
      marks.add(MarkerOption(
          latLng: LatLng(
              widget.latLngList[i]['position']['latitude'].toDouble(),
              widget.latLngList[i]['position']['longitude'].toDouble()),
          title: widget.latLngList[i]['positionName'],
          widget: showOptions(i)));
    }
    marks.add(MarkerOption(
        latLng: LatLng(
            widget.waybill['result']['destination']['latitude'].toDouble() ??
                23.03509484,
            widget.waybill['result']['destination']['longitude'].toDouble() ??
                113.13402564),
        title: widget.waybill['result']['projectAddress'] ?? '',
        widget: Container(
          height: setHeight(60),
          width: setWidth(113),
          child: Material(
            borderRadius: BorderRadius.circular(30),
            shadowColor: Colors.transparent,
            color: Colors.amber,
            elevation: 7.0,
            child: InkWell(
              child: Center(
                child: Text(
                  '目的地',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:
                          ScreenUtil().setSp(30, allowFontScalingSelf: true),
                      fontFamily: fontFamily),
                ),
              ),
            ),
          ),
        )));
    return marks;
  }

  Container showOptions(int i) {
    double height;
    double width;
    if (i == widget.latLngList.length - 1) {
      height = setWidth(45);
      width = setWidth(135);
    } else if (i == 0) {
      height = setWidth(131);
      width = setWidth(202);
    } else {
      height = setWidth(23);
      width = setWidth(23);
    }
    return Container(
      height: height,
      width: width,
      child: Material(
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.transparent,
        color: Colors.indigo[colorNum],
        child: Center(
          child: lastOptions(i),
        ),
      ),
    );
  }

  Text lastOptions(int i) {
    String text;
    if (i == 0) {
      String startTime = widget.latLngList[i]['createdAt'];
      String utcTime = startTime;
      DateTime beijingTime = DateTime.parse("${utcTime.substring(0, 19)}-0800");
      print(beijingTime);
      text =
          '开始运输\n${beijingTime.year}-${beijingTime.month}-${beijingTime.day}\n${beijingTime.hour}:${beijingTime.minute}:${beijingTime.second}';
    } else if (i == widget.latLngList.length - 1) {
      text = '当前位置';
    } else {
      text = '';
    }
    return Text(text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true),
            fontFamily: fontFamily));
  }
}
