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
  Widget currentScreen = HomeTab();

  @override
  Widget build(BuildContext context) {
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
                    currentScreen = HomeTab();
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
                    currentScreen = OrderTab();
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
                    currentScreen = UserTab();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
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
