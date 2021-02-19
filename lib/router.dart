import 'package:flutter/material.dart';
import 'package:flutter_demo/homepage.dart';
import 'package:flutter_demo/pages/rich_text_page.dart';
import 'package:flutter_demo/pages/text_filed_page.dart'; 

/*
  路由引入
 */ 

Map<String, WidgetBuilder> routers = {
  /**
    基础模块：服务器/频道，聊天界面，成员列表
   */
  'homepage': (context) => HomePage(), 
  'richTextPage': (context) => RichTextPage(), 
  'textFieldPage': (context) => TextFieldPage(), 
};

Route<dynamic> generateRoute(RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routers[name];

  if (pageContentBuilder != null) {
    final Route route = MaterialPageRoute(
      builder: (context) {
        if (settings.arguments != null) {
          // 有参路由
          return pageContentBuilder(context, arguments: settings.arguments);
        } else {
          // 无参路由
          return pageContentBuilder(
            context,
          );
        }
      },
      settings: settings,
    );
    return route;
  }

  return MaterialPageRoute(builder: (context) => HomePage());
}
