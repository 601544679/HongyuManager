import 'package:amap_location/amap_location.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'constant.dart';

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
      var a = await Server().getWaybillAdmin('GCZC00017227');
      //print('订单信息: ${a['result']}');
      //print('ID:${a['result']['ID']}');
      return (a['result']);
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
    print('经纬度: ${widget.waybill['latitude'].length}');
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
              child: Flexible(
                flex: 1,
                child: AmapView(
                  mapType: MapType.Standard,
                  showScaleControl: true,
                  zoomLevel: 15,
                  maskDelay: Duration(milliseconds: 500),
                  centerCoordinate: LatLng(widget.waybill['latitude'][1],
                      widget.waybill['longitude'][1]),
                  markers: makeOptions(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '送货地址：${widget.waybill['address']}',
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
                            '收货人：${widget.waybill['receiver']}',
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
      marks.add(MarkerOption(
          latLng: LatLng(
              widget.waybill['latitude'][i], widget.waybill['longitude'][i]),
          widget: Container(
            height: i == 0
                ? SizeConfig.heightMultiplier * 4.5
                : SizeConfig.widthMultiplier * 5,
            width: i == 0
                ? SizeConfig.widthMultiplier * 15
                : SizeConfig.widthMultiplier * 5,
            child: Material(
              borderRadius: BorderRadius.circular(30),
              shadowColor: Colors.transparent,
              color: Colors.indigo[colorNum],
              elevation: 7.0,
              child: InkWell(
                child: Center(
                  child: Text(
                    i == 0 ? '当前位置' : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          )));
    }
    marks.add(MarkerOption(
        latLng: LatLng(
            //widget.waybill.destinationLat.toDouble(), widget.waybill.destinationLon.toDouble()
            23.03509484,
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
}
