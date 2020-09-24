
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mydemo/finish_data_entity.dart';
import 'sizeConfig.dart';
import 'server.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';
import 'package:r_logger/r_logger.dart';
import 'constant.dart';

//查看已完成订单的详细信息
class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
  String orderNumber;

  FinishPage({this.orderNumber});
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print('done');
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              print('hasData');
              // 请求成功，显示数据
              return ImageBuilder(
                snapshot.data,
                number: widget.orderNumber,
              );
            }
            break;
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.indigo[colorNum]),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    Text('正在加载...')
                  ],
                ),
              ),
            );
            break;
          case ConnectionState.active:
            print('active');
            break;
        }
      },
      future: imageFuture(),
    );
  }

  imageFuture() async {
    var finishData = await Server().getFinishImage(widget.orderNumber);
    return finishData;
  }
}

class ImageBuilder extends StatefulWidget {
  final data;
  final number;

  ImageBuilder(this.data, {this.number});

  @override
  _ImageBuilderState createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder>
    with SingleTickerProviderStateMixin {
  List cutList = List();
  List indexList = List();

  @override
  Widget build(BuildContext context) {
    var allData = FinishDataEntity().fromJson(widget.data);
    print('data是: ${widget.data}');

    List contentList = [
      date(allData.result.allMessage.departureDate) ?? '无日期',
      allData.result.allMessage.logisticsOrderNo ?? '无物流单号',
      allData.result.allMessage.waybillId,
      allData.result.allMessage.companyId ?? '无名义客户',
      allData.result.allMessage.projectName ?? '无项目部名称',
      allData.result.allMessage.constructionCompanyName ?? '无施工单位',
      allData.result.allMessage.projectAddress ?? '无项目地址',
      allData.result.allMessage.supplierContactPerson ?? '无业务员',
      allData.result.allMessage.supplierContactPhone ?? '无业务员电话',
      allData.result.allMessage.constructionSiteContactPerson ?? '无收货人',
      allData.result.allMessage.constructionSiteContactPhone ?? '无收货人电话',
      allData.result.allMessage.modeOfTransport ?? '无运输方式',
      allData.result.allMessage.carNo ?? '无车牌号码',
      allData.result.allMessage.containerNo ?? '无装车柜号',
    ];
    for (int i = 0; i < allData.result.allMessage.xkNo.length; i++) {
      List detailList = List();
      detailList.add(i + 1);
      detailList.add(allData.result.allMessage.xkNo[i]);
      detailList.add(allData.result.allMessage.materialsNumber[i]);
      detailList.add(allData.result.allMessage.clientId[i]);
      detailList.add(allData.result.allMessage.size[i]);
      detailList.add(allData.result.allMessage.billingColor[i]);
      detailList.add(allData.result.allMessage.billingUnit[i]);
      detailList.add(allData.result.allMessage.sendQuantity[i]);
      detailList.add(allData.result.allMessage.quantity[i]);
      detailList.add(allData.result.allMessage.m2[i]);
      detailList.add(allData.result.allMessage.unitPrice[i]);
      detailList.add(allData.result.allMessage.palletsNumber[i]);
      detailList.add(allData.result.allMessage.shippingWeight[i]);
      detailList.add(allData.result.allMessage.detailedRemarks[i]);
      detailList.add(allData.result.allMessage.loadingRemarks[i]);
      cutList.add(detailList);
    }
    //print('整理--${cutList}');

    TabController controller = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text('订单完成情况'),
            bottom: TabBar(
                indicatorWeight: 4.0,
                labelPadding:
                    EdgeInsets.only(bottom: SizeConfig.heightMultiplier),
                indicatorColor: Colors.white,
                controller: controller,
                tabs: [
                  Text(
                    '送货单信息',
                    style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
                  ),
                  Text(
                    '签收照片',
                    style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
                  ),
                  Text(
                    '途径点',
                    style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
                  ),
                ]),
          ),
          preferredSize: Size.fromHeight(SizeConfig.heightMultiplier * 11)),
      body: TabBarView(controller: controller, children: [
        waybillDetailTab(titleList, contentList, arrayTitleList, cutList),
        signForPicture(allData),
        finishMapPage(widget.number)
      ]),
    );
  }
}

//Text样式
Text textStyle(String data, double fontSize, {FontWeight fontWeight}) {
  return Text(
    '$data',
    style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal, fontSize: fontSize),
  );
}

//点击查看大图
class dialogImageBuilder extends StatefulWidget {
  List imageList = List();
  int index;

  dialogImageBuilder(this.imageList, this.index);

  @override
  _dialogImageBuilderState createState() => _dialogImageBuilderState();
}

