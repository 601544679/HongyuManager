import 'package:amap_location/amap_location.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'server.dart';

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
                  height: SizeConfig.heightMultiplier * 2,
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
    AMapLocationClient.stopLocation();
    AMapLocationClient.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('经纬度: ${widget.waybill['latitude'].length}');
    print("目的地：${widget.waybill['destination']['latitude']}");
    print("目的地：${widget.waybill['destination']['longitude']}");
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
              height: SizeConfig.heightMultiplier * 50,
              child: AmapView(
                mapType: MapType.Standard,
                showScaleControl: true,
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
                            '送货单号：${widget.waybill['ID']}',
                            style: TextStyle(
                              fontSize: SizeConfig.heightMultiplier * 2.19,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '送货地址：',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.19,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.waybill['address']}',
                              style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2.19,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '收货人：    ${widget.waybill['receiver']}',
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.19,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '收货人电话： ${widget.waybill['receiverPhone']}',
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

  List<MarkerOption> makeOptions() {
    List<MarkerOption> marks = [];
    for (int i = 0; i < widget.waybill['latitude'].length; i++) {
      //print('获取:${widget.waybill['latitude'][i].toDouble()}');
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
        title: 'test',
        widget: Container(
          height: SizeConfig.heightMultiplier * 4.5,
          width: SizeConfig.widthMultiplier * 15,
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
    if (i == 0) {
      return Container(
        height: SizeConfig.widthMultiplier * 6,
        width: SizeConfig.widthMultiplier * 18,
        child: Material(
          borderRadius: BorderRadius.circular(30),
          shadowColor: Colors.transparent,
          color: Colors.indigo[colorNum],
          elevation: 7.0,
          child: Center(
            child: lastOptions(i),
          ),
        ),
      );
    } else if (i == widget.waybill['latitude'].length - 1) {
      return Container(
        height: SizeConfig.widthMultiplier * 10,
        width: SizeConfig.widthMultiplier * 40,
        child: Material(
          borderRadius: BorderRadius.circular(30),
          shadowColor: Colors.transparent,
          color: Colors.indigo[colorNum],
          elevation: 7.0,
          child: Center(
            child: lastOptions(i),
          ),
        ),
      );
    } else {
      return Container(
        height: SizeConfig.widthMultiplier * 3,
        width: SizeConfig.widthMultiplier * 3,
        child: Material(
          borderRadius: BorderRadius.circular(30),
          shadowColor: Colors.transparent,
          color: Colors.indigo[colorNum],
          elevation: 7.0,
          child: Center(
            child: lastOptions(i),
          ),
        ),
      );
    }
  }

  Text lastOptions(int i) {
    if (i == 0) {
      return Text('当前位置',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'));
    } else if (i == widget.waybill['latitude'].length - 1) {
      String startTime = widget.waybill['createdAt'][i];
      return Text('开始运输${startTime.substring(0, 10)}',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'));
    } else {
      return Text(
        '',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'),
      );
    }
  }
}
