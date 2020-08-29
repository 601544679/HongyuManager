import 'package:flutter/material.dart';
import 'sizeConfig.dart';
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
      body: InkWell(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.grey)),
              height: SizeConfig.heightMultiplier * 25,
              width: SizeConfig.heightMultiplier * 25,
              child: Icon(
                Icons.add,
                size: SizeConfig.widthMultiplier * 10,
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            Text(
              '发布订单',
              style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
            )
          ],
        )),
        onTap: () {
          Navigator.pushNamed(context, '/releaseOrder');
        },
      ),
    );
  }
}
