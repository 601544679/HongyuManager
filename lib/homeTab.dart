import 'dart:async';

import 'package:flutter/material.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  List picList = [
    'images/ss.png',
    'images/guidewhite.png',
    'images/hongyu.png',
    'images/guide.jpg'
  ];
  int indexPage = 0;
  int time = 0;
  PageController _pageController;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 1, initialPage: 0);
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      //time++;
      print('计数=${timer.tick}');
      if (timer.tick % 2 == 0) {
        setState(() {
          if (indexPage == 3) {
            indexPage = 0;
          } else {
            indexPage++;
          }
          _pageController.jumpToPage(indexPage);
        });
      }
    });
    print('HomeTab--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('HomeTab--didChangeDependencies');
  }

  @override
  void didUpdateWidget(HomeTab oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('HomeTab--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('HomeTab--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    print('HomeTab--dispose');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('HomeTab--build');

    return Stack(
      children: [
        Container(
          height: setHeight(300),
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                indexPage = index;
              });
            },
            controller: _pageController,
            itemBuilder: (context, index) {
              return Image.asset(
                picList[index],
                fit: BoxFit.cover,
              );
            },
            itemCount: picList.length,
          ),
        ),
        Positioned(
            left: setWidth(300),
            top: setWidth(300),
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  indexPage == 0 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(350),
            top: setWidth(300),
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  indexPage == 1 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(400),
            top: setWidth(300),
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  indexPage == 2 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(450),
            top: setWidth(300),
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  indexPage == 3 ? Colors.greenAccent : Colors.white,
            ))
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
