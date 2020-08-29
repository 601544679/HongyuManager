import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'userclass.dart';
import 'server.dart';

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

  @override
  Widget build(BuildContext context) {

    User _user = widget.user ?? null;
    if (_user?.password != null && _user?.password != "") {
      checkBoxValue = true;
      _passwordControl.text = _user.password;
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 25,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/hongyu.png',
                      width: SizeConfig.widthMultiplier * 70,
                      fit: BoxFit.cover,
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            //只能存在一个key
            height: SizeConfig.heightMultiplier * 35,
            //color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: _loginformKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 15,
                          right: SizeConfig.widthMultiplier * 15),
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
                            style: TextStyle(
                                fontSize: SizeConfig.widthMultiplier * 5),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '输入手机号码',
                                icon: Icon(
                                  Icons.phone_android,
                                  size: SizeConfig.heightMultiplier * 4,
                                ),
                                labelText: '输入手机号码'),
                          ),
                          TextFormField(
                            controller: _passwordControl,
                            obscureText: true,
                            // ignore: missing_return
                            style: TextStyle(
                                fontSize: SizeConfig.widthMultiplier * 5),
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
                                  size: SizeConfig.heightMultiplier * 4,
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
            height: SizeConfig.heightMultiplier * 20,
            //color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                            print(value);
                            checkBoxValue = value;
                          });
                        }),
                    InkWell(
                      child: Text(
                        '记住密码',
                        style: TextStyle(
                            fontSize: SizeConfig.heightMultiplier * 2),
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
                              _user.phoneNumber = response['mobilePhoneNumber'];
                              _user.isSave = checkBoxValue;
                              _user.saveUser(_user);
                              print(response);
                              Navigator.pushNamed(context, "/homePage");
                            }
                          }
                        },
                        child: Text(
                          '登录',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.heightMultiplier * 2.5),
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
            height: SizeConfig.heightMultiplier * 20,
            //color: Colors.yellow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
