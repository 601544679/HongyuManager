import 'package:flutter/material.dart';
import 'sizeConfig.dart';
import 'server.dart';
import 'constant.dart';

class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
  String number;

  FinishPage({this.number});
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print('done');
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              print('hasData');
              // 请求成功，显示数据
              return ImageBuilder();
            }
            break;
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.indigo[colorNum]),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Text('正在加载...')
              ],
            );
            break;
          case ConnectionState.active:
            print('active');
            break;
        }
      },
      future: imageFuture(),
    );
  }

  imageFuture() async {
    var a = await Server().getFinishImage(widget.number);
    return 1;
  }
}

class ImageBuilder extends StatefulWidget {
  @override
  _ImageBuilderState createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  List image = [
    'https://i0.hdslb.com/bfs/archive/8960f855cdc2c0576d89626f2da080e2f2cf876b.jpg',
    'https://i0.hdslb.com/bfs/archive/563c74bf0dec75460eeffdda71fc3791913fcc5e.png@320w_184h_1c_100q.png',
    'https://i0.hdslb.com/bfs/live/69b3af257667506850bdc44621b176dd1055598d.jpg@320w_330h_1c_100q.webp'
  ];
  List s = ['目的地图', '运货单号', '顺丰单号'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单完成情况'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return Container(
            //color: Colors.red,
            child: Column(
              children: [
                Text(
                  s[index],
                  style: TextStyle(fontSize: SizeConfig.heightMultiplier * 3),
                ),
                Image.network(
                  image[index],
                  fit: BoxFit.cover,
                )
              ],
            ),
          );
        },
        itemCount: image.length,
      ),
    );
  }
}
