import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:mydemo/finish_data_entity.dart';
import 'LogUtils.dart';
import 'server.dart';
import 'userClass.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//查看已完成订单的详细信息
class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
  String orderNumber;
  String role;

  FinishPage({this.orderNumber, this.role});
}

class _FinishPageState extends State<FinishPage> {
  var a = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('FinishPage--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('FinishPage--didChangeDependencies');
  }

  @override
  void didUpdateWidget(FinishPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('FinishPage--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('FinishPage--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('FinishPage--dispose');
  }

  @override
  Widget build(BuildContext context) {
    print('FinishPage--build');
    return FutureBuilder(
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print('done');
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('订单完成情况'),
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
            } else if (snapshot.hasData) {
              print('hasData');
              // 请求成功，显示数据
              return tabBuilder(
                snapshot.data,
                number: widget.orderNumber,
                role: widget.role,
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
                      height: setHeight(14),
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.indigo[colorNum]),
                    ),
                    SizedBox(
                      height: setHeight(30),
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
      future: finishPageFuture(),
    );
  }

  finishPageFuture() async {
    var finishData = await Server().getFinishImage(widget.orderNumber);
    print('finishPage--data${finishData}');
    return finishData;
  }
}

class tabBuilder extends StatefulWidget {
  final data;
  final number;
  final role;

  tabBuilder(this.data, {this.number, this.role});

  @override
  _tabBuilderState createState() => _tabBuilderState();
}

class _tabBuilderState extends State<tabBuilder>
    with SingleTickerProviderStateMixin {
  List cutList = List();
  List indexList = List();
  bool tokenIsUseful = true;
  double fontSize = ScreenUtil().setSp(35, allowFontScalingSelf: true);

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
    print('finishTab--build');
    if (tokenIsUseful == false) {
      return Scaffold(
        body: AlertDialog(
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
        ),
      );
    } else if (tokenIsUseful == true) {
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
        //detailList.add(allData.result.allMessage.xkNo[i]);
        detailList.add(allData.result.allMessage.materialsNumber[i]);
        detailList.add(allData.result.allMessage.clientId[i]);
        detailList.add(allData.result.allMessage.size[i]);
        detailList.add(
            allData.result.allMessage.billingColor[i].contains('(') == true
                ? allData.result.allMessage.billingColor[i].substring(
                    0, allData.result.allMessage.billingColor[i].indexOf('('))
                : '');
        detailList.add(allData.result.allMessage.billingUnit[i]);
        detailList.add(allData.result.allMessage.sendQuantity[i]);
        detailList.add(allData.result.allMessage.quantity[i]);
        detailList.add(allData.result.allMessage.m2[i]);
        //detailList.add(allData.result.allMessage.unitPrice[i]);
        //detailList.add('');
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
              centerTitle: true,
              title: Text('订单完成情况'),
              bottom: TabBar(
                  indicatorWeight: 4.0,
                  labelPadding: EdgeInsets.only(bottom: setHeight(14)),
                  indicatorColor: Colors.white,
                  controller: controller,
                  tabs: [
                    Text(
                      '送货单信息',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      '签收照片',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      '途径点',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ]),
            ),
            preferredSize: Size.fromHeight(setHeight(148))),
        body: TabBarView(controller: controller, children: [
          waybillDetailTab(
              titleList, contentList, arrayTitleList, cutList, widget.role),
          signForPicture(allData),
          finishMapPage(widget.number)
        ]),
      );
    }
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

//是否展示
bool showMessage(String role, int index) {
  print('传入身份=$role');
  if (role == 'logisticsClerk' && index == 2) {
    return false;
  } else if (role == 'logisticsClerk' && index == 5) {
    return false;
  } else if (role == 'merchandiser' && index == 7) {
    return false;
  } else if (role == 'merchandiser' && index == 8) {
    return false;
  } else {
    return true;
  }
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
              fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true),
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
        style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(25, allowFontScalingSelf: true)),
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
            dividerThickness: 1,
            showBottomBorder: true,
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
  final role;

  waybillDetailTab(this.titleList, this.contentList, this.arrayTitleList,
      this.cutList, this.role);

  @override
  _waybillDetailTabState createState() => _waybillDetailTabState();
}

