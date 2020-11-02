import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mydemo/search_result_entity.dart';
import 'finishPage.dart';
import 'mapPage.dart';
import 'server.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'package:r_logger/r_logger.dart';

class resultView extends StatefulWidget {
  String query;

  resultView(this.query);

  @override
  _resultViewState createState() => _resultViewState();
}

class _resultViewState extends State<resultView> {
  var response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('resultView--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('resultView--didChangeDependencies');
  }

  @override
  void didUpdateWidget(resultView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('resultView--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('resultView--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('resultView--dispose');
  }

  getDataFuture() async {
    print('传入单号:${widget.query}');
    response = await Server().searchWaybill(widget.query);
    print('单号结果:${response}');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    print('resultView--build');
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
              return ResultBuilder(snapshot.data, widget.query);
            }
            break;
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.indigo[colorNum]),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    Text('正在加载..')
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
      future: getDataFuture(),
    );
  }
}

class ResultBuilder extends StatefulWidget {
  final data;
  String query;

  ResultBuilder(this.data, this.query);

  @override
  _ResultBuilderState createState() => _ResultBuilderState();
}

class _ResultBuilderState extends State<ResultBuilder> {
  var fontSize = ScreenUtil().setSp(35, allowFontScalingSelf: true);
  var sizedBoxHeight = ScreenUtil().setHeight(15);
  List titleList = ['序号', '色号', '规格', '数量', '发货数量', '开单单位', '明细备注'];

  @override
  Widget build(BuildContext context) {
    print('数据${widget.data}');
    //RLogger.instance.d(widget.data.toString());
    var result = SearchResultEntity().fromJson(widget.data);
    return ListView.builder(
      itemBuilder: (context, index) {
        //print('类型：${widget.data[index].runtimeType}');
        return InkWell(
          onTap: () {
            print(index);
            //根据运输状态进行跳转
            switch (result.result[index].state) {
              case 'inProgress':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                            orderNumber: result.result[index].waybillID)));
                break;
              case 'Finished':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinishPage(
                            orderNumber: result.result[index].waybillID)));
                break;
            }
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(20),
                bottom: ScreenUtil().setHeight(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textStyle('运输单号：', fontSize),
                      Expanded(
                        child: textStyle(
                            '${result.result[index].waybillID ?? '无运输单号'}',
                            fontSize),
                      )
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textStyle('项目名称：', fontSize),
                      Expanded(
                          child: textStyle(
                              '${result.result[index].projectName ?? '无项目名'}',
                              fontSize))
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textStyle('施工单位：', fontSize),
                      Expanded(
                          child: textStyle(
                              '${result.result[index].constructionCompanyName ?? '无施工单位'}',
                              fontSize))
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textStyle(
                            '${result.result[index].startLocationName ?? '出发地'}',
                            fontSize * 2,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center),
                        flex: 2,
                      ),
                      Expanded(
                        child: goodStatus(
                            result.result[index].state,
                            result.result[index].driverName == null
                                ? ''
                                : result.result[index].driverName.username),
                        flex: 1,
                      ),
                      Expanded(
                        child: textStyle(
                            '${result.result[index].destinationName ?? '目的地'}',
                            fontSize * 2,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center),
                        flex: 2,
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '司机：${result.result[index].driverName == null ? '无司机' : result.result[index].driverName.username}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(35, allowFontScalingSelf: true)),
                      )),
                      Expanded(
                          child: Text(
                        '业务员：${result.result[index].supplierContactPerson ?? '无业务员'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(35, allowFontScalingSelf: true)),
                      )),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textStyle('货物明细：', fontSize),
                    ],
                  ),
                  GoodsDetail(
                    index: index,
                    titleList: titleList,
                    totalList: result.result[index],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textStyle('发货日期', fontSize),
                      textStyle('预计到达', fontSize),
                    ],
                  ),
                  Divider(
                    height: ScreenUtil().setHeight(13),
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textStyle(
                        '${date(result.result[index].departureDate ?? '无出发日期')}',
                        fontSize,
                        color: Colors.red,
                      ),
                      Container(
                        color: Colors.grey,
                        width: 1,
                        height: ScreenUtil().setHeight(45),
                      ),
                      textStyle(
                          '${date(result.result[index].arrivalTime ?? '无到货日期')}',
                          fontSize,
                          color: Colors.green,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: result.result.length,
    );
  }

  //判断运输状态
  Widget goodStatus(String status, String driverName) {
    String text;
    Color color;
    if (driverName == '') {
      text = '待分配';
      color = Colors.lime;
    } else {
      if (status == 'inProgress') {
        text = '运输中';
        color = Colors.red;
      } else if (status == 'Finished') {
        text = '已完成';
        color = Colors.green;
      } else {
        text = '待运输';
        color = Colors.blue;
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textStyle(text, fontSize, color: color),
        Image.asset('images/arrow.png',
            width: ScreenUtil().setWidth(108),
            height: ScreenUtil().setHeight(90),
            fit: BoxFit.cover,
            color: color),
      ],
    );
  }

  //样式
  Text textStyle(String data, double size,
      {FontWeight fontWeight, Color color, TextAlign textAlign}) {
    return Text(
      data,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

//todo 写控件传值
class GoodsDetail extends StatefulWidget {
  int index;
  SearchResultResult totalList;
  List titleList;

  GoodsDetail({this.index, this.totalList, this.titleList});

  @override
  _GoodsDetailState createState() => _GoodsDetailState();
}

List<DataColumn> dataColumn(List titleList) {
  List<DataColumn> columnList = List();
  //print('标题长度---${titleList.length}');
  for (int i = 0; i < titleList.length; i++) {
    //print('标题--${titleList[i]}');
    columnList.add(DataColumn(
        label: Row(
      children: [
        Text(
          titleList[i],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    )));
  }
  return columnList;
}

List<DataRow> dataRow(List contentList) {
  List<DataRow> rowList = List();
  for (var value in contentList) {
    List<DataCell> cellList = List();
    for (int i = 0; i < value.length; i++) {
      cellList.add(DataCell(Text(value[i].toString())));
    }
    rowList.add(DataRow(cells: cellList));
  }

  return rowList;
}

class _GoodsDetailState extends State<GoodsDetail> {
  @override
  Widget build(BuildContext context) {
    List allList = List();
    //RLogger.instance.d('传入的数据${widget.totalList}');
    //print('几条记录${widget.totalList.xkNo.length}---index---${widget.index + 1}');
    for (int i = 0; i < widget.totalList.xkNo.length; i++) {
      List cutList = List();
      cutList.add(i + 1);
      cutList.add(widget.totalList.billingColor[i].contains('(') == true
          ? widget.totalList.billingColor[i]
              .substring(0, widget.totalList.billingColor[i].indexOf('('))
          : '');
      cutList.add(widget.totalList.size[i]);
      cutList.add(widget.totalList.quantity[i]);
      cutList.add(widget.totalList.sendQuantity[i]);
      cutList.add(widget.totalList.billingUnit[i]);
      //cutList.add(widget.totalList.unitPrice[i]);
      cutList.add(widget.totalList.detailedRemarks[i]);
      allList.add(cutList);
    }
    //print('裁剪--${allList}');

    //RLogger.instance.d(widget.totalList.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          dataRowHeight: ScreenUtil().setHeight(45),
          headingRowHeight: ScreenUtil().setHeight(60),
          columns: dataColumn(widget.titleList),
          rows: dataRow(allList)),
    );
  }
}
