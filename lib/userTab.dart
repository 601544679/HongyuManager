import 'package:flutter/material.dart';

class UserTab extends StatefulWidget {
  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  String user = '个人信息';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
