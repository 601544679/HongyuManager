import 'package:flutter/material.dart';
import 'sizeConfig.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRememberPassword = false;
  String phoneNumber;
  String password;
  var checkBoxValue = false;
  final int colorNum = 600;
  final _loginformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 25,
            //color: Colors.red,
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/hongyu.png',
                      width: SizeConfig.widthMultiplier * 60,
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            key: _loginformKey,
            //只能存在一个key
            height: SizeConfig.heightMultiplier * 30,
            //color: Colors.green,
            child: Column(
              children: [
                Form(
                    autovalidate: true,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 15,
                          right: SizeConfig.widthMultiplier * 15),
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return '手机号不能为空';
                          }
                          if (isChinaPhoneLegal(value) == false) {
                            //print('手机号码格式错误');
                            return '手机号码格式错误';
                          }
                          return null;
                        },
                        style:
                            TextStyle(fontSize: SizeConfig.widthMultiplier * 5),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: '输入手机号码',
                            icon: Icon(
                              Icons.phone_android,
                              size: SizeConfig.heightMultiplier * 4,
                            ),
                            labelText: '输入手机号码'),
                      ),
                    )),
                Form(
                    autovalidate: true,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 15,
                          right: SizeConfig.widthMultiplier * 15),
                      child: TextFormField(
                        /*initialValue:
                            _getUser(savePas) == null ? "" : _getUser(savePas),*/
                        obscureText: false,
                        // ignore: missing_return
                        style:
                            TextStyle(fontSize: SizeConfig.widthMultiplier * 5),
                        validator: (value) {
                          print('输出：${value}');
                          if (value.isEmpty) {
                            return '密码不能为空';
                          }
                          password = value;
                          print('密码是：${password}');
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: '输入密码',
                            icon: Icon(
                              Icons.lock,
                              size: SizeConfig.heightMultiplier * 4,
                            ),
                            labelText: '输入密码'),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 20,
            //color: Colors.blue,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 15,
                    ),
                    Checkbox(
                        value: checkBoxValue,
                        activeColor: Colors.indigo[colorNum],
                        onChanged: (value) {
                          setState(() {
                            checkBoxValue = value;
                          });
                        }),
                    Text(
                      '记住密码',
                      style:
                          TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 23,
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
                            fontSize: SizeConfig.heightMultiplier * 2),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 15,
                          right: SizeConfig.widthMultiplier * 15),
                      child: FlatButton(
                        onPressed: () {
                          // todo 登录事件，跳转路由
                          //print(_loginformKey.currentState.validate());
                          //如果选中记住密码,保存密码
                        },
                        child: Text(
                          '登录',
                          style: TextStyle(color: Colors.white),
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
          Container(
            height: SizeConfig.heightMultiplier * 25,
            //color: Colors.yellow,
            child: Column(
              children: [
                Divider(
                  indent: SizeConfig.widthMultiplier * 15,
                  endIndent: SizeConfig.widthMultiplier * 15,
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
                              width: SizeConfig.widthMultiplier * 3,
                            ),
                            Text(
                              '技术支持：纠结个分节符',
                              style: TextStyle(
                                  color: Colors.indigo[colorNum],
                                  fontSize: SizeConfig.heightMultiplier * 2),
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
                              width: SizeConfig.widthMultiplier * 3,
                            ),
                            Text(
                              '联系电话：13659874521',
                              style: TextStyle(
                                  color: Colors.indigo[colorNum],
                                  fontSize: SizeConfig.heightMultiplier * 2),
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
    );
  }

//正则表达式验证手机号码
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }
}