class _waybillDetailTabState extends State<waybillDetailTab>
    with AutomaticKeepAliveClientMixin {
  @override
  var fontSize = ScreenUtil().setSp(35, allowFontScalingSelf: true);
  var fontSize1 = ScreenUtil().setSp(40, allowFontScalingSelf: true);
  var flex1 = 1;
  var flex2 = 2;
  var textAlign = TextAlign.right;
  var containerWidth = setWidth(705);
  User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRole();
    print('waybillDetailTab--initState');
  }

  getRole() async {
    _user = await User().getUser();
    print('身份=${_user.role}');
  }

  Widget build(BuildContext context) {
    print('waybillDetailTab--build');
    return Padding(
        padding: EdgeInsets.only(
            left: setWidth(23),
            top: setHeight(14),
            right: setWidth(23),
            bottom: setHeight(14)),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.white,
              shadowColor: Colors.indigo[colorNum],
              child: Padding(
                padding: EdgeInsets.only(
                    left: setWidth(23),
                    top: setHeight(14),
                    right: setWidth(23),
                    bottom: setHeight(14)),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Visibility(
                            visible: showMessage(widget.role, index),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.indigo[colorNum],
                                        radius: 12,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 8,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        width: setWidth(10),
                                        height: setHeight(130),
                                      )
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          textStyle(
                                              widget.titleList[index] + ':',
                                              fontSize,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                      SizedBox(
                                        height: setHeight(7),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: textStyle(
                                              widget.contentList[index],
                                              fontSize1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  flex: 8,
                                )
                              ],
                            ));
                      },
                      itemCount: widget.titleList.length,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: setHeight(30),
            ),
            textStyle('货物明细', fontSize),
            Divider(
              color: Colors.black,
              height: setHeight(14),
            ),
            contentHorizontal(widget.arrayTitleList, widget.cutList),
          ],
        )));
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
  bool loadingSuccess = true;
  String picUrl = '';
  PageController _pageController;
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
    _pageController.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('signForPicture--build');
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (index) {
            setState(() {
              indexPage = index;
            });
          },
          controller: _pageController,
          allowImplicitScrolling: true,
          itemBuilder: (context, index) {
            return Container(
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Card(
                        child: Image.network(
                      widget.allData.result.imageUrl[index],
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        print('exception=${exception}');
                        print('StackTrace=${stackTrace}');
                        loadingSuccess = false;
                        return Column(
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
                              '网络错误',
                              style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(30, allowFontScalingSelf: true),
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[colorNum],
                              ),
                            )
                          ],
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        print('进度$loadingProgress');
                        //loadingProgress.expectedTotalBytes图片总大小
                        //loadingProgress.cumulativeBytesLoaded目前加载进度
                        if (loadingProgress == null) {
                          //加载图片
                          return child;
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.indigo[colorNum]),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                            SizedBox(
                              height: setHeight(20),
                            ),
                            Text(
                              '正在加载中 ${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes) * 100).toStringAsFixed(2)}%',
                              style: TextStyle(
                                  color: Colors.indigo[colorNum],
                                  fontSize: ScreenUtil()
                                      .setSp(30, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      },
                      fit: BoxFit.fill,
                    )),
                    onTap: () {
                      if (loadingSuccess == true) {
                        print('加载成功=$loadingSuccess');
                        Fluttertoast.showToast(
                            msg: '${s[index]}',
                            toastLength: Toast.LENGTH_SHORT);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return dialogImageBuilder(
                                  widget.allData.result.imageUrl, index);
                            });
                      } else if (loadingSuccess == false) {
                        setState(() {
                          picUrl = '5';
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: setHeight(14),
                  ),
                  Text(
                    s[index],
                    style: TextStyle(fontSize: setHeight(40)),
                  ),
                ],
              ),
            );
          },
          itemCount: widget.allData.result.imageUrl.length,
        ),
        Positioned(
            left: setWidth(322),
            top: setHeight(850),
            child: CircleAvatar(
              backgroundColor:
                  indexPage == 0 ? Colors.indigo[colorNum] : Colors.white,
              radius: 8,
            )),
        Positioned(
            left: setWidth(371),
            top: setHeight(850),
            child: CircleAvatar(
              backgroundColor:
                  indexPage == 1 ? Colors.indigo[colorNum] : Colors.white,
              radius: 8,
            )),
        Positioned(
            left: setWidth(422),
            top: setHeight(850),
            child: CircleAvatar(
              backgroundColor:
                  indexPage == 2 ? Colors.indigo[colorNum] : Colors.white,
              radius: 8,
            ))
      ],
    );
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
  int count;
  List<dynamic> resultList = List();

  //游标，记录上一次查询的位置
  String cursor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('_finishMapPageState');
    getCount();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('finishMapPage--didChangeDependencies');
  }

  @override
  void didUpdateWidget(finishMapPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('finishMapPage--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('finishMapPage--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('finishMapPage--dispose');
  }

  _loadWaybill() async {
    var result = await Server().getWaybillAdmin(widget.orderNumber);
    return (result['result']);
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

  @override
  Widget build(BuildContext context) {
    print('finishMapPage--build');
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
          print('snapshot.data: ${snapshot.data}');
          return MapScreen(
            waybill: snapshot.data,
            latLngList: resultList,
          );
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
  final latLngList;

  MapScreen({Key key, this.waybill, this.latLngList}) : super(key: key);
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
                  widget.waybill['destination']['latitude'],
                  widget.waybill['destination']['longitude']),
              markers: makeOptions(),
              onMapCreated: (controller) async {
                await controller?.showMyLocation(MyLocationOption(
                    myLocationType: MyLocationType.Follow,
                    interval: Duration(seconds: 10)));
                //await controller.showTraffic(true);
                await controller.showCompass(true);
                //await controller.showLocateControl(true);
                await controller.showScaleControl(true);
                await controller.showZoomControl(true);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<MarkerOption> makeOptions() {
    List<MarkerOption> marks = [];
    for (int i = 0; i < widget.latLngList.length; i++) {
      //print('获取:${widget.waybill['latitude'][i].toDouble()}');
      //print('长度:${widget.waybill['latitude'].length}');
      marks.add(MarkerOption(
          latLng: LatLng(
              widget.latLngList[i]['position']['latitude'].toDouble(),
              widget.latLngList[i]['position']['longitude'].toDouble()),
          title: widget.latLngList[i]['positionName'],
          widget: showOptions(i)));
    }
    marks.add(MarkerOption(
        latLng: LatLng(
            widget.waybill['destination']['latitude'].toDouble() ?? 23.03509484,
            widget.waybill['destination']['longitude'].toDouble() ??
                113.13402564),
        title: widget.waybill['projectAddress'] ?? '',
        widget: Container(
          height: setHeight(107),
          width: setWidth(201),
          child: Material(
            borderRadius: BorderRadius.circular(15),
            shadowColor: Colors.transparent,
            color: Colors.amber,
            elevation: 7.0,
            child: InkWell(
              child: Center(
                child: Text(
                  dateChange(widget.waybill['arrivalTime']),
                  style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(30, allowFontScalingSelf: true),
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

//日期转换
  String dateChange(int millTime) {
    print('时间--${widget.waybill['arrivalTime']}');
    DateTime time = DateTime.fromMillisecondsSinceEpoch(millTime);
    time.year;
    time.month;
    time.day;
    return ('目的地\n${time.year}-${time.month}-${time.day}\n${time.hour}:${time.minute}:${time.second}');
  }

  Container showOptions(int i) {
    double height;
    double width;
    if (i == widget.latLngList.length - 1) {
      height = setWidth(45);
      width = setWidth(135);
    } else if (i == 0) {
      height = setWidth(125);
      width = setWidth(201);
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
            fontFamily: 'Montserrat'));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
