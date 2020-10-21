import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constant.dart';
import 'server.dart';
import 'sizeConfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class uploadDialog extends StatefulWidget {
  final List map;
  bool isOrder;

  uploadDialog(this.map, this.isOrder);

  @override
  _uploadDialogState createState() => _uploadDialogState();
}

class _uploadDialogState extends State<uploadDialog> {
  var lating;
  int success = 0;
  int failed = 0;
  int number = 0;
  String text = '开始上传';

//判断是司机表还是送货单表
  _uploadData() async {
    //todo
    if (widget.isOrder == true) {
      //送货单
      for (var value in widget.map) {
        setState(() {
          number++;
        });
        Map<String, dynamic> map = {};
        map = Map.fromIterables(jsonTitle, value);
        if (map['projectAddress'] != '-') {
          lating = await changeLat(map['projectAddress']);
          print('值1 ${lating.latitude},${lating.longitude}');
          Map<String, dynamic> map2 = {};
          map2 = {"__type": "GeoPoint"};
          map2.addAll({'latitude': lating.latitude});
          map2.addAll({'longitude': lating.longitude});
          map.addAll({'destination': map2});
          map.addAll({"destinationName": place(map['projectAddress'])});
        }
        //todo 上传送货单
        var responseBody;
        responseBody = await Server().releaseByExcel(map);
        print('结果--${responseBody.toString()}');
        if (responseBody.runtimeType == int) {
          setState(() {
            failed++;
          });
          print('failed==${failed}');
          continue;
        } else if (responseBody.runtimeType != int) {
          if (responseBody['result'].toString().contains('success')) {
            setState(() {
              success++;
            });
          } else {
            setState(() {
              failed++;
            });
          }
          print('success==${success}');
          continue;
        }
        //RLogger.instance.d(map.toString());

      }
    } else if (widget.isOrder == false) {
      //司机信息
      for (int i = 0; i < widget.map.length; i++) {
        setState(() {
          number++;
        });
        Map<String, dynamic> map = {};
        map = Map.fromIterables(driverMessage, widget.map[i]);
        print('司机map=${map}');
        var responseBody;
        responseBody = await Server().updateDriverMessage(map);
        print('结果--${responseBody.toString()}');
        if (responseBody.runtimeType == int) {
          setState(() {
            failed++;
          });
          print('failed==${failed}');
          continue;
        } else if (responseBody.runtimeType != int) {
          if (responseBody['result'].toString().contains('success')) {
            setState(() {
              success++;
            });
          } else {
            setState(() {
              failed++;
            });
          }
          print('success==${success}');
          continue;
        }
      }
    }
  }

  String _changeText() {
    if (number == widget.map.length) {
      return '上传完成';
    }
    return '开始上传';
  }

  bool _finish(int number) {
    if (number == widget.map.length) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _uploadData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: ScreenUtil().setHeight(562),
        width: ScreenUtil().setWidth(810),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.white),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(33),
              top: ScreenUtil().setHeight(23),
              right: ScreenUtil().setWidth(33),
              bottom: ScreenUtil().setHeight(23),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _changeText(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(50), color: Colors.black54),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(45),
                ),
                LinearProgressIndicator(
                  value: number / widget.map.length,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(23),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        '${number.toString()}/${widget.map.length}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(
                        '${((number / widget.map.length) * 100).toStringAsFixed(2)}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(23),
                ),
                Divider(
                  color: Colors.lightBlue,
                  height: 1,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(23),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('成功：$success    失败：$failed')],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(23),
                ),
                Container(
                  height: ScreenUtil().setHeight(90),
                  child: MaterialButton(
                    textColor: Colors.lightBlue,
                    disabledTextColor: Colors.grey,
                    disabledColor: Colors.white,
                    onPressed: _finish(number) == true
                        ? () {
                            Navigator.pop(context);
                          }
                        : null,
                    //null就是disable不能点击
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
