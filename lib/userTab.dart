import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'sizeConfig.dart';

class UserTab extends StatefulWidget {
  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> with AutomaticKeepAliveClientMixin {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTab = s.length + 1;
    print('UserTab--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('UserTab--didChangeDependencies');
  }

  @override
  void didUpdateWidget(UserTab oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('UserTab--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('UserTab--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('UserTab--dispose');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('UserTab--build');
    return SingleChildScrollView(
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
                      if (currentTab == index) {
                        visible = !visible;
                      }
                    });
                  },
                  title: Text(
                    s[index],
                    style: TextStyle(
                        color: showVisible(currentTab, index, visible)
                            ? Colors.indigo[colorNum]
                            : Colors.black,
                        fontWeight: showVisible(currentTab, index, visible)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  trailing: Icon(
                    showVisible(currentTab, index, visible)
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: showVisible(currentTab, index, visible)
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
                  visible: showVisible(currentTab, index, visible),
                )
              ],
            );
          },
          itemCount: s.length),
    );
  }

  bool showVisible(int currentTab, int index, bool visible) {
    if (currentTab == index && visible == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
