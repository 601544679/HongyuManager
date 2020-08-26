import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Overlay_screen_upload.dart';
import 'mainpage.dart';
import 'server.dart';

class ConfirmOder extends StatefulWidget {
  final waybill;
  const ConfirmOder({Key key, this.waybill}) : super(key: key);
  @override
  _ConfirmOderState createState() => _ConfirmOderState();
}

class _ConfirmOderState extends State<ConfirmOder> {
  final _picker = ImagePicker();
  PickedFile imageFile;
  File imagefile;
  PickedFile imageFile1;
  File imagefile1;
  PickedFile imageFile2;
  File imagefile2;
  String imagepath;

  Server server=Server();

  List<String> filepath = [];
  int colorNum = 600;

  _openGallery(BuildContext context) async{
    PickedFile picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState((){
      imageFile = picture;
      imagefile = File(imageFile.path);
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async{

    PickedFile picture  = await _picker.getImage(source: ImageSource.camera);
    this.setState((){
      imageFile = picture;
      imagefile = File(imageFile.path);
      filepath.add(imagefile.toString());
    });
    Navigator.of(context).pop();
  }

  Future<void> _showchoiceDialog(BuildContext context){
    return showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Photos From'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: (){
                      _openGallery(context);
                    },

                  ),
                  Padding(padding: EdgeInsets.all(8.0)),

                  GestureDetector(
                    child: Text('Camera'),
                    onTap: (){
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView(){
    if(imageFile == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 60, 10),
        child: new Icon(Icons.add, color: Colors.grey,),
      );
    }
    else{
      return Image.file(imagefile, fit: BoxFit.cover,);
    }
  }


  _openGallery1(BuildContext context) async{
    PickedFile picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState((){
      imageFile1 = picture;
      imagefile1 = File(imageFile1.path);
      filepath.add(imagefile1.toString());
    });
    Navigator.of(context).pop();
  }

  _openCamera1(BuildContext context) async{

    PickedFile picture  = await _picker.getImage(source: ImageSource.camera);
    this.setState((){
      imageFile1 = picture;
      imagefile1 = File(imageFile1.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> _showchoiceDialog1(BuildContext context){
    return showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Photos From'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: (){
                      _openGallery1(context);
                    },

                  ),
                  Padding(padding: EdgeInsets.all(8.0)),

                  GestureDetector(
                    child: Text('Camera'),
                    onTap: (){
                      _openCamera1(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView1(){
    if(imageFile1 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 60, 10),
        child: new Icon(Icons.add, color: Colors.grey,),
      );
    }
    else{
      return Image.file(imagefile1, fit: BoxFit.cover,);
    }
  }


  _openGallery2(BuildContext context) async{
    PickedFile picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState((){
      imageFile2 = picture;
      imagefile2 = File(imageFile2.path);
      filepath.add(imagefile2.toString());
    });
    Navigator.of(context).pop();
  }

  _openCamera2(BuildContext context) async{

    PickedFile picture  = await _picker.getImage(source: ImageSource.camera);
    this.setState((){
      imageFile2 = picture;
      imagefile2 = File(imageFile2.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> _showchoiceDialog2(BuildContext context){
    return showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Photos From'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: (){
                      _openGallery2(context);
                    },

                  ),
                  Padding(padding: EdgeInsets.all(8.0)),

                  GestureDetector(
                    child: Text('Camera'),
                    onTap: (){
                      _openCamera2(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView2(){
    if(imageFile2 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 60, 10),
        child: new Icon(Icons.add, color: Colors.grey,),
      );
    }
    else{
      return Image.file(imagefile2, fit: BoxFit.cover,);
    }
  }

  uploadImages() async{
    var response;
    response=await server.uploadImage(widget.waybill.ID,imagefile,imageFile1,imageFile2);
    print(response);
    response=await server.finishWaybill(widget.waybill.ID);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('确认收货',
            //style: Theme.of(context).textTheme.title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          )

      ),
       // automaticallyImplyLeading: false,

      )
      ,
      body: Column(
        children: <Widget>[
          SizedBox(height: 30,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container (
                    height: 100,
                    width: 100,
                    //padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
                        onPressed: (){
                          _showchoiceDialog(context);
                        },
                        child: _decideImageView()
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      '目的地图',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),

                ],
              ),
              Column(
                children: <Widget>[
                  Container (
                    height: 100,
                    width: 100,
                    //padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
                        onPressed: (){
                          _showchoiceDialog1(context);
                        },
                        child: _decideImageView1()
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '顺风单图',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container (
                    height: 100,
                    width: 100,
                    //padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
                        onPressed: (){
                          _showchoiceDialog2(context);
                        },
                        child: _decideImageView2()
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '运货单图',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 50,),
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 90.0,right: 80.0),
            height: 45.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.indigo[colorNum],
              color: Colors.indigo[colorNum],
              elevation: 7.0,
              child: InkWell(
                onTap:  ()async{
                  if (!OverlayScreen().printState()){
                    OverlayScreen().pop();
                  }
                  OverlayScreen().show(context);
                  var response=await uploadImages();
                  OverlayScreen().pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: "/home"),
                      builder: (context) => Home(),
                    ),
                  );
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/home"));
                },
                child: Center(
                  child: Text(
                    '确认',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
