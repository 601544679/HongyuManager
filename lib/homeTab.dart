import 'package:flutter/material.dart';
import 'package:mydemo/server.dart';
import 'sizeConfig.dart';
import 'constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    print('HomeTab--dispose');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('HomeTab--build');

    return InkWell(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.grey)),
            height: ScreenUtil().setWidth(390),
            width: ScreenUtil().setWidth(390),
            child: Icon(
              Icons.add,
              size: ScreenUtil().setWidth(75),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(40),
          ),
          Text(
            '发布送货单',
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true)),
          )
        ],
      )),
      onTap: () async {
        Navigator.pushNamed(context, '/releaseOrder');
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
