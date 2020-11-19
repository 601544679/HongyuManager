import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'constant.dart';
import 'login.dart';
import 'sizeconfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordControl = new TextEditingController();
  bool checkBoxValue = false;
  final int colorNum = 600;
  final double leftIndent = setWidth(27);
  final double rightIndent = setWidth(184);
  final double topIndent = setHeight(34);
  final double containerHeight = setHeight(135);
  final double containerWidth = setWidth(627);
  final double fontSize = ScreenUtil().setSp(40, allowFontScalingSelf: true);
  final double fontSize1 = ScreenUtil().setSp(35, allowFontScalingSelf: true);
  String fontFamily = 'Monsterrat';
  final double sizeBoxWidth = setWidth(81);
  final double sizeBoxW = setWidth(27);
  final _resetFormKey = GlobalKey<FormState>();
  Timer timer;
  int countdown = 60;
  bool buttonDisable = false;
  String text = '获取验证码';
  String _phone;
  String _code;
  String _password;
  String confirmPassword;
  double cardTop = 550;
  double buttonTop = 800;
  double errorShowTime = 0;
  var errorMessage;
  List titleList = ['输入手机号码', '输入验证码', '设置密码', '确认密码'];
  List hintList = ['请输入手机号码', '请输入收到验证码', '6～18位数字或字母组合', '再次输入密码'];
  List tipsList = ['请输入手机号码', '请输入验证码', '请设置密码', '请输入密码'];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topCenter,
      children: [
        Image.asset(
          'images/resetpasswprd.png',
          fit: BoxFit.fill,
          height: setHeight(1334),
          width: setWidth(750),
        ),
        Positioned(
          left: setWidth(50),
          top: setHeight(300),
          height: setHeight(cardTop),
          width: setWidth(650),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: setWidth(20),
                right: setWidth(20),
              ),
              child: Column(
                children: [
                  Form(
                    key: _resetFormKey,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              //padding: EdgeInsets.only(top: topIndent, left: leftIndent,right: rightIndent),
                              width: setWidth(550),
                              child: TextFormField(
                                maxLines: 1,
                                inputFormatters: index == 0
                                    ? [
                                        //只能输入0-9,字母
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]')),
                                      ]
                                    : [
                                        //只能输入0-9,字母
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9,a-z,A-Z]')),
                                      ],
                                decoration: InputDecoration(
                                  suffix: index == 0
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: setWidth(20),
                                              right: setWidth(20)),
                                          child: Container(
                                            width: setWidth(174),
                                            //padding: EdgeInsets.only(right: 5),
                                            child: RaisedButton(
                                              onPressed: buttonDisable == false
                                                  ? () async {
                                                      if (_phone == '' ||
                                                          _phone == null) {
                                                        Fluttertoast.showToast(
                                                            msg: '请输入手机号码');
                                                      } else if (_phone != '' &&
                                                          _phone != null) {
                                                        var response;
                                                        var errorMessage;
                                                        try {
                                                          response = await LCUser
                                                              .requestPasswordRestBySmsCode(
                                                                  _phone);
                                                        } on LCException catch (error) {
                                                          errorMessage = error;
                                                          print(error.code);
                                                          print(error.message);
                                                          if (error.code ==
                                                              213) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    '该手机号未注册,请先注册',
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg: error
                                                                    .message,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT);
                                                          }
                                                        }
                                                        print(
                                                            '发送验证码重置${response}');
                                                        timer = Timer.periodic(
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                            (timer) {
                                                          setState(() {
                                                            buttonDisable =
                                                                true;
                                                            text = countdown
                                                                .toString();
                                                            if (countdown ==
                                                                0) {
                                                              timer.cancel();
                                                              text = '获取验证码';
                                                              buttonDisable =
                                                                  false;
                                                              countdown = 60;
                                                            }
                                                            countdown--;
                                                          });
                                                        });
                                                        print(
                                                            '获取验证码${response}');
                                                        print(_phone);
                                                      }
                                                    }
                                                  : null,
                                              color: Colors.indigo[colorNum],
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              child: Text(text,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(
                                                          21.5,
                                                          allowFontScalingSelf:
                                                              true),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Montserrat')),
                                            ),
                                          ),
                                        )
                                      : null,
                                  errorStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(30,
                                          allowFontScalingSelf: true)),
                                  //horizontal是水平padding
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: setHeight(10),
                                      horizontal: setWidth(50)),
                                  //prefixText有焦点才会显示
                                  labelText: titleList[index],
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintText: hintList[index],
                                  hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(30,
                                          allowFontScalingSelf: true),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  //输入框背景色
                                  fillColor: Color(0x30cccccc),
                                  //true fillColor生效
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0x00FF0000)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  focusedBorder: OutlineInputBorder(
                                      //边框选中时的颜色
                                      borderSide: BorderSide(
                                          color: Colors.indigo[colorNum]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      errorShowTime++;
                                    });
                                    return tipsList[index];
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  switch (index) {
                                    case 0:
                                      _phone = value.trim();
                                      break;
                                    case 1:
                                      _code = value.trim();
                                      break;
                                    case 2:
                                      _password = value.trim();
                                      break;
                                    case 3:
                                      confirmPassword = value.trim();
                                      break;
                                  }
                                },
                                onChanged: (value) {
                                  switch (index) {
                                    case 0:
                                      _phone = value.trim();
                                      break;
                                    case 1:
                                      _code = value.trim();
                                      break;
                                    case 2:
                                      _password = value.trim();
                                      break;
                                    case 3:
                                      confirmPassword = value.trim();
                                      break;
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: titleList.length,
                      separatorBuilder: (context, i) {
                        return SizedBox(
                          height: setHeight(20),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: setWidth(157.5),
          top: setHeight(buttonTop),
          child:
              //提交按键-----------------------------------------
              Container(
            //padding: EdgeInsets.only(top: topIndent, left: ,right: rightIndent),
            height: setHeight(80),
            width: setWidth(435),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.indigo[colorNum],
              color: Color(0xff274094),
              elevation: 3.0,
              child: InkWell(
                onTap: () async {
                  //_submitForm();
                  if (_resetFormKey.currentState.validate()) {
                    _resetFormKey.currentState.save();
                    if (_password != confirmPassword) {
                      Fluttertoast.showToast(msg: '密码不一致');
                    } else {
                      //重置密码
                      var response;
                      try {
                        response = await LCUser.resetPasswordBySmsCode(
                            _phone, _code, confirmPassword);
                      } on LCException catch (error) {
                        print(error.code);
                        print(error.message);
                        setState(() {
                          errorMessage = error;
                        });
                        Fluttertoast.showToast(
                            msg: error.message,
                            toastLength: Toast.LENGTH_SHORT);
                      }
                      print('重置密码后==${response}');
                      print('errorMessage密码后==${errorMessage.code}');
                      if (response == null /*&& errorMessage == null*/) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('重置密码成功'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                          (route) => route == null);
                                    },
                                    child: Text('确定'),
                                  )
                                ],
                              );
                            }).then((value) {
                          Navigator.pop(context);
                        });
                      }
                    }
                  } else if (_resetFormKey.currentState.validate() == false) {
                    print('错误提示次数$errorShowTime');
                    setState(() {
                      cardTop = 550 + errorShowTime / 2 * 75;
                      buttonTop = 800 + errorShowTime / 2 * 75;
                      errorShowTime = 0;
                    });
                  }
                },
                child: Center(
                  child: Text(
                    '提交',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            ScreenUtil().setSp(40, allowFontScalingSelf: true),
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: InkWell(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: setWidth(50),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          left: setWidth(50),
          top: setHeight(80),
        ),
        Padding(
          padding: EdgeInsets.only(top: setHeight(70)),
          child: Text(
            '修改密码',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(45, allowFontScalingSelf: true),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }
}
