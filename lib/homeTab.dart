import 'package:flutter/material.dart';

import 'constant.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homeTabName),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
