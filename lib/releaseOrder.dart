import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mydemo/constant.dart';
import 'sizeConfig.dart';

//发布订单
class ReleaseOrder extends StatefulWidget {
  @override
  _ReleaseOrderState createState() => _ReleaseOrderState();
}

class _ReleaseOrderState extends State<ReleaseOrder> {
  //发布订单没有车牌号码，司机接单后才添加车牌号码
  List list = [
    '送货日期', //departureDate                                2020-09-02
    '物流单号', //                                              GCWL00018834
    '送货单编号', //waybill_ ID                                GCZC00021371
    '销售单号', //XK_ NO                                       XK0007549849
    '名义客户', //company_ ID                                  佛山万科置业有限公司(佛山万科星都荟项目)
    '项目部名称', //projectName                                佛山万科置业有限公司
    '施工单位', //constructionCompanyName                      广州市景晖园林景观工程有限公司
    '项目地址', //projectAddress                               广东省佛山市顺德区龙洲路北（骏马修车厂附近）
    '业务员名称', //supplierContactPerson                      李啟然
    '业务员电话', //supplierContactPhone                       13827798161
    '收货人姓名', //constructionSiteContactPerson              王永淦
    '收货人电话', //constructionSiteContactPhone               13725285112
    '运输方式', //ModeOfTransport                              汽运
    '车牌号码', //carNo
    '装车柜号',
    '物料号', //materialsNumber                                FT200-318-0
    '客户编码', //client_ID                                    HG60816
    '规格', // size                                            450x600
    '开单|色号', //billingColor                                YA0601(和坚487单-万科佛山星都荟园林景观工程)
    '跟单通知发货|开单单位', //BillingUnit                      块
    '跟单通知发货|发货数量', //amount                           28
    '跟单通知发货|数量(块)', //subtotal                         28
    '跟单通知发货|M2', //M2                                    7.56
    '自定义打印|送货单价(块) ', //                               12.7683
    '托板总数', //
    '物流结算|发货重量（吨）', //                                 0.168
    '明细备注', //detailedRemarks
    '装车备注', //loadingRemarks                               和坚487单,要求带搬运，穿着整齐，长裤，带安全帽，反光衣，
    // 不能抽烟，送货时间早上10点30以后，下午3点半之后！要求今天到货
  ];
  Map<String, dynamic> map = {};
  final _releaseFormKey = GlobalKey<FormState>();
  List valueList = List();
  List splited = List();

  @override
  Widget build(BuildContext context) {
    var _controllers = <TextEditingController>[];
    for (var i = 0; i < 28; i++) {
      var _controller = new TextEditingController();
      _controllers.add(_controller);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('发布订单'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.widthMultiplier * 2,
            SizeConfig.heightMultiplier,
            SizeConfig.widthMultiplier * 2,
            SizeConfig.heightMultiplier),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('订单内容',
                      style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2,
                          fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier,
              ),
              TextField(
                maxLines: null,
                onChanged: (value) {
                  splited = value.split(" ");
                  for (var i = 0; i < 28; i++) {
                    for (var i = 0; i < min(splited.length, 28); i++) {
                      _controllers[i].text = splited[i];
                    }
                  }
                },
                decoration: InputDecoration(
                    hintText: '请粘贴复制的订单内容',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: SizeConfig.widthMultiplier),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(
                height: SizeConfig.widthMultiplier,
              ),
              Form(
                key: _releaseFormKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${list[index]}',
                              style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.widthMultiplier,
                        ),
                        TextFormField(
                          // ignore: missing_return
                          controller: _controllers[index],
                          validator: (value) {
                            print('value${value}');
                            if (value.isEmpty) {
                              return '请输入${list[index]}';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            valueList.add(value);
                            Map<String, dynamic> map1 = {};
                            map1 = {list[index]: value};
                            map.addAll(map1);
                          },
                          decoration: InputDecoration(
                              hintText: '请输入${list[index]}',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: SizeConfig.heightMultiplier,
                                      color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              hintStyle: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 1.5)),
                          maxLines: null,
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        )
                      ],
                    );
                  },
                  itemCount: list.length,
                ),
              ),
              FlatButton(
                color: Colors.indigo[colorNum],
                textColor: Colors.white,
                onPressed: () {
                  //todo 发布订单
                  if (_releaseFormKey.currentState.validate()) {
                    _releaseFormKey.currentState.save();
                    print('TextFiled信息: ${valueList}');
                    print('map信息: ${map}');
                    print('map信息: ${jsonEncode(map)}');
                  }
                },
                child: Text(
                  '发布订单',
                  style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
