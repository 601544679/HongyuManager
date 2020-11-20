import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo/releaseOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mySearch.dart';
import 'customeRoute.dart';

class HomeTab extends StatefulWidget {
  final changeCurrentTab;

  const HomeTab({this.changeCurrentTab, Key key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
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
  bool isStopTimer = false;

  void stopTimer(bool stopTimer) {
    setState(() {
      isStopTimer = stopTimer;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('HomeTab生命周期=${state}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(viewportFraction: 1, initialPage: 0);
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      //time++;
      //print('计数=${timer.tick}');
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
    WidgetsBinding.instance.addObserver(this);
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
      overflow: Overflow.visible,
      children: [
        Container(
          height: setHeight(1300),
          width: setWidth(750),
        ),
        Container(
          height: setHeight(400),
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
            top: setHeight(320),
            child: CircleAvatar(
              radius: 6,
              backgroundColor:
                  indexPage == 0 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(350),
            top: setHeight(320),
            child: CircleAvatar(
              radius: 6,
              backgroundColor:
                  indexPage == 1 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(400),
            top: setHeight(320),
            child: CircleAvatar(
              radius: 6,
              backgroundColor:
                  indexPage == 2 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(450),
            top: setHeight(320),
            child: CircleAvatar(
              radius: 6,
              backgroundColor:
                  indexPage == 3 ? Colors.greenAccent : Colors.white,
            )),
        Positioned(
            left: setWidth(75),
            top: setHeight(370),
            child: Container(
              width: setWidth(600),
              height: setHeight(60),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey, offset: Offset(1, 1))
                  ],
                  border: Border.all(width: 1, color: Colors.grey[200])),
              child: Padding(
                padding: EdgeInsets.only(
                    left: setWidth(10),
                    right: setWidth(10),
                    top: setHeight(5),
                    bottom: setHeight(5)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: setWidth(5),
                            right: setWidth(5),
                            top: setHeight(10),
                            bottom: setHeight(10)),
                        child: Image.asset(
                          'images/laba.png',
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      flex: 8,
                      child: Text(
                          'hahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahaha'),
                    )
                  ],
                ),
              ),
            )),
        Positioned(
            left: setWidth(35),
            top: setHeight(450),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                    left: setWidth(10),
                    right: setWidth(10),
                    top: setHeight(15),
                    bottom: setHeight(15)),
                child: Container(
                  width: setWidth(650),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              child: Image.asset(
                                'images/fabu.png',
                                width: setWidth(110),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context, customRoute(ReleaseOrder()));
                              }),
                          InkWell(
                              child: Image.asset(
                                'images/huoche.png',
                                width: setWidth(200),
                              ),
                              onTap: () async {
                                /* var response = await Server().searchSuggestion();
                result = response['result'];*/
                                Future<SharedPreferences> _prefs =
                                    SharedPreferences.getInstance();
                                final SharedPreferences preferences =
                                    await _prefs;
                                final history =
                                    preferences.getStringList('historyList');
                                print('历史$history');
                                showSearch(
                                    context: context,
                                    delegate: searchbar(history));
                              }),
                          InkWell(
                              child: Image.asset(
                                'images/lugongsi.png',
                                width: setWidth(130),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.changeCurrentTab(2);
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        height: setHeight(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                '发布送货单',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(25, allowFontScalingSelf: true)),
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                '送货单查询',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(25, allowFontScalingSelf: true)),
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                '物流公司',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(25, allowFontScalingSelf: true)),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
