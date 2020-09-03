import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'homeTab.dart';
import 'orderTab.dart';
import 'userTab.dart';
import 'constant.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget currentScreen = IndexedStack(
    index: 0,
    children: [HomeTab(), OrderTab(), UserTab()],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    print('currentTab: ${currentTab}');
    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: SizeConfig.heightMultiplier * 9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentTab = 0;
                    currentScreen = IndexedStack(
                      index: 0,
                      children: [HomeTab(), OrderTab(), UserTab()],
                    );
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: SizeConfig.heightMultiplier * 3,
                      color: currentTab == 0
                          ? Colors.indigo[colorNum]
                          : Colors.grey,
                    ),
                    Text(
                      home,
                      style: TextStyle(
                          color: currentTab == 0
                              ? Colors.indigo[colorNum]
                              : Colors.grey),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentTab = 1;
                    currentScreen = IndexedStack(
                      index: 1,
                      children: [HomeTab(), OrderTab(), UserTab()],
                    );
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.reorder,
                        size: SizeConfig.heightMultiplier * 3,
                        color: currentTab == 1
                            ? Colors.indigo[colorNum]
                            : Colors.grey),
                    Text(
                      order,
                      style: TextStyle(
                          color: currentTab == 1
                              ? Colors.indigo[colorNum]
                              : Colors.grey),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentTab = 2;
                    currentScreen = IndexedStack(
                      index: 2,
                      children: [HomeTab(), OrderTab(), UserTab()],
                    );
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car,
                        size: SizeConfig.heightMultiplier * 3,
                        color: currentTab == 2
                            ? Colors.indigo[colorNum]
                            : Colors.grey),
                    Text(
                      user,
                      style: TextStyle(
                          color: currentTab == 2
                              ? Colors.indigo[colorNum]
                              : Colors.grey),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
