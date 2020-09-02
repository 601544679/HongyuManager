import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'sizeConfig.dart';
import 'login.dart';
import 'userClass.dart';

class UserTab extends StatefulWidget {
  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  bool visible = false;
  List<String> s = [
    '顺丰速递',
    '德邦物流',
    '壹米滴答',
    'EMS',
    '顺丰速递',
    '德邦物流',
    '壹米滴答',
    'EMS',
    '顺丰速递',
    '德邦物流',
    '壹米滴答',
    'EMS',
    '顺丰速递',
    '德邦物流',
    '壹米滴答',
    'EMS'
  ];
  List<String> carNoList = [
    '粤A•58962',
    '鲁C•GR589',
    '赣A•59965',
    '粤B•8y5h4',
    '桂A•95227',
    '疆A•5hh85',
    '粤A•58962',
    '鲁C•GR589',
    '赣A•59965',
    '粤B•8y5h4',
    '桂A•95227',
    '疆A•5hh85',
    '粤A•58962',
    '鲁C•GR589',
    '赣A•59965',
    '粤B•8y5h4',
    '桂A•95227',
    '疆A•5hh85',
  ];
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          UnconstrainedBox(
              child: Padding(
                  padding:
                      EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
                  child: InkWell(
                      child: Wrap(
                        children: [Icon(Icons.exit_to_app), Text('退出')],
                      ),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        final storage = new FlutterSecureStorage();
                        await storage.deleteAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(user: User()),
                              fullscreenDialog: true),
                          (Route<dynamic> route) => false,
                        );
                      }))),
        ],
        title: Text(userTabName),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentTab = index;
                        visible = !visible;
                      });
                    },
                    title: Text(
                      s[index],
                      style: TextStyle(
                          color: currentTab == index
                              ? Colors.indigo[colorNum]
                              : Colors.black,
                          fontWeight: currentTab == index
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_down,
                      color: currentTab == index
                          ? Colors.indigo[colorNum]
                          : Colors.grey,
                    ),
                  ),
                  Visibility(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(carNoList[index]),
                        );
                      },
                      itemCount: carNoList.length,
                    ),
                    visible: currentTab == index ? true : false,
                  )
                ],
              );
            },
            itemCount: s.length),
      ),
    );
  }
}
