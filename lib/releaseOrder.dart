import 'package:flutter/material.dart';
import 'package:mydemo/constant.dart';
import 'sizeConfig.dart';

class ReleaseOrder extends StatefulWidget {
  @override
  _ReleaseOrderState createState() => _ReleaseOrderState();
}

class _ReleaseOrderState extends State<ReleaseOrder> {
  List list = [
    '送货单编号',
    '销售单号',
    '客户名称',
    '项目部名称',
    '施工单位',
    '项目地址',
    '业务员名称',
    '业务员电话',
    '收货人姓名',
    '收货人电话',
    '运输方式',
    '车牌号码',
    '物料号',
    '客户编码',
    '开单|色号',
    '规格',
    '跟单通知发货|发货数量',
    '跟单通知发货|开单单位',
    '跟单通知发货|数量(块)',
    '跟单通知发货|M2',
    '装车备注',
    '明细备注'
  ];

  //
  List<TextEditingController> textEditingController = List();
  final _releaseFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  //todo 粘贴订单内容后，开始自动识别，智能填充
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
                          validator: (value) {
                            print('value${value}');
                            if (value.isEmpty) {
                              return '请输入${list[index]}';
                            }
                            return null;
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
