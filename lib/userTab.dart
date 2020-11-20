import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mydemo/constant.dart';
import 'package:mydemo/finishPage.dart';
import 'package:mydemo/resetpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customeRoute.dart';
import 'login.dart';
import 'mainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List titleList1 = ['电子邮箱', '设置', '通知', '打卡', '所属部门', '修改密码', '退出登录'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          '个人信息',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: [
          //stack超过第一个布局的范围会无法点击，因此第一个控件要布满
          Container(
            width: setWidth(750),
            height: setHeight(1100),
          ),
          ClipPath(
              clipper: BottomClipper(),
              child: Container(
                height: setHeight(700),
                color: Colors.indigo[colorNum],
                width: setWidth(750),
              )),
          Positioned(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.asset(
                'images/touxiang.png',
                width: setWidth(170),
              ),
            ),
            left: setWidth(80),
            top: setHeight(80),
          ),
          Positioned(
            child: Text(
              '姓名：${widget.contentList[0]}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true)),
            ),
            left: setWidth(320),
            top: setHeight(70),
          ),
          Positioned(
            child: Text(
              '岗位：${widget.contentList[1]}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true)),
            ),
            left: setWidth(320),
            top: setHeight(135),
          ),
          Positioned(
            child: Text(
              '联系电话：${widget.contentList[2]}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true)),
            ),
            left: setWidth(320),
            top: setHeight(200),
          ),
          Positioned(
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListView.builder(
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: setWidth(20),
                            right: setWidth(20),
                            top: setHeight(15),
                            bottom: setHeight(15)),
                        child: InkWell(
                          onTap: () async {
                            print('点击了=$i');
                            switch (i) {
                              case 5:
                                Navigator.push(
                                    context, customRoute(ResetPassword()));
                                break;
                              case 6:
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                final storage = new FlutterSecureStorage();
                                await storage.deleteAll();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    customRoute(LoginPage()),
                                    (route) => route == null);
                                break;
                              default:
                                Fluttertoast.showToast(
                                    msg: '敬请期待!!!',
                                    toastLength: Toast.LENGTH_SHORT);
                                break;
                            }
                          },
                          child: Container(
                            width: setWidth(600),
                            child: Row(
                              children: [
                                Text(
                                  titleList1[i],
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(30,
                                          allowFontScalingSelf: true)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      )
                    ],
                  );
                },
                itemCount: titleList1.length,
              ),
            ),
            width: setWidth(600),
            height: setHeight(550),
            top: setHeight(350),
            left: setWidth(75),
          ),
          /*SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(500),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  final storage = new FlutterSecureStorage();
                  await storage.deleteAll();
                  Navigator.pushAndRemoveUntil(context,
                      customRoute(LoginPage()), (route) => route == null);
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
                  Navigator.push(context, customRoute(ResetPassword()));
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
        )*/
        ],
      ),
    );
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
