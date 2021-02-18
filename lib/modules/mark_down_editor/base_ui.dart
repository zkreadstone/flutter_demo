/*
 * 作者: wangleigang
 * 描述:  基础ui
 */

import 'package:flutter/material.dart';

// 字体大小
class WorkSize {
  static const double sizeH1 = 16;
  static const double sizeHT = 15;//聊天文本主题字号
  static const double sizeH2 = 14;
  static const double sizeH3 = 12;
  static const double sizeMax = 20;
  static const double sizeMin = 10;
}

// 文字粗细
class WorkWeight {
  static const FontWeight weightH1 = FontWeight.w400; // 中粗
  static const FontWeight weightH2 = FontWeight.w400;
  static const FontWeight weightH3 = FontWeight.w500;
  static const FontWeight weightMax = FontWeight.w600;
}

// 文字颜色
class WorkColor {
  static const Color colorH1 = Color(0xFF28282B);
  static const Color colorH2 = Color(0xFF28282B);
  static const Color colorH3 = Color(0xFF5F6275);
  static const Color colorHint = Color(0xFF8EEB43);
  static const Color colorRed = Color(0xFFFF4158);
  static const Color colorMsg = Color(0xFF46495C);
  static const Color colorBlack = Color(0xFF20212A);
  static const Color colorYotoId = Color(0xFF6B7195);
}

// 背景颜色
class BackgroundColor {
  static const Color bgcH1 = Color(0xFF20212A);
  static const Color bgcH2 = Color(0xFF292A36);
  static const Color bgcVI = Color(0xFF8EEB43);
  static const Color bgcMain = Color(0xFF121217);
  static const Color bgcFocus = Color(0xFF2D2E39);
  static const Color bgSeparator = Color(0xFF545871);
  static const Color barrierColor = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color bgTextField = Color(0xFF1D192B);
}

class LinesColor {
  static const Color lineColor1 = Color(0xFF848599);
  static const Color lineColorQuote = Color(0xFF757998);
  static const Color pinsOper = Color(0xFF545871);
  static const Color reactLine = Color(0xFF2A2C38);
}

// 文字样式
class WorkStyle {
  static const TextStyle workStyleH1 = TextStyle(
    fontSize: WorkSize.sizeH1,
    fontWeight: WorkWeight.weightH1,
    color: WorkColor.colorH1,
  );
  static const TextStyle workStyleH2 = TextStyle(
    fontSize: WorkSize.sizeH2,
    fontWeight: WorkWeight.weightH2,
    color: WorkColor.colorH2,
  );
  static const TextStyle workStyleH3 = TextStyle(
    fontSize: WorkSize.sizeH3,
    fontWeight: WorkWeight.weightH3,
    color: WorkColor.colorH3,
  );
}

// 消息界面使用字体
class MsgTextStyle{

  static const TextStyle newMsgLine = TextStyle(
    fontSize: WorkSize.sizeH3,
    fontWeight: WorkWeight.weightH1,
    color: WorkColor.colorMsg,
  );

  static const TextStyle msgDate = TextStyle(
    fontSize: WorkSize.sizeH3,
    fontWeight: WorkWeight.weightH1,
    color: WorkColor.colorH2,
  );

  static const TextStyle backBottom = TextStyle(
    fontSize: WorkSize.sizeMin,
    fontWeight: WorkWeight.weightH1,
    color: WorkColor.colorH2,
  );

  static const TextStyle hint = TextStyle(
    fontSize: WorkSize.sizeH2,
    fontWeight: WorkWeight.weightH1,
    color: WorkColor.colorBlack,
  );

  static const TextStyle deleteOrWithdraw = TextStyle(
    color: Color(0xFF757998),
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle pinMsgHint = TextStyle(
    color: WorkColor.colorH3,
    fontSize: WorkSize.sizeMin,
    fontWeight: WorkWeight.weightH2
  );

  static const TextStyle textFieldPlacehold = TextStyle(
    fontSize: WorkSize.sizeH2,
    fontWeight: WorkWeight.weightH3,
    color: WorkColor.colorH3,
  );

  static const TextStyle pinsOperWhite = TextStyle(
    fontSize: WorkSize.sizeH2,
    fontWeight: WorkWeight.weightMax,
    color: WorkColor.colorH1
  );

  static const TextStyle pinsOperRed = TextStyle(
    fontSize: WorkSize.sizeH2,
    fontWeight: WorkWeight.weightMax,
    color: WorkColor.colorRed
  );

}

class ReactDetail{
  static TextStyle hintStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WorkColor.colorH1,
  );

  static TextStyle hintStyleNum = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WorkColor.colorHint,
  );

  static TextStyle yotoId = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WorkColor.colorYotoId,
  );
}

//MarkDown 富文本样式
class RichTextStyle {
  /*
   * 最底层文本节点 style
   */
  //普通文本
   static const TextStyle richText_rawText_S = TextStyle(
    color: WorkColor.colorH1,
    fontSize: WorkSize.sizeHT
  );
  //引用
  static const TextStyle richText_rawText_S_q = TextStyle(
    color: WorkColor.colorH2,
    fontSize: WorkSize.sizeH2
  );

   static const TextStyle richText_rawText_F = TextStyle(
    color: WorkColor.colorH2,
    fontSize: WorkSize.sizeHT
  );
  //引用
   static const TextStyle richText_rawText_F_q = TextStyle(
    color: WorkColor.colorH2,
    fontSize: WorkSize.sizeH2
  );

 static TextStyle richTextRawText(status){
   switch (status) {
     case 0:
       return richText_rawText_F;
    case 1:
       return richText_rawText_S;
    case 2:
       return richText_rawText_F_q;
    case 4:
       return richText_rawText_S_q;
     default:
        return null;
   }
  }
  /*
   * 必有子节点的节点类型 style
   */
  //url消息
  static const TextStyle richText_url_S = TextStyle(
      decoration: TextDecoration.underline,
      color: Colors.blue
  );
  static const TextStyle richText_url_F = TextStyle(
      decoration: TextDecoration.underline,
      color: Colors.blue
  );
  //underline
  static const TextStyle richText_underline = TextStyle(
      decoration: TextDecoration.underline,
  );

  //linethrough
  static const TextStyle richText_strike = TextStyle(
      decoration: TextDecoration.lineThrough,
  );

  //underline-linethrough
  // ignore: non_constant_identifier_names
  static  TextStyle richText_strikeUnderline = TextStyle(
    decoration: TextDecoration.combine(
      [TextDecoration.lineThrough,
      TextDecoration.underline]
      ),
  );

  //italic
  static const TextStyle richText_italic = TextStyle(
    fontStyle: FontStyle.italic
  );

   //bold
  static const TextStyle richText_bold = TextStyle(
    fontWeight: FontWeight.bold
  );

  //hidden
  static const TextStyle richText_hidden_S = TextStyle(
    backgroundColor: BackgroundColor.bgcFocus,
    color: BackgroundColor.bgcFocus
  );

  static const TextStyle richText_hidden_U = TextStyle(
    backgroundColor: BackgroundColor.bgcFocus,
    color: Colors.white
  );

  static const TextStyle richText_codeSpan = TextStyle(
    backgroundColor: Colors.cyan
  );

    static const TextStyle richText_fenceCode = TextStyle(
    backgroundColor: Colors.red
  );
}