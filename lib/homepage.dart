import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text('功能列表 -测试44'),
        ),
        body: Container(
        width:MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            GestureDetector(
              onTap:(){
                Navigator.pushNamed(context, 'richTextPage');
              },
              child:Container(
                color: Colors.pink,
                padding: EdgeInsets.only(left:16,top:18,bottom:18),
                child:Text('markdown 富文本')
              )
            ),
             GestureDetector(
              onTap:(){
                Navigator.pushNamed(context, 'textFieldPage');
              },
              child:Container(
                color: Colors.cyan,
                padding: EdgeInsets.only(left:16,top:18,bottom:18),
                child:Text('文本输入框')
              )
            )
          ],
        ),
      ), 
      )
    );
  }
}