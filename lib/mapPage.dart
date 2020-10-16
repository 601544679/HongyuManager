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
    var result =
        await Server().getAll('positionInfo', widget.orderNumber, false);
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
        var result = await Server()
            .getAll('positionInfo', widget.orderNumber, true, cursor: cursor);
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
                      height: ScreenUtil().setHeight(45),
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
          title: Text('运货追踪'),
          centerTitle: true,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(1124),
                child: AmapView(
                  mapType: MapType.Standard,
                  zoomLevel: 15,
                  maskDelay: Duration(milliseconds: 500),
                  centerCoordinate: LatLng(
                      widget.latLngList[0]['position']['latitude'],
                      widget.latLngList[0]['position']['longitude']),
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
              Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(34), left: 10.0, right: 10.0),
                height: ScreenUtil().setHeight(148),
                child: Text(
                  '送货信息',
                  style: TextStyle(
                      fontSize: ScreenUtil().setHeight(50),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
                width: ScreenUtil().setWidth(1051),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.grey,
                  color: Colors.grey[300],
                  elevation: 2,
                  child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(54)),
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
                                    fontSize: ScreenUtil().setHeight(50),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Expanded(
                                child: Text(
                                  index == 2
                                      ? '   ' + contentList[index]
                                      : contentList[index],
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(50),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: titleList.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: ScreenUtil().setHeight(23),
                          );
                        },
                      )),
                ),
              ),
            ],
          ),
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
          height: ScreenUtil().setHeight(101),
          width: ScreenUtil().setWidth(162),
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
                      fontFamily: 'Montserrat'),
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
      height = ScreenUtil().setWidth(65);
      width = ScreenUtil().setWidth(195);
    } else if (i == 0) {
      height = ScreenUtil().setWidth(150);
      width = ScreenUtil().setWidth(432);
    } else {
      height = ScreenUtil().setWidth(33);
      width = ScreenUtil().setWidth(33);
    }
    return Container(
      height: height,
      width: width,
      child: Material(
        borderRadius: BorderRadius.circular(30),
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
            fontFamily: 'Montserrat'));
  }
}
