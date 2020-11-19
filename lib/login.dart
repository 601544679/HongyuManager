import 'dart:io';
import 'package:mydemo/resetpassword.dart';

import 'customeRoute.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'constant.dart';
import 'mainPage.dart';
import 'userClass.dart';
import 'server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'loginDialog.dart';
import 'package:device_info/device_info.dart';

class LoginPage extends StatefulWidget {
  final User user;

  const LoginPage({Key key, this.user}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  bool checkBoxValue = false;
  final server = Server();
  TextEditingController _passwordControl = new TextEditingController();
  final _loginformKey = GlobalKey<FormState>();
  FocusNode focusNodeNum = FocusNode(); //控制手机号码焦点
  FocusNode focusNodePas = FocusNode(); //控制密码焦点
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool keyboardOpen = false;

  autoLogin(context) async {
    var refreshToken;
    User _user = User();
    if ( //checkBoxValue &&
        widget.user?.phoneNumber != '' &&
            widget.user?.password != '' &&
            widget.user?.phoneNumber != null &&
            widget.user?.password != null) {
      var response = await showDialog(
          context: context,
          builder: (_) {
            return loginDialog(
              outsideDismiss: false,
              requestCallBack: LCUser.login(
                widget.user.name,
                widget.user.password,
              ),
            );
          });
      if (response.runtimeType == LCUser) {
        _user.idNumber = response['identityNo'];
        _user.name = response.username;
        _user.company = response['company'];
        _user.role = response['role'];
        print('realName = ${response['realName']}');
        _user.realName = response['realName'];
        _user.phoneNumber = response['mobilePhoneNumber'];
        //_user.objectId = response['objectId'];
        //用sdk
        _user.objectId = response.objectId;
        _user.isSave = checkBoxValue;
        try {
          refreshToken = await Server()
              .refreshToken(response.sessionToken, response.objectId);
          //更新缓存的token
          LCUser.login(widget.user.name, widget.user.password);
          print('自动登录refreshToken--$refreshToken');
          _user.sessionToken = refreshToken['sessionToken'];
          print('自动登录更新--${_user.sessionToken}');
          _user.saveUser(_user);
          print('保存后token=${_user.sessionToken}');
          scaffoldKey.currentState.showSnackBar(showSnackBar('自动登录成功'));
        } on DioError catch (e) {
          print('error=${e.response.data}');
        }
        Navigator.pushAndRemoveUntil(
            context, customRoute(Home()), (route) => route == null);
      } else if (response.runtimeType == LCException) {
        print('autoLogin--error${response.code}');
        if (response.code == 211) {
          Fluttertoast.showToast(
              msg: '该用户不存在', toastLength: Toast.LENGTH_SHORT);
        }
      }
    }
  }

  getDevice() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      print('安卓设备--${androidDeviceInfo.androidId}');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      print('苹果设备--${iosDeviceInfo.utsname.machine}');
    }
  }

