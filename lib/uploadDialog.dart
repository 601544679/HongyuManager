import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constant.dart';
import 'server.dart';
import 'sizeConfig.dart';

class uploadDialog extends StatefulWidget {
  final List map;

  uploadDialog(this.map);

  @override
  _uploadDialogState createState() => _uploadDialogState();
}

class _uploadDialogState extends State<uploadDialog> {
  var lating;
  int success = 0;
  int failed = 0;
  String text = '开始上传';

  _uploadData() async {
    for (var value in widget.map) {
      Map<String, dynamic> map = {};
      map = Map.fromIterables(jsonTitle, value);
      //print('map----${map}');
      //print('地址 ${map['projectAddress']}');
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
      //RLogger.instance.d(map.toString());
      bool result = true;
      var responseBody;
      print('当前请求$map');
      //todo 上传送货单
      if (result) {
        responseBody = await Server().releaseByExcel(map);
        print('结果--$responseBody');
        if (responseBody != null) {
          setState(() {
            result = true;
          });
          print('responseBody$responseBody');
          if (responseBody['result'].toString().contains('success')) {
            setState(() {
              success++;
            });
          } else {
            setState(() {
              failed++;
            });
          }
        }
      }
    }
  }

  String _changeText() {
    if (success == widget.map.length) {
      return '上传完成';
    }
    return '开始上传';
  }

  bool _finish(int success) {
    if (success == widget.map.length) {
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
        height: SizeConfig.heightMultiplier * 20,
        width: SizeConfig.widthMultiplier * 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.white),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3,
                top: SizeConfig.heightMultiplier,
                right: SizeConfig.widthMultiplier * 3,
                bottom: SizeConfig.heightMultiplier),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _changeText(),
                  style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 3,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                LinearProgressIndicator(
                  value: success / widget.map.length,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        '${success.toString()}/${widget.map.length}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(
                        '${((success / widget.map.length) * 100).toStringAsFixed(2)}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Divider(
                  color: Colors.lightBlue,
                  height: 1,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 4,
                  child: MaterialButton(
                    textColor: Colors.lightBlue,
                    disabledTextColor: Colors.grey,
                    disabledColor: Colors.white,
                    onPressed: _finish(success) == true
                        ? () {
                            Navigator.pop(context);
                          }
                        : null,
                    //null就是disable不能点击
                    child: Text(
                      '确定',
                      style:
                          TextStyle(fontSize: SizeConfig.heightMultiplier * 3),
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
