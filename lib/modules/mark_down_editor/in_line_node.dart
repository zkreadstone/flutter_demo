
import 'scanner.dart';

class InlineNode {
  static RegExp pattern = new RegExp('');
  var hasChild = false;
  String color = '';//颜色配置字符串
  bool isSelf = false;//适配@成员 是否是自己
  var keyId;//关键字段id  现阶段用于频道的#点击

  var content = '';
  var tokenList = List<Token>();
  var children = List<dynamic>();

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }

  Scanner toScanner() {
    if (tokenList.isNotEmpty) {
      return Scanner(tokenList);
    } else {
      return null;
    }
  }

  static bool isNumeric(String str) {
    try {
      var res = double.parse(str);
      return res != null && res > 0;
    } on FormatException {
      return false;
    } finally {
      // ignore: control_flow_in_finally
      return true;
    }
  }
}

class CodeSpan extends InlineNode {
  static RegExp pattern = new RegExp(r'(?<!`)`(?!`)(.+?)(?<!`)`(?!`)');

  CodeSpan(String str) {
    content = str;
  }
  static InlineNode parse(Scanner scanner) {
    final matchedToken = scanner.consume();
    var content = '';
    for (var i = 1; i < matchedToken.length - 1; i++) {
      content += matchedToken[i].content();
    }
    return CodeSpan(content);
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}

class Url extends InlineNode {
  //没有任何标识的链接正则https://www.cnblogs.com/csh520mjy/p/11281671.html
//  static RegExp pattern = new RegExp(r'(http[s]?|ftp|news)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
  // static RegExp pattern = new RegExp(r'︴([^ ︴«]*)');
  static RegExp pattern = new RegExp(r'a[^\<\>¬«]*');
  Url(String str) {
    hasChild = false;
    content = str;
  }
   
  static InlineNode parse(Scanner scanner) {
    List<Token> tokenList = scanner.consume();
    var urlStr = '';
    tokenList.forEach((Token subToken){
      urlStr += subToken.content();
    });
    return Url(urlStr);
  }

  static Match match(Scanner scanner) {
    Match m = scanner.match(pattern);
    if (m == null) return null;
    List<Token> tokenList = scanner.tokenList().sublist(m.start,m.end);
    var urlStr = '';
    tokenList.forEach((Token subToken){
      urlStr += subToken.content();
    });

    try {
      Uri p = Uri.parse(urlStr);
      if (!['http','https','ftp'].contains(p.scheme)) {
        return null;
      } 
      if (p.host == null || p.host.isEmpty) {
        return null;
      }
      if (p.port != null && p.port > 65535) {
        
      }
    } catch (e) {
      return null;
    }
    return m;
  }
}

class Hidden extends InlineNode {
  static RegExp pattern = new RegExp(r'(?<!\|)\|\|(.+?)\|\|(?!\|)');
  var isHidden = true;

  Hidden(String con) {
    hasChild = false;
    content = con;
  }
  static InlineNode parse(Scanner scanner) {
    List<Token> tokenList = scanner.consume();
    if (tokenList.isNotEmpty && tokenList.length > 4) {
      var str = '';
      tokenList.sublist(2,tokenList.length-2).forEach((element) {
        str += element.content();
      });
      return Hidden(str);
    }
    return Hidden('');
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}

class Strike extends InlineNode {
  static RegExp pattern = new RegExp(r'(?<!~)~~(.+?)~~(?!~)');

  Strike(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }

  static InlineNode parse(Scanner scanner) {
    final matchedToken = scanner.consume();
    return Strike(matchedToken.sublist(2, matchedToken.length - 2));
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}

class Bold extends InlineNode {
  static RegExp pattern = new RegExp(r'(?<!\*)\*\*(.+?)\*\*(?!\*)');

  Bold(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }

  static InlineNode parse(Scanner scanner) {
    final matchedToken = scanner.consume();
    return Bold(matchedToken.sublist(2, matchedToken.length - 2));
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}

class Underline extends InlineNode {
  static RegExp pattern = new RegExp(r'(?<!_)__(.+?)__(?!_)');

  Underline(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }

  static InlineNode parse(Scanner scanner) {
    final matchedToken = scanner.consume();
    return Underline(matchedToken.sublist(2, matchedToken.length - 2));
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}

class Italics extends InlineNode {
  static RegExp pattern = new RegExp(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)');
  static RegExp pattern0 = new RegExp(r'(?<!_)_(?!_)(.+?)(?<!_)_(?!_)');

  Italics(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }

  static InlineNode parse(Scanner scanner) {
    final matchedToken = scanner.consume();
    return Italics(matchedToken.sublist(1, matchedToken.length - 1));
  }

