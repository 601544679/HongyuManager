import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.requestCallBack != null) {
      widget.requestCallBack.then((value) {
        Navigator.pop(context, value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: new Center(
          child: new SizedBox(
            width: ScreenUtil().setWidth(524),
            height: ScreenUtil().setWidth(324),
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
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      widget.loadingText,
                      style: new TextStyle(fontSize: 14.0),
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
