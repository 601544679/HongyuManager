//import 'package:amap_location/amap_location.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _loadWaybill() async {
    print('_loadWaybill');
    var result = await Server().getWaybillAdmin(widget.orderNumber);
    //print('订单信息: ${result['result']}');
    //print('ID:${result['result']['ID']}');
    return (result['result']);
  }

  @override
  Widget build(BuildContext context) {
    print('传入的订单号${widget.orderNumber}');

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
  }

  @override
  void dispose() {
    //停止监听定位、销毁定位
    /* AMapLocationClient.stopLocation();
    AMapLocationClient.shutdown();*/
    AmapLocation.instance.stopLocation();
    AmapLocation.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('经纬度: ${widget.waybill['latitude'].length}');
    print("目的地：${widget.waybill['destination']['latitude']}");
    print("目的地：${widget.waybill['destination']['longitude']}");
    List titleList = ['送货单号：', '送货地址：', '收货人：', '收货人电话：'];
    List contentList = [
      widget.waybill['ID'],
      widget.waybill['address'],
      widget.waybill['receiver'],
      widget.waybill['receiverPhone']
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
                showScaleControl: true,
                showCompass: true,
                showZoomControl: true,
                zoomLevel: 15,
                maskDelay: Duration(milliseconds: 500),
                centerCoordinate: LatLng(widget.waybill['latitude'][0],
                    widget.waybill['longitude'][0]),
                markers: makeOptions(),
                onMapCreated: (controller) async {
                  await controller?.showMyLocation(MyLocationOption(
                      myLocationType: MyLocationType.Follow,
                      interval: Duration(seconds: 10)));
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

  List<MarkerOption> makeOptions() {
    List<MarkerOption> marks = [];
    for (int i = 0; i < widget.waybill['latitude'].length; i++) {
      //print('获取:${widget.waybill['latitude'][i].toDouble()}');
      //print('长度:${widget.waybill['latitude'].length}');
      marks.add(MarkerOption(
          latLng: LatLng(widget.waybill['latitude'][i].toDouble(),
              widget.waybill['longitude'][i].toDouble()),
          title: widget.waybill['positionName'][i],
          widget: showOptions(i)));
    }
    marks.add(MarkerOption(
        latLng: LatLng(
            widget.waybill['destination']['latitude'].toDouble() ?? 23.03509484,
            widget.waybill['destination']['longitude'].toDouble() ??
                113.13402564),
        title: widget.waybill['projectAddress'] ?? '',
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
    if (i == 0) {
      height = ScreenUtil().setWidth(65);
      width = ScreenUtil().setWidth(195);
    } else if (i == widget.waybill['latitude'].length - 1) {
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
      text = '当前位置';
    } else if (i == widget.waybill['latitude'].length - 1) {
      String startTime = widget.waybill['createdAt'][i];
      text =
          '开始运输\n${startTime.substring(0, 10)}\n${startTime.substring(11, 19)}';
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
