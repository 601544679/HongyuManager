import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/generated/json/waybill_entity_helper.dart';
import 'package:mydemo/mapPage.dart';
import 'package:mydemo/waybill_entity.dart';
import 'sizeConfig.dart';
import 'package:date_format/date_format.dart';
import 'userclass.dart';
import 'server.dart';
import 'finishPage.dart';
import 'package:r_logger/r_logger.dart';

//根据下拉菜单使用网络请求
class OrderNetWorkWidget extends StatefulWidget {
  final waybill;

//构造方法传入请求成功后的数据
  OrderNetWorkWidget({this.waybill});

  @override
  _OrderNetWorkWidgetState createState() => _OrderNetWorkWidgetState();
}

class _OrderNetWorkWidgetState extends State<OrderNetWorkWidget> {
  var fontSize = SizeConfig.heightMultiplier * 2;
  var sizedBoxHeight = SizeConfig.heightMultiplier;
  List titleList = ['序号', '色号', '规格', '数量', '发货数量', '开单单位', '送货单价', '明细备注'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wbill = WaybillEntity().fromJson(widget.waybill);
    return ListView.builder(
      itemBuilder: (context, index) {
        //print('类型：${wbill.result[index].runtimeType}');
        return InkWell(
          onTap: () {
            print(index);
            //根据运输状态进行跳转
            switch (wbill.result[index].status) {
              case 'inProgress':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                            orderNumber: wbill.result[index].waybillId)));
                break;
              case 'Finished':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinishPage(
                            orderNumber: wbill.result[index].waybillId)));
                break;
            }
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 2,
                  right: SizeConfig.widthMultiplier * 2,
                  top: SizeConfig.heightMultiplier,
                  bottom: SizeConfig.heightMultiplier),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textStyle('运输单号：', fontSize),
                      Expanded(
                        child: textStyle(
                            '${wbill.result[index].waybillId ?? '无运输单号'}',
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
                              '${wbill.result[index].projectName ?? '无项目名'}',
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
                              '${wbill.result[index].constructionCompanyName ?? '无施工单位'}',
                              fontSize))
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textStyle(
                            '${wbill.result[index].startLocationName ?? '出发地'}',
                            fontSize * 2,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center),
                        flex: 2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle(
                                '${wbill.result[index].status == 'Finished' ? '已完成' : '运输中'}',
                                fontSize,
                                color: wbill.result[index].status == 'Finished'
                                    ? Colors.green
                                    : Colors.red),
                            Image.asset('images/arrow.png',
                                width: SizeConfig.widthMultiplier * 10,
                                height: SizeConfig.heightMultiplier * 4,
                                fit: BoxFit.cover,
                                color: wbill.result[index].status == 'Finished'
                                    ? Colors.green
                                    : Colors.red),
                          ],
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: textStyle(
                            '${wbill.result[index].destinationName ?? '目的地'}',
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
                        '司机：${wbill.result[index].driver == null ? '无司机' : wbill.result[index].driver.username}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: SizeConfig.widthMultiplier * 4),
                      )),
                      Expanded(
                          child: Text(
                        '业务员：${wbill.result[index].supplierContactPerson ?? '无业务员'}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: SizeConfig.widthMultiplier * 4),
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
                  Container(
                    child: GoodsDetail(
                      index: index,
                      titleList: titleList,
                      totalList: wbill.result[index],
                    ),
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
                    height: SizeConfig.heightMultiplier,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textStyle(
                        '${date(wbill.result[index].departureDate ?? '无出发日期')}',
                        fontSize,
                        color: Colors.red,
                      ),
                      Container(
                        color: Colors.grey,
                        width: 1,
                        height: SizeConfig.heightMultiplier * 4,
                      ),
                      textStyle(
                          '${date(wbill.result[index].arrivalTime ?? '无到货日期')}',
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
      itemCount: wbill.result.length,
    );
  }

  //日期转换
  String date(int millTime) {
    DateTime a = DateTime.fromMillisecondsSinceEpoch(millTime);
    a.year;
    a.month;
    a.day;
    return (formatDate(
        DateTime(a.year, a.month, a.day), [yyyy, '年', mm, '月', dd, '日']));
  }

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
  WaybillResult totalList;
  List titleList;

  GoodsDetail({this.index, this.totalList, this.titleList});

  @override
  _GoodsDetailState createState() => _GoodsDetailState();
}

List<DataColumn> dataColumn(List titleList) {
  List<DataColumn> columnList = List();
  print('标题长度---${titleList.length}');
  for (int i = 0; i < titleList.length; i++) {
    print('标题--${titleList[i]}');
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
    print('几条记录${widget.totalList.xkNo.length}---index---${widget.index + 1}');
    for (int i = 0; i < widget.totalList.xkNo.length; i++) {
      List cutList = List();
      cutList.add(i + 1);
      cutList.add(widget.totalList.billingColor[i]);
      cutList.add(widget.totalList.size[i]);
      cutList.add(widget.totalList.quantity[i]);
      cutList.add(widget.totalList.sendQuantity[i]);
      cutList.add(widget.totalList.billingUnit[i]);
      cutList.add(widget.totalList.unitPrice[i]);
      cutList.add(widget.totalList.detailedRemarks[i]);
      allList.add(cutList);
    }
    print('裁剪--${allList}');

    //RLogger.instance.d(widget.totalList.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: dataColumn(widget.titleList), rows: dataRow(allList)),
    );
  }
}