class _dialogImageBuilderState extends State<dialogImageBuilder> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: DragScaleContainer(
          doubleTapStillScale: true,
          child: Image.network(
            widget.imageList[widget.index],
            //scale: scale,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

//销售单水平展示
class contentHorizontal extends StatefulWidget {
  List arrayTitleList;
  List cutList;

  contentHorizontal(this.arrayTitleList, this.cutList);

  @override
  _contentHorizontalState createState() => _contentHorizontalState();
}

List<DataColumn> dataColumn(List contentList) {
  List<DataColumn> columnList = List();
  print('标题长度---${contentList.length}');
  for (int i = 0; i < contentList.length; i++) {
    columnList.add(DataColumn(
        label: Row(
      children: [
        Text(
          contentList[i],
          style: TextStyle(
              fontSize: SizeConfig.heightMultiplier * 2,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    )));
  }
  print('标题${columnList.length}');
  print(columnList);
  return columnList;
}

List<DataRow> dataRow(List arrayContentList) {
  List<DataRow> rowList = List();
  for (var value in arrayContentList) {
    List<DataCell> cellList = List();
    for (int i = 0; i < value.length; i++) {
      cellList.add(DataCell(Text(
        value[i].toString(),
        style: TextStyle(color: Colors.black),
      )));
    }
    rowList.add(DataRow(cells: cellList));
    print('内容长度${cellList.length}');
    print(cellList);
  }

  return rowList;
}

class _contentHorizontalState extends State<contentHorizontal> {
  @override
  Widget build(BuildContext context) {
    //print('标题长度--${widget.arrayTitleList.length}');
    //print('内容长度--${widget.cutList.length}');
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: dataColumn(widget.arrayTitleList),
            rows: dataRow(widget.cutList)));
  }
}

//送货单详细信息Tab
class waybillDetailTab extends StatefulWidget {
  final titleList;
  final contentList;
  final arrayTitleList;
  final cutList;

  waybillDetailTab(
      this.titleList, this.contentList, this.arrayTitleList, this.cutList);

  @override
  _waybillDetailTabState createState() => _waybillDetailTabState();
}

class _waybillDetailTabState extends State<waybillDetailTab>
    with AutomaticKeepAliveClientMixin {
  @override
  var fontSize = SizeConfig.heightMultiplier * 2;
  var fontSize1 = SizeConfig.heightMultiplier * 2.5;
  var flex1 = 1;
  var flex2 = 2;
  var textAlign = TextAlign.right;
  var containerWidth = SizeConfig.widthMultiplier * 94;

  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3,
            top: SizeConfig.heightMultiplier,
            right: SizeConfig.widthMultiplier * 3,
            bottom: SizeConfig.heightMultiplier),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textStyle(widget.titleList[index], fontSize),
                        ],
                      ),
                      Container(
                          width: containerWidth,
                          child: textStyle(widget.contentList[index], fontSize1,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                    ],
                  );
                },
                itemCount: widget.titleList.length,
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier,
              ),
              textStyle('货物明细', fontSize),
              Divider(
                color: Colors.black,
                height: SizeConfig.heightMultiplier,
              ),
              contentHorizontal(widget.arrayTitleList, widget.cutList),
              Divider(color: Colors.black),
            ],
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//签收图Tab
class signForPicture extends StatefulWidget {
  final allData;

  signForPicture(this.allData);

  @override
  _signForPictureState createState() => _signForPictureState();
}

class _signForPictureState extends State<signForPicture>
    with AutomaticKeepAliveClientMixin {
  List s = ['工地现场图', '运货单号', '顺丰单号'];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          //color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s[index],
                style: TextStyle(fontSize: SizeConfig.heightMultiplier * 3),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier,
              ),
              InkWell(
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    widget.allData.result.imageUrl[index],
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {
                  Fluttertoast.showToast(
                      msg: '${s[index]}', toastLength: Toast.LENGTH_SHORT);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return dialogImageBuilder(
                            widget.allData.result.imageUrl, index);
                      });
                },
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier,
              )
            ],
          ),
        );
      },
      itemCount: widget.allData.result.imageUrl.length,
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//地图Tab
class finishMapPage extends StatefulWidget {
  final orderNumber;

  finishMapPage(this.orderNumber);

  @override
  _finishMapPageState createState() => _finishMapPageState();
}

class _finishMapPageState extends State<finishMapPage>
    with AutomaticKeepAliveClientMixin {
  _loadWaybill() async {
    var result = await Server().getWaybillAdmin(widget.orderNumber);
    return (result['result']);
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
  final waybill;

  MapScreen({Key key, this.waybill}) : super(key: key);
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('经纬度: ${widget.waybill['latitude'].length}');
    print("目的地：${widget.waybill['destination']['latitude']}");
    print("目的地：${widget.waybill['destination']['longitude']}");
    return Scaffold(
      body: Column(
        children: [
          Expanded(
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
        ],
      ),
    );
  }

  List<MarkerOption> makeOptions() {
    List<MarkerOption> marks = [];
    for (int i = 0; i < widget.waybill['latitude'].length; i++) {
      print('获取:${widget.waybill['latitude'][i].toDouble()}');
      print('长度:${widget.waybill['latitude'].length}');
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
