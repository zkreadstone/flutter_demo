
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/mark_down_editor/scanner.dart';
import 'package:flutter_demo/modules/mark_down_editor/yo_to_parser.dart';
import 'package:flutter_demo/modules/mark_down_editor/block_node.dart';

import 'base_ui.dart';
 
class MarkDownContentView extends StatefulWidget {
  @required final content;
  final maxLines;//最多行数
  final overflow;//超出文本省略样式
  MarkDownContentView({Key key,this.content,this.maxLines,this.overflow}) : super(key: key);

  @override
  _MarkDownContentViewState createState() => _MarkDownContentViewState();
}

class _MarkDownContentViewState extends State<MarkDownContentView> {


  @override
  void initState() {
    super.initState();
    makeDownAstFromContent();
  }
  Document asts;
  List<String> urls;
  String contentStr;//转化后的content，除了不带样式 

  makeDownAstFromContent(){
      //文本解析
      Scanner scanner = Scanner.tokenize(widget.content);
      var parser = new Parser();
      asts = parser.parseScanner(scanner);
      urls = parser.urls;
      contentStr = parser.contentStr;
  }


//Node 转UI对应的总样式
  var styles = {
    'FencedCode':RichTextStyle.richText_fenceCode,//FencedCode
    'CodeSpan':RichTextStyle.richText_codeSpan, //FencedCode
    'Strike': RichTextStyle.richText_strike, //Strike
    'Underline': RichTextStyle.richText_underline, // UnderLine
    'StrikeUnderline': RichTextStyle.richText_strikeUnderline, // UnderLine
    'Bold': RichTextStyle.richText_bold, // Bold
    'Italics': RichTextStyle.richText_italic, // Italic
    'HiddenS': RichTextStyle.richText_hidden_S,
    'HiddenU': RichTextStyle.richText_hidden_U,
    'Url': RichTextStyle.richText_url_S, //FencedCode
    'RawText' : RichTextStyle.richTextRawText(1),
   };

//富文本 递归生成TextSpan
  InlineSpan subTextSpan(node, hasStrikeP) {
    String type = node.runtimeType.toString();
     //有子节点
    if (node.children.isNotEmpty) {
      //有删除线的
      bool hasStrike = type == 'Strike';
      List<InlineSpan> list = List.generate(node.children.length, (int subIndex) {
        return subTextSpan(node.children[subIndex], hasStrike);
      });
      //既有删除线也有下划线
      TextStyle stys = hasStrikeP && type == 'Underline' ? styles['StrikeUnderline'] : styles[type];
      return TextSpan(style: stys, children: list);

    //没有子节点
    } else {
      //对应的Style
      TextStyle stys = hasStrikeP && type == 'Underline'
          ? styles['StrikeUnderline']
          : (styles[type == 'Hidden' ? (type + (node.isHidden ? 'S' : 'U')) : type]);
    
     
     
      
      return TextSpan(
        // //点击手势
        // recognizer: getFornodeTap(node,type),
        //风格样式
        style: stys,
        //文本内容
        text: node.content,
      );
    }
  }

  //AST 转Widgets
  Widget nodeTransformToUI(Document ast) {
    if (ast != null && ast.children != null && ast.children.isNotEmpty) {
      List<Widget> list = [];
      //遍历AST
      for (var blocN in ast.children) {
        //找出其中的引用
        bool isQuote = blocN.runtimeType.toString() == 'Quote';
        if (isQuote) {
          Quote quote = blocN as Quote;
          quote.removeLastNextLine();
        }
        //根据每一个Bloc进行遍历生成富文本
        var subN = subTextSpan(blocN, false);
        var c = Container(
          padding: EdgeInsets.only(
            left: 5,
          ),
          //引用的类型加个边框
          decoration: isQuote
              ? BoxDecoration(
                color: Colors.green.withAlpha(25),
                   border:
                      Border(left: BorderSide(color: Colors.green, width: 2)),
                )
              : null,
          child: ExtendedText.rich(
            subN,
            maxLines: widget.maxLines,overflow: widget.overflow,
            ),
        );
        list.add(c);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      );
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    return nodeTransformToUI(asts);
  }
}