import 'package:flutter/material.dart';

//路由跳转动画
class customRoute extends PageRouteBuilder {
  final Widget widget;

  customRoute(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (context, animation1, animation2) {
              return widget;
            },
            transitionsBuilder:
                (context, animation1, animation2, Widget child) {
              //渐隐渐现
              /* return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );*/
              //缩放
              /*  return ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );*/
              //平滑，从下到上
              return SlideTransition(
                position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                    .animate(CurvedAnimation(
                        parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            });
}
