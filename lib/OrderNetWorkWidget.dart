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
  List titleList1 = [
    'index',
    'billingColor',
    'size',
    'quantity',
    'sendQuantity',
    'billingUnit',
    'unitPrice',
    'detailedRemarks'
  ];
  List detailList = List();
  int currentIndex;
  List smallList = List();
  List indexList = List();
  List list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('类型：${widget.waybill.runtimeType}');
    var wbill = WaybillEntity().fromJson(widget.waybill);
    return ListView.builder(
      itemBuilder: (context, index) {
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
                        builder: (context) =>
                            FinishPage(orderNumber: wbill.result[index].waybillId)));
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
                        '司机：${wbill.result[index].driver==null ? '无司机':wbill.result[index].driver.username}',
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
                    height: wbill.result[index].xkNo.length > 1
                        ? SizeConfig.heightMultiplier *
                            wbill.result[index].xkNo.length *
                            3.3
                        : SizeConfig.heightMultiplier * 8,
                    child: GoodsDetail(
                      index: index,
                      titleList: titleList,
                      totalList: wbill,
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
  WaybillEntity totalList;
  List titleList;

  GoodsDetail({this.index, this.totalList, this.titleList});

  @override
  _GoodsDetailState createState() => _GoodsDetailState();
}

List<Widget> detailWidget(List totalList) {
  List<Widget> list = List();
  for (int i = 0; i < totalList.length; i++) {
    list.add(Container(
        height: SizeConfig.heightMultiplier * 2.5,
        //baseline：baseline数值，必须要有，从顶部算。
        //
        // baselineType：bseline类型，也是必须要有的，目前有两种类型：
        //
        // alphabetic：对齐字符底部的水平线；
        // ideographic：对齐表意字符的水平线。
        child: Baseline(
          baseline: 12,
          baselineType: TextBaseline.alphabetic,
          child: Text(totalList[i].toString()),
        )));
  }
  return list;
}

class _GoodsDetailState extends State<GoodsDetail> {
  List allList = List();
  List indexList = List();

  @override
  Widget build(BuildContext context) {
    //RLogger.instance.d(widget.totalList.toString());
    allList.add(widget.totalList.result[widget.index].billingColor);
    allList.add(widget.totalList.result[widget.index].size);
    allList.add(widget.totalList.result[widget.index].quantity);
    allList.add(widget.totalList.result[widget.index].sendQuantity);
    allList.add(widget.totalList.result[widget.index].billingUnit);
    allList.add(widget.totalList.result[widget.index].unitPrice);
    allList.add(widget.totalList.result[widget.index].detailedRemarks);
    for (int i = 0;
        i < widget.totalList.result[widget.index].xkNo.length;
        i++) {
      indexList.add(i + 1);
    }
    allList.insert(0, indexList);
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(widget.titleList[index]),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier,
            )
            /* Divider(color: Colors.green),
            */
            /* Container(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Text(allList[index]);
                },
                itemCount: allList[index].length,
              ),
            )*/
            ,
            Expanded(
              child: Column(
                children: detailWidget(
                  allList[index],
                ),
              ),
            )
          ],
        );
      },
      itemCount: widget.titleList.length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) {
        return VerticalDivider(
          width: SizeConfig.widthMultiplier,
          color: Colors.black,
        );
      },
    );
  }
}