//更改状态栏
  //AnnotatedRegion效果更好,但是安卓要配合这个方法，ios不用
  changeStatusBar() {
    print('login改变状态栏');
    //绘制完成后回调
    if (Platform.isAndroid) {
      //沉浸式状态栏
      //写在组件渲染之后，是为了在渲染后进行设置赋值，覆盖状态栏，写在渲染之前对MaterialApp组件会覆盖这个值。
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    //监听键盘
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => changeStatusBar());
    WidgetsBinding.instance.addPostFrameCallback((_) => autoLogin(context));
    getDevice();
    print('LoginPage--initState');
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
    super.didChangeMetrics();
    print('LoginPage--didChangeMetrics');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (focusNodePas.hasFocus) {
          if (MediaQuery.of(context).viewInsets.bottom == 0) {
            print('键盘关闭了');
            keyboardOpen = false;
          } else {
            print('键盘打开了');
            keyboardOpen = true;
          }
        } else if (focusNodeNum.hasFocus) {
          if (MediaQuery.of(context).viewInsets.bottom == 0) {
            print('键盘关闭了');
            keyboardOpen = false;
          } else {
            print('键盘打开了');
            keyboardOpen = true;
          }
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('LoginPage--didChangeDependencies');
  }

  @override
  void didUpdateWidget(LoginPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('LoginPage--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('LoginPage--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNodeNum.dispose();
    focusNodePas.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print('LoginPage--dispose');
  }

  @override
  Widget build(BuildContext context) {
    print('LoginPage--build');
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    double fontSize = ScreenUtil().setSp(30, allowFontScalingSelf: true);
    /*print('像素密度--${ScreenUtil().pixelRatio}');
    print('像素宽度--${ScreenUtil().screenWidthPx}');
    print('像素高度--${ScreenUtil().screenHeightPx}');
    print('设备宽度--${ScreenUtil().screenWidth}');
    print('设备高度--${ScreenUtil().screenHeight}');
    print('缩放宽度--${ScreenUtil().scaleWidth}');
    print('缩放高度--${ScreenUtil().scaleHeight}');
    print('底部安全距离--${ScreenUtil().bottomBarHeight}');
    print('状态栏高度(刘海屏)--${ScreenUtil().statusBarHeight}');
    print('系统字体缩放比例--${ScreenUtil().scaleText}');*/
    User _user = widget.user ?? User();
    if (_user?.password != null && _user?.password != "") {
      //checkBoxValue = true;
      _passwordControl.text = _user.password;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Container(
          height: setHeight(1334),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    /*ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    height: setHeight(660),
                    color: Colors.indigo[colorNum],
                    child: Image.asset(
                      'images/gg.png',
                      fit: BoxFit.cover,
                    ),
                  ))*/
                    Image.asset(
                      'images/ss.png',
                      height: ScreenUtil().setHeight(1334),
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      left: setWidth(75),
                      top: setHeight(keyboardOpen == true ? 350 : 500),
                      width: setWidth(600),
                      height: setHeight(650),
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.indigo[colorNum],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: setWidth(15),
                              right: setWidth(15),
                              top: setHeight(26),
                              bottom: setHeight(26)),
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: setHeight(50),
                                ),
                                Container(
                                  width: setWidth(500),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return '用户名不能为空';
                                      }
                                      return null;
                                    },
                                    //保存输入手机到 userclass
                                    onSaved: (input) =>
                                        _user.name = input.trim(),
                                    initialValue: _user.name,
                                    focusNode: focusNodeNum,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person_pin,
                                        size: setWidth(60),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: setHeight(20),
                                          horizontal: setWidth(20)),
                                      //输入框背景色
                                      fillColor: Color(0x30cccccc),
                                      //true fillColor生效
                                      filled: true,
                                      hintText: '请输入用户名',
                                      enabledBorder: OutlineInputBorder(
                                          //失去焦点时边框颜色
                                          borderSide: BorderSide(
                                              color: Color(0x00FF0000)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          //边框选中时的颜色
                                          borderSide: BorderSide(
                                              color: Colors.indigo[colorNum]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: setHeight(50),
                                ),
                                Container(
                                  width: setWidth(500),
                                  child: TextFormField(
                                    validator: (input) {
                                      //print('输出：${input}');
                                      if (input.trim().isEmpty) {
                                        return '密码不能为空';
                                      }
                                      return null;
                                    },
                                    maxLines: 1,
                                    inputFormatters: [
                                      //只能输入0-9
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9,a-z,A-Z]')),
                                    ],
                                    onSaved: (input) =>
                                        _user.password = input.trim(),
                                    focusNode: focusNodePas,
                                    initialValue: _user.password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: setHeight(20),
                                          horizontal: setWidth(20)),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        size: setWidth(60),
                                      ),
                                      //输入框背景色
                                      fillColor: Color(0x30cccccc),
                                      //true fillColor生效
                                      filled: true,
                                      hintText: '请输入密码',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x00FF0000)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          //边框选中时的颜色
                                          borderSide: BorderSide(
                                              color: Colors.indigo[colorNum]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: setHeight(50),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                              activeColor:
                                                  Colors.indigo[colorNum],
                                              value: checkBoxValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkBoxValue = value;
                                                });
                                              }),
                                          InkWell(
                                            child: Text(
                                              '自动登录',
                                              style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: checkBoxValue == true
                                                      ? Colors.indigo[colorNum]
                                                      : Colors.black),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                checkBoxValue = !checkBoxValue;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            customRoute(ResetPassword()));
                                      },
                                      child: Text(
                                        '忘记密码',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.indigo[colorNum],
                                            fontSize: fontSize),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            key: _loginformKey,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: setWidth(75),
                      top: setHeight(1000),
                      child: Container(
                        width: setWidth(600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                // todo 登录事件，跳转路由，
                                if (_loginformKey.currentState.validate()) {
                                  _loginformKey.currentState.save();
                                  //"13802621111", "123456"
                                  focusNodeNum.unfocus();
                                  focusNodePas.unfocus();
                                  var response = await showDialog(
                                      context: context,
                                      builder: (_) {
                                        return loginDialog(
                                            outsideDismiss: false,
                                            requestCallBack: LCUser.login(
                                                _user.name, _user.password));
                                      });
                                  print('输出=${response.runtimeType}');
                                  if (response.runtimeType ==
                                      LCUser /*response != null*/) {
                                    _user.sessionToken = response.sessionToken;
                                    _user.idNumber = response['identityNo'];
                                    _user.name = response.username;
                                    _user.company = response['company'];
                                    _user.role = response['role'];
                                    print('realName = ${response['realName']}');
                                    _user.realName = response['realName'];
                                    _user.phoneNumber =
                                        response['mobilePhoneNumber'];
                                    //_user.objectId = response['objectId'];
                                    //用sdk
                                    _user.objectId = response.objectId;
                                    _user.isSave = checkBoxValue;
                                    _user.saveUser(_user);
                                    //进行身份验证，管理者才能登录管理者端
                                    if (response['role'] != 'Driver') {
                                      scaffoldKey.currentState
                                          .showSnackBar(showSnackBar('登录成功'));
                                      var refreshToken = await Server()
                                          .refreshToken(_user.sessionToken,
                                              _user.objectId);
                                      print('refreshToken--$refreshToken');
                                      //更新缓存的token
                                      LCUser.login(_user.name, _user.password);
                                      _user.sessionToken =
                                          refreshToken['sessionToken'];
                                      print('更新--${_user.sessionToken}');
                                      _user.saveUser(_user);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          customRoute(Home()),
                                          (route) => route == null);
                                    } else {
                                      scaffoldKey.currentState
                                          .showSnackBar(showSnackBar('非管理者用户'));
                                    }
                                  } else if (response.runtimeType ==
                                      LCException) {
                                    if (response.code == 210) {
                                      scaffoldKey.currentState.showSnackBar(
                                          showSnackBar('账号或密码错误'));
                                    } else if (response.code == 219) {
                                      scaffoldKey.currentState.showSnackBar(
                                          showSnackBar(response.message));
                                    } else if (response.code == 211) {
                                      scaffoldKey.currentState
                                          .showSnackBar(showSnackBar('不存在此用户'));
                                    }
                                  } else if (response.runtimeType == DioError) {
                                    //print('网络错误${response.data}');
                                    print('网络错误error--${response.error}');
                                    scaffoldKey.currentState
                                        .showSnackBar(showSnackBar('断网了'));
                                  }
                                }
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Color(0xff0079d4),
                                shadowColor: Colors.indigo[colorNum],
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: setWidth(130),
                                      right: setWidth(130),
                                      top: setHeight(13),
                                      bottom: setHeight(13)),
                                  child: Text(
                                    '登录',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(40,
                                            allowFontScalingSelf: true)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//正则表达式验证手机号码
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }
}

//贝塞尔曲线下拉形状
class BottomClipper extends CustomClipper<Path> {
  @override
  //size是上面child container的size
  getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    //做长方形效果
    //设置长方形的4个点
    path.lineTo(0, 0);
    path.lineTo(0, size.height - setHeight(200));
    //设置贝塞尔曲线控制点，控制点就是曲线往左右偏,就是曲线的顶点
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - setHeight(200));
    //设置贝塞尔曲线
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<dynamic> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
