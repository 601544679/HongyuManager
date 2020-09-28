import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'userClass.dart';
import 'server.dart';
import 'mainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  final User user;

  const LoginPage({Key key, this.user}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBoxValue = false;
  final server = Server();
  TextEditingController _passwordControl = new TextEditingController();
  final _loginformKey = GlobalKey<FormState>();

  autoLogin(context) async {
    if (checkBoxValue &&
        widget.user?.phoneNumber != null &&
        widget.user?.password != null) {
      var response = await server.mobilePhoneLogin(
          widget.user?.phoneNumber ?? null,
          widget.user?.password ?? null,
          false);
      if (response != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/homePage", (route) => route == null);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => autoLogin(context));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1080, 2248), allowFontScaling: false);
    print('像素密度--${ScreenUtil().pixelRatio}');
    print('像素宽度--${ScreenUtil().screenWidthPx}');
    print('像素高度--${ScreenUtil().screenHeightPx}');
    print('设备宽度--${ScreenUtil().screenWidth}');
    print('设备高度--${ScreenUtil().screenHeight}');
    print('缩放宽度--${ScreenUtil().scaleWidth}');
    print('缩放高度--${ScreenUtil().scaleHeight}');
    print('底部安全距离--${ScreenUtil().bottomBarHeight}');
    print('状态栏高度(刘海屏)--${ScreenUtil().statusBarHeight}');
    print('系统字体缩放比例--${ScreenUtil().scaleText}');
    User _user = widget.user ?? User();
    if (_user?.password != null && _user?.password != "") {
      checkBoxValue = true;
      _passwordControl.text = _user.password;
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(276),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/hongyu.png',
                  width: ScreenUtil().setWidth(756),
                  fit: BoxFit.cover,
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Container(
              //只能存在一个key
              height: ScreenUtil().setHeight(787),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: _loginformKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(162),
                            right: ScreenUtil().setWidth(162)),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: _user.phoneNumber,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return '手机号不能为空';
                                }
                                if (isChinaPhoneLegal(value) == false) {
                                  //print('手机号码格式错误');
                                  return '手机号码格式错误';
                                }
                                return null;
                              },
                              //保存输入手机到 userclass
                              onSaved: (input) => _user.phoneNumber = input,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]"))
                              ],
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(50, allowFontScalingSelf: true)),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  hintText: '输入手机号码',
                                  icon: Icon(
                                    Icons.phone_android,
                                    size: ScreenUtil()
                                        .setSp(80, allowFontScalingSelf: true),
                                  ),
                                  labelText: '输入手机号码'),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(50),),
                            TextFormField(
                              controller: _passwordControl,
                              obscureText: true,
                              // ignore: missing_return
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(50, allowFontScalingSelf: true)),
                              validator: (input) {
                                //print('输出：${input}');
                                if (input.trim().isEmpty) {
                                  return '密码不能为空';
                                }
                                return null;
                              },
                              onSaved: (input) => _user.password = input,
                              decoration: InputDecoration(
                                  hintText: '输入密码',
                                  icon: Icon(
                                    Icons.lock,
                                    size: ScreenUtil()
                                        .setSp(80, allowFontScalingSelf: true),
                                  ),
                                  labelText: '输入密码'),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Container(
              //color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(162),
                      ),
                      Checkbox(
                          value: checkBoxValue,
                          activeColor: Colors.indigo[colorNum],
                          onChanged: (value) {
                            setState(() {
                              print(value);
                              checkBoxValue = value;
                            });
                          }),
                      InkWell(
                        child: Text(
                          '记住密码',
                          style: TextStyle(
                              fontSize: ScreenUtil()
                                  .setSp(45, allowFontScalingSelf: true)),
                        ),
                        onTap: () {
                          setState(() {
                            print('bool$checkBoxValue');
                            checkBoxValue = !checkBoxValue;
                            print('!bool$checkBoxValue');
                          });
                        },
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(249),
                      ),
                      InkWell(
                        onTap: () {
                          // TODO :跳转到找回密码
                        },
                        child: Text(
                          '忘记密码?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.indigo[colorNum],
                              fontSize: ScreenUtil()
                                  .setSp(45, allowFontScalingSelf: true)),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(250),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(162),
                            right: ScreenUtil().setWidth(162)),
                        child: FlatButton(
                          onPressed: () async {
                            // todo 登录事件，跳转路由，
                            // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)
                            if (_loginformKey.currentState.validate()) {
                              _loginformKey.currentState.save();
                              //"13802621111", "123456"
                              var response = await server.mobilePhoneLogin(
                                  _user.phoneNumber, _user.password);
                              if (response != null) {
                                _user.sessionToken = response['sessionToken'];
                                _user.idNumber = response['identityNo'];
                                _user.name = response['username'];
                                _user.company = response['company'];
                                _user.phoneNumber =
                                    response['mobilePhoneNumber'];
                                _user.isSave = checkBoxValue;
                                _user.saveUser(_user);
                                print(response);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    "/homePage", (route) => route == null);
                              } else {
                                Fluttertoast.showToast(
                                    msg: '登录失败',
                                    toastLength: Toast.LENGTH_SHORT);
                              }
                            }
                          },
                          child: Text(
                            '登录',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil()
                                    .setSp(60, allowFontScalingSelf: true)),
                          ),
                          color: Colors.indigo[colorNum],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(120),
            ),
            Container(
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    indent: ScreenUtil().setWidth(162),
                    endIndent: ScreenUtil().setWidth(162),
                    height: SizeConfig.heightMultiplier,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      FlatButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.build,
                                color: Colors.indigo[colorNum],
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(33),
                              ),
                              Text(
                                '技术支持：纠结个分节符',
                                style: TextStyle(
                                    color: Colors.indigo[colorNum],
                                    fontSize: ScreenUtil()
                                        .setSp(45, allowFontScalingSelf: true)),
                              )
                            ],
                          )),
                      FlatButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.indigo[colorNum],
                              ),
                              SizedBox(
                                width:  ScreenUtil().setWidth(33),
                              ),
                              Text(
                                '联系电话：13659874521',
                                style: TextStyle(
                                    color: Colors.indigo[colorNum],
                                    fontSize: ScreenUtil()
                                        .setSp(45, allowFontScalingSelf: true)),
                              )
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
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
