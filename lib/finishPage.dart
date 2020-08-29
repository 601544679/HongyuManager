import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'server.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter/services.dart';

class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
  String number;

  FinishPage({this.number});
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
              return ImageBuilder();
            }
            break;
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.indigo[colorNum]),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Text('正在加载...')
              ],
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
    var a = await Server().getFinishImage(widget.number);
    return 1;
  }
}

class ImageBuilder extends StatefulWidget {
  @override
  _ImageBuilderState createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  List image = [
    'https://i0.hdslb.com/bfs/archive/8960f855cdc2c0576d89626f2da080e2f2cf876b.jpg',
    'https://i0.hdslb.com/bfs/archive/563c74bf0dec75460eeffdda71fc3791913fcc5e.png@320w_184h_1c_100q.png',
    'https://i0.hdslb.com/bfs/live/69b3af257667506850bdc44621b176dd1055598d.jpg@320w_330h_1c_100q.webp'
  ];
  List s = ['工地现场图', '运货单号', '顺丰单号'];
  var fontSize = SizeConfig.heightMultiplier * 2;
  var fontSize1 = SizeConfig.heightMultiplier * 2.5;
  var flex1 = 1;
  var flex2 = 2;
  var textAlign = TextAlign.right;
  var containerWidth = SizeConfig.widthMultiplier * 94;

  @override
  Widget build(BuildContext context) {
    List list = [
      '送货单编号：',
      '车牌号码：',
      '项目名称：',
      '项目公司名称：',
      '施工单位名称：',
      '施工单位收货人：',
      '施工单位联系方式：',
      '送货地址：',
      '供应商业务员：',
      '供应商联系方式：'
    ];
    List dd = [
      'GCZC00017227',
      '粤ABF949',
      '云南昆明保利山水云亭二期项目1标',
      '云南保晟房地产开发有限公司',
      '广州市东滕装饰工程有限公司(一标)',
      '祝杨林',
      '18307391395',
      '昆明市呈贡区黄陂土片区保利山水云亭',
      '曾永裕',
      '13922777784'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('订单完成情况'),
      ),
      body: Padding(
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
                            textStyle(list[index], fontSize),
                          ],
                        ),
                        Container(
                            width: containerWidth,
                            child: textStyle(dd[index], fontSize1,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                      ],
                    );
                  },
                  itemCount: list.length,
                ),
                Divider(color: Colors.grey),
                Container(
                    child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      //color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s[index],
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 3),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier,
                          ),
                          InkWell(
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.network(
                                image[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: '$index',
                                  toastLength: Toast.LENGTH_SHORT);
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return dialogImageBuilder(image, index);
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
                  itemCount: image.length,
                ))
              ],
            ),
          )),
    );
  }

  Text textStyle(String data, double fontSize, {FontWeight fontWeight}) {
    return Text(
      '$data',
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.normal, fontSize: fontSize),
    );
  }
}

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
