import 'package:flutter/material.dart';
import 'constant.dart';
class UserTab extends StatefulWidget {
  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userTabName),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
