import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant.dart';

class loginDialog extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;

  //重点
  Future<dynamic> requestCallBack;
  Function dismissDialog;

  loginDialog(
      {this.loadingText = '正在登录...',
      this.outsideDismiss = true,
      this.dismissDialog,
      this.requestCallBack});

  @override
  _loginDialogState createState() => _loginDialogState();
}

class _loginDialogState extends State<loginDialog> {
  var result;
  var error;

  _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getResult();
    widget.requestCallBack.then((value) {
      print('啥玩意${value.runtimeType}');
      Navigator.pop(context, value);
    }).catchError((onError) {
      print('啥玩意1--${onError}');
      Navigator.pop(context, onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: new Center(
          child: new SizedBox(
            width: setWidth(350),
            height: setWidth(250),
            child: new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: EdgeInsets.only(
                      top: setHeight(30),
                    ),
                    child: new Text(
                      widget.loadingText,
                      style: new TextStyle(
                          fontSize: ScreenUtil()
                              .setSp(30, allowFontScalingSelf: true)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
