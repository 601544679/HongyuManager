import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.indigo[50],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(),
                      fullscreenDialog: true)),
            ),
            title: Text(
              '修改密码',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true),
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            )),
        body: Form(
          key: _resetFormKey,
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: setHeight(102),
                ),

                //手机号码--------------------
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: setWidth(56),
                    ),
                    Text(
                      '手机号码:',
                      style: TextStyle(
                        fontSize: fontSize1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    SizedBox(
                      width: setWidth(19),
                    ),
                    Container(
                      //padding: EdgeInsets.only(top: topIndent, left: leftIndent,right: rightIndent),
                      height: setHeight(80),
                      width: setWidth(435),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: ' 请输入您的手机号码',
                                  hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(30,
                                          allowFontScalingSelf: true),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '请输入手机号码';
                                }
                                if (value.length != 11) {
                                  return '请输入正确的手机号';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _phone = value.trim();
                              },
                              onChanged: (value) {
                                _phone = value.trim();
                                print('value是啥${value}');
                                print('value是空${value.isEmpty}');
                              },
                            ),
                          ),
                          //获取手机验证码按键----------------------
                          Container(
                            width: setWidth(174),
                            height: setHeight(61),
                            //padding: EdgeInsets.only(right: 5),
                            child: RaisedButton(
                              onPressed: buttonDisable == false
                                  ? () async {
                                      if (_phone == '' || _phone == null) {
                                        Fluttertoast.showToast(msg: '请输入手机号码');
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
                                          if (error.code == 213) {
                                            Fluttertoast.showToast(
                                                msg: '该手机号未注册,请先注册',
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: error.message,
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                          }
                                        }
                                        print('发送验证码重置${response}');
                                        timer = Timer.periodic(
                                            Duration(milliseconds: 1000),
                                            (timer) {
                                          setState(() {
                                            buttonDisable = true;
                                            text = countdown.toString();
                                            if (countdown == 0) {
                                              timer.cancel();
                                              text = '获取验证码';
                                              buttonDisable = false;
                                              countdown = 60;
                                            }
                                            countdown--;
                                          });
                                        });
                                        print('获取验证码${response}');
                                        print(_phone);
                                      }
                                    }
                                  : null,
                              color: Colors.indigo[colorNum],
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Text(text,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(21.5,
                                          allowFontScalingSelf: true),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: setHeight(40),
                ),
                //验证码---------------------------
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: setWidth(56),
                    ),
                    Text(
                      '验证号码:',
                      style: TextStyle(
                        fontSize: fontSize1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    SizedBox(
                      width: setWidth(19),
                    ),
                    Container(
                      //padding: EdgeInsets.only(top: topIndent, left: leftIndent,right: rightIndent),
                      height: setHeight(80),
                      width: setWidth(435),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ' 请输入收到的验证码',
                            hintStyle: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(30, allowFontScalingSelf: true),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        onSaved: (value) {
                          _code = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '请输入验证码';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: setHeight(158),
                ),
                //登录密码---------------------------------
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: setWidth(56),
                    ),
                    Text(
                      '登录密码:',
                      style: TextStyle(
                        fontSize: fontSize1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    SizedBox(
                      width: setWidth(19),
                    ),
                    Container(
                      //padding: EdgeInsets.only(top: topIndent, left: leftIndent,right: rightIndent),
                      height: setHeight(80),
                      width: setWidth(435),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ' 6～18位数字或字母组合',
                            hintStyle: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(30, allowFontScalingSelf: true),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '请输入密码';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value.trim();
                        },
                        onChanged: (value) {
                          _password = value.trim();
                          print('value是啥${value}');
                          print('value是空${value.isEmpty}');
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: setHeight(40),
                ),
                //确认密码---------------------------------------
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: setWidth(56),
                    ),
                    Text(
                      '确认密码:',
                      style: TextStyle(
                        fontSize: fontSize1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    SizedBox(
                      width: setWidth(19),
                    ),
                    Container(
                      //padding: EdgeInsets.only(top: topIndent, left: leftIndent,right: rightIndent),
                      height: setHeight(80),
                      width: setWidth(435),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ' 6～18位数字或字母组合',
                            hintStyle: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(30, allowFontScalingSelf: true),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '请输入确认密码';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmPassword = value.trim();
                        },
                        onChanged: (value) {
                          confirmPassword = value.trim();
                          print('value是啥${value}');
                          print('value是空${value.isEmpty}');
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: setHeight(158),
                ),
                //提交按键-----------------------------------------
                Container(
                  //padding: EdgeInsets.only(top: topIndent, left: ,right: rightIndent),
                  height: setHeight(80),
                  width: setWidth(435),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.indigo[colorNum],
                    color: Colors.indigo[colorNum],
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
                              Fluttertoast.showToast(
                                  msg: error.message,
                                  toastLength: Toast.LENGTH_SHORT);
                            }
                            print('重置密码后==${response}');
                            if (response == null) {
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
                        }
                      },
                      child: Center(
                        child: Text(
                          '提交',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