  static Match match(Scanner scanner) {
    Match m = scanner.match(pattern);
    return m ?? scanner.match(pattern0);
  }
}

// user mention: <@123>
// role mention: <&123>
// channel mention: <#123>
// custom emoji: <!123>

class UserMention extends InlineNode {
  static RegExp pattern = new RegExp(r'\<@!a\>');
  UserMention(String con,bool isSel) {
    hasChild = false;
    content = con;
    isSelf = isSel;
  }
  static Match match(Scanner scanner) {
    var m = scanner.match(pattern);
    if (m == null) {
      return null;
    } else {
      String str = scanner.tokenList()[m.start + 3].content();
      final isdigit = InlineNode.isNumeric(str);
      if (isdigit) {
        return m;
      }
      return null;
    }
  }

  static InlineNode parse(Scanner scanner,Map<String,dynamic>callMap) {
    final matchedToken = scanner.consume();
    String cont = matchedToken[3].content();
    // if (callMap != null && callMap.containsKey(cont)) {
    //   Author author = callMap[cont];
    //   String key = (author == null || author.userId == 0 || author.username.isEmpty ? cont : author.username);
    //   bool isS = author != null && UserInfoUtil.instance.userId != null && author.userId == UserInfoUtil.instance.userId;
    //   return UserMention('@${key == null || key.isEmpty ? cont : key}',isS);
    // }
    //匹配不上id，就原样展示成RawText
    return RawText('<@!$cont>');
  }
}

class RoleMention extends InlineNode {
  static RegExp pattern = new RegExp(r'\<@&a\>');
  RoleMention(String con,colors,isS) {
    hasChild = false;
    content = con;
    color = colors;
    isSelf = isS;
  }

  static Match match(Scanner scanner) {
    var m = scanner.match(pattern);
    if (m == null) {
      return null;
    } else {
      final isdigit =
          InlineNode.isNumeric(scanner.tokenList()[m.start + 3].content());
      if (isdigit) {
        return m;
      }
      return null;
    }
  }

  static InlineNode parse(Scanner scanner,Map<String,dynamic>callMap) {
    final matchedToken = scanner.consume();
    String cont = matchedToken[3].content();
    // if (callMap != null && callMap.containsKey(cont)) {
    //   Roles role = callMap[cont];
    //   String key = (role == null || role.name == null ? cont : role.name);
    //   String colo = (role == null || role.color == null ? '' : role.color); 
    //   bool isConS = CurrentServerRolesPermissionDataManager().userRolesId.contains(int.parse(cont));
    //   return RoleMention('@${key == null || key.isEmpty ? cont : key}',colo,isConS);
    // }
    
    //匹配不上id，就原样展示成RawText
    return RawText('<@\$$cont>');
  }
}

class ChannelMention extends InlineNode {
  static RegExp pattern = new RegExp(r'\<#a\>');

  ChannelMention(String con,{colors,channelId}) {
    hasChild = false;
    content = con;
    color = colors;
    keyId = channelId;
  }

  static Match match(Scanner scanner) {
    var m = scanner.match(pattern);
    if (m == null) {
      return null;
    } else {
      final isdigit =
          InlineNode.isNumeric(scanner.tokenList()[m.start + 2].content());
      if (isdigit) {
        return m;
      }
      return null;
    }
  }

  static InlineNode parse(Scanner scanner,Map<String,dynamic>callMap) {
    final matchedToken = scanner.consume();
    String cont = matchedToken[2].content();
    // //匹配不上id，就原样展示成RawText
    // return RawText('<@!$cont>');

    // if (callMap != null && callMap.containsKey(cont)) {
    //    Channel channel = callMap[cont];
    //   String key = (channel == null || channel.channelId == 0 || channel.name.isEmpty ? cont : channel.name);
    //   return ChannelMention('#${key == null || key.isEmpty ? cont : key}',channelId: channel.channelId);
    // }
    //匹配不上id，就原样展示成RawText
    return RawText('<#$cont>');
  }
}

class CustomEmoji extends InlineNode {
  static RegExp pattern = new RegExp(r'\<!a\>');

  CustomEmoji(String con) {
    content = con;
  }

  static Match match(Scanner scanner) {
    var m = scanner.match(pattern);
    if (m == null) {
      return null;
    } else {
      final isdigit =
          InlineNode.isNumeric(scanner.tokenList()[m.start + 2].content());
      if (isdigit) {
        return m;
      }
      return null;
    }
  }

  static InlineNode parse(Scanner scanner) {
    final matchedToken = scanner.consume();
    return CustomEmoji(matchedToken[2].content());
  }
}

class RawText extends InlineNode {
  static RegExp pattern = new RegExp(r'(a|«)+');
  RawText(String text) {
    content = text;
  }

  void merge(other) {
    if (other is RawText) {
      content += other.content;
    }
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}
