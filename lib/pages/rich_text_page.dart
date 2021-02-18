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
        padding: EdgeInsets.only(top:120),
        child: Column(
          children:[
            MarkDownContentView(
              content: '*斜体*',
            ),
             MarkDownContentView(
              content: '**加粗**',
            ),
             MarkDownContentView(
              content: '__下划线__',
            ),
             MarkDownContentView(
              content: '||隐藏||',
            ),
             MarkDownContentView(
              content: '`代码段`',
            ),
             MarkDownContentView(
              content: 'http://www.baidu.com',
            ),
          ]
        ),
      )
    );
  }
}