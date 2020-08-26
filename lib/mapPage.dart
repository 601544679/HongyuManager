import 'dart:math';

import 'package:amap_location/amap_location.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'userclass.dart';
import 'server.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
  String orderNumber;

  MapPage({this.orderNumber});
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    _loadWaybill() async {
      print('_loadWaybill');
      Waybill waybillT = await Waybill().getWaybill();
      var a = await Server().getWaybill(widget.orderNumber);
      print('waybillT: ${waybillT}');
      return (waybillT);
    }

    Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
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
            child: CircularProgressIndicator(),
          );
        case ConnectionState.done:
          print('done');
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          print('snapshot.data: ${snapshot.data}');
          return MapScreen(waybill: snapshot.data);
        default:
          return null;
      }
    }

    return Scaffold(
      body: FutureBuilder(
        builder: _buildFuture,
        future: _loadWaybill(),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
  final waybill;

  MapScreen({Key key, this.waybill}) : super(key: key);
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkPersmission();
  }

  var latLng;
  AmapController _controller;

  AMapLocation _location;
  num lastLongitude = 0.0;
  num lastLatitude = 0.0;
  double R = 6371.0;
  double longitude = 0.0;
  double latitude = 0.0;
  String _state = '确认到达';

  void checkPersmission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
    // 申请结果
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      _getLocation();
    } else {
      bool isOpened = await PermissionHandler().openAppSettings(); //打开应用设置
    }
  }

  @override
  void dispose() {
    //停止监听定位、销毁定位
    AMapLocationClient.stopLocation();
    AMapLocationClient.shutdown();
    super.dispose();
  }

  _getLocation() async {
    //启动一下
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    //获取地理位置（直接定位）
    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) async {
      if (!mounted) return;
      double error = R *
          acos(cos(loc.latitude) * cos(24) * cos(loc.longitude - 34) +
              sin(loc.latitude) * sin(24));
      if (sqrt(error) < 1) {
        setState(() {
          _state = "确认到达";
        });
      } else {
        setState(() {
          _state = "未到达";
        });
      }
      Fluttertoast.showToast(
        msg:
            "位置:${loc.longitude.toStringAsFixed(3)},${loc.latitude.toStringAsFixed(3)},${sqrt(error).toStringAsFixed(3)}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );
      print(loc.longitude);
      print(loc.latitude);
      var move = R *
          acos(cos(loc.latitude) *
                  cos(lastLatitude) *
                  cos(loc.longitude - lastLongitude) +
              sin(loc.latitude) * sin(lastLatitude));
      lastLatitude = loc.latitude;
      lastLongitude = loc.longitude;
      if ((move > 2) &&
          (lastLatitude * latitude * longitude * lastLongitude != 0)) {
        var response = await Server().posUpdate(
            widget.waybill.ID, latitude, longitude, loc.formattedAddress);
        print(response);
        if (response['result'] != 'success') {
          Fluttertoast.showToast(
            msg: "位置更新失败:${response}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
          );
        } else {
          Fluttertoast.showToast(
            msg: "位置已更新:${response}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
          );
        }
      }
      setState(() {
        _location = loc;
        latitude = loc.latitude;
        longitude = loc.longitude;
      });
    });

    AMapLocationClient.startLocation();
    //print(result.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('运货追踪'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 50,
              child: Flexible(
                flex: 1,
                child: AmapView(
                  mapType: MapType.Standard,
                  showScaleControl: true,
                  zoomLevel: 15,
                  maskDelay: Duration(milliseconds: 500),
                  markers: [
                    MarkerOption(
                        latLng: LatLng(
                            widget.waybill?.destinationLat ?? 24.toDouble(),
                            widget.waybill?.destinationLon ?? 34.toDouble()),
                        title: 'test',
                        widget: Container(
                          height: 30,
                          width: 60,
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
                        ))
                  ],
                  onMapCreated: (controller) async {
                    await controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Follow,
                        interval: Duration(seconds: 10)));
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.5,
                  left: 10.0,
                  right: 10.0),
              height: SizeConfig.heightMultiplier * 6.58,
              child: Text(
                '送货信息',
                style: TextStyle(
                    fontSize: SizeConfig.heightMultiplier * 2.19,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.widthMultiplier * 2),
              width: SizeConfig.widthMultiplier * 97.32,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.grey,
                color: Colors.grey[300],
                elevation: 7.0,
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.widthMultiplier * 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '送货单号：${widget.waybill?.ID ?? '2587456'}',
                            style: TextStyle(
                              fontSize: SizeConfig.heightMultiplier * 2.19,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '送货地址：${widget.waybill?.destinationName ?? '无收货地名'}',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.19,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '收货人：${widget.waybill?.receiver ?? '无收货人名字'}',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.19,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '收货人电话： ${widget.waybill?.receiverPhone ?? '无收货人电话'}',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.19,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
