import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mydemo/constant.dart';

import 'customeRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydemo/login.dart';
import 'userClass.dart';

class splashScreen extends StatefulWidget {
  final User user;

  splashScreen(this.user);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  Timer timer;
  int countdown = 3;
  String num = '3';

  //动画控制器
  AnimationController _controller;

  //动画
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        num = countdown.toString();
        if (countdown == 0) {
          timer.cancel();
          Navigator.pushAndRemoveUntil(
              context,
              customRoute(LoginPage(
                user: widget.user,
              )),
              (route) => route == null);
        }
        countdown--;
      });
    });
    //初始化
    /*_controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      print('动画进程=$status');
      //动画结束
      if (status == AnimationStatus.completed) {
        */ /*Navigator.pushAndRemoveUntil(
            context,
            customRoute(LoginPage(
              user: widget.user,
            )),
            (route) => route == null);*/ /*

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return LoginPage(
            user: widget.user,
          );
        }), (route) => route == null);
         */ /*   Navigator.pushNamedAndRemoveUntil(
            context, '/loginPage', (route) => route == null,
            arguments: widget.user);*/ /*
      }
    });*/
    //播放动画
    //_controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return Stack(
      children: [
        Container(
          height: setHeight(1334),
          width: setWidth(750),
          child: Image.asset(
            'images/guidewhite.png',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
            left: setWidth(600),
            bottom: setHeight(100),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 15,
              child: Text(
                num,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize:
                        ScreenUtil().setSp(30, allowFontScalingSelf: true)),
              ),
            ))
      ],
    );
    /*return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(_animation),
      child: Container(
        height: setHeight(1334),
        width: setWidth(750),
        child: Image.asset(
          'images/guide.jpg',
          fit: BoxFit.fill,
        ),
      ),
    );*/
  }
}
