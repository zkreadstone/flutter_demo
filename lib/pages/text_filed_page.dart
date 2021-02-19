import 'package:flutter/material.dart';

class TextFieldPage extends StatefulWidget {
  TextFieldPage({Key key}) : super(key: key);

  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {

  FocusNode _focusNode = FocusNode(); //输入框焦点控制
  TextEditingController _textFieldController = TextEditingController(); //输入框控制

  onChanged(text){
    //文本发生变化
  }

  //文本插入的方法
  insertTextInInput(text0){
     String text =  _textFieldController.text;
    int index0 = _textFieldController.selection.start;
    String start = text.substring(0,index0);
     text = text.replaceRange(
        index0,
        start.length,
        text0);
    _textFieldController.text = text;
    _textFieldController
      ..selection = TextSelection.fromPosition(
        TextPosition(
          affinity: TextAffinity.downstream,
          offset: index0 + text0.length,
        ),
      );
  }

  //文本插入按钮
  Widget insertBtn(){
    return GestureDetector(
      onTap:() => insertTextInInput('插入文本'),
      child:Container(
        width: 80,
        height: 40,
        alignment: Alignment.center,
        color: Colors.yellow,
        child: Text('插入文本'),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
      appBar: new AppBar(
        title: Text('输入框相关'),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:Column(
          children:[
            Container(
            width: MediaQuery.of(context).size.width-20,
            child: Container(
                  constraints: BoxConstraints(
                    minHeight: 30,
                    maxHeight:260,
                  ),
                  child:TextField(
                          focusNode: _focusNode,
                          controller: _textFieldController,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          keyboardAppearance: Brightness.dark,
                          maxLength: 1000,
                          cursorColor: Colors.pink,
                          style: TextStyle(fontSize: 15,color: Colors.white),
                          onChanged: (text) => onChanged(text),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.cyan.withAlpha(100),//Color.fromRGBO(45, 46, 57, 1),
                            counterText: "", //右下角显示
                            hintText:'占位文本',
                            hintStyle: TextStyle(color: Colors.black38),
                            contentPadding:
                                EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius:
                                  const BorderRadius.all(const Radius.circular(6.0)),
                            ), 
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius:
                                  const BorderRadius.all(const Radius.circular(6.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide( width: 0.0),
                              borderRadius:
                                  const BorderRadius.all(const Radius.circular(6.0)),
                            ),
                          ),
                        )
                ),
          ),
          insertBtn(),

          ]
        )
      )
    ));
  }
}