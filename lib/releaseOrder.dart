import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mydemo/constant.dart';
import 'sizeConfig.dart';

class ReleaseOrder extends StatefulWidget {
  @override
  _ReleaseOrderState createState() => _ReleaseOrderState();
}

class _ReleaseOrderState extends State<ReleaseOrder> {
  //发布订单没有车牌号码，司机接单后才添加车牌号码
  List list = [
    '送货单编号', //waybill_ ID                                GCZC00014245
    '销售单号', //XK_ NO                                       XK0007467019
    '客户名称', //company_ ID                                  深圳碧胜发展有限公司
    '项目部名称', //projectName                                海南金海晟投资有限公司(二部三期)
    '施工单位', //constructionCompanyName                      辽宁德昌建设工程有限公司
    '项目地址', //projectAddress                               海口新埠岛滨海国际项目2101地块
    '业务员名称', //supplierContactPerson                      高展鹏
    '业务员电话', //supplierContactPhone                       13590665414
    '收货人姓名', //constructionSiteContactPerson              黄海德
    '收货人电话', //constructionSiteContactPhone               15595652151
    '运输方式', //ModeOfTransport                              汽运
    '物料号', //materialsNumber                                MG150-600-0
    '客户编码', //client_ID                                    HMG60913M
    '开单|色号', //billingColor                                GB015V
    '规格', // size                                            150* 600
    '跟单通知发货|发货数量', //amount                           800
    '跟单通知发货|开单单位', //BillingUnit                      块
    '跟单通知发货|数量(块)', //subtotal                         800
    '跟单通知发货|M2', //M2
    '装车备注', //loadingRemarks
    '明细备注' //detailedRemarks
  ];
  Map<String, dynamic> map = {};
  final _releaseFormKey = GlobalKey<FormState>();
  List valueList = List();
  List splited = List();

  @override
  Widget build(BuildContext context) {
    var _controllers = <TextEditingController>[];
    for (var i = 0; i < 21; i++) {
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
                  for (var i = 0; i < min(splited.length, 21); i++) {
                    _controllers[i].text = splited[i];
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
