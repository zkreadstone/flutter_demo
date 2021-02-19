import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/mark_down_editor/mark_down_contentview.dart';

class RichTextPage extends StatefulWidget {
  RichTextPage({Key key}) : super(key: key);

  @override
  _RichTextPageState createState() => _RichTextPageState();
}

class _RichTextPageState extends State<RichTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top:120,left: 20,right:20),
        child: ListView(
            children:[
            MarkDownContentView(
              content: '*斜体*',
            ),
            SizedBox(height: 20,),

             MarkDownContentView(
              content: '**加粗**',
            ),
            SizedBox(height: 20,),
            
             MarkDownContentView(
              content: '__下划线__',
            ),
            SizedBox(height: 20,),
             MarkDownContentView(
              content: '||隐藏||',
            ),
            SizedBox(height: 20,),
             MarkDownContentView(
              content: '`代码段`',
            ),
            SizedBox(height: 20,),
             MarkDownContentView(
              content: 'http://www.baidu.com',
            ),
          ]
        ),
      )
    );
  }
}