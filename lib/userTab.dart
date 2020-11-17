import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mydemo/constant.dart';
import 'package:mydemo/finishPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userClass.dart';

class userTab extends StatefulWidget {
  @override
  _userTabState createState() => _userTabState();
}

class _userTabState extends State<userTab> {
  List contentList = List();
  String name;
  String role;
  String phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('userTab--initState');
    //getUser();
  }

  getUser() async {
    User _user = await User().getUser();
    if (_user.role == 'Manager') {
      role = '管理员';
    } else if (_user.role == 'merchandiser') {
      role = '跟单员';
    } else if (_user.role == 'logisticsClerk') {
      role = '物流专员';
    } else if (_user.role == 'salesClerk') {
      role = '业务员';
    }
    name = _user.realName;
    phone = _user.phoneNumber;
    contentList = ['$name', '$role', '$phone'];
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
            break;
          case ConnectionState.active:
            return Text('active');
            break;
          case ConnectionState.waiting:
            return Column(children: [
              CircularProgressIndicator(),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              Text('正在加载')
            ]);
            break;
          case ConnectionState.done:
            print('UserTab--done');
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            print('用户信息=${snapshot.data}');
            return userMessage(snapshot.data, contentList);
            break;
          default:
            return null;
            break;
        }
      },
    );
  }
}

class userMessage extends StatefulWidget {
  final user;
  final contentList;

  userMessage(this.user, this.contentList);

  @override
  _userMessageState createState() => _userMessageState();
}

class _userMessageState extends State<userMessage> {
  List titleList = ['用户名', '岗位', '联系电话'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Image.asset('images/touxiang.png'),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(60),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(75),
                      right: ScreenUtil().setWidth(75)),
                  child: Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(37.5),
                          right: ScreenUtil().setWidth(37.5),
                          top: ScreenUtil().setHeight(26),
                          bottom: ScreenUtil().setHeight(26)),
                      child: Row(
                        children: [
                          Text(
                            '${titleList[index]}：${widget.contentList[index]}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil()
                                    .setSp(30, allowFontScalingSelf: true)),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: titleList.length,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: ScreenUtil().setHeight(40),
                );
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(60),
            ),
            MaterialButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                final storage = new FlutterSecureStorage();
                await storage.deleteAll();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/loginPage", (route) => route == null);
              },
              child: Material(
                color: Colors.indigo[colorNum],
                child: Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setHeight(10),
                      bottom: ScreenUtil().setHeight(10)),
                  child: Text(
                    '退出登录',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/resetPassword');
              },
              child: Material(
                elevation: 4,
                color: Colors.indigo[colorNum],
                child: Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setHeight(10),
                      bottom: ScreenUtil().setHeight(10)),
                  child: Text(
                    '修改密码',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
