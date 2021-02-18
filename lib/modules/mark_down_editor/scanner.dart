import 'dart:core';

const Set<String> KINDS = {
  'a',
  '¬',
  '>',
  '<',
  '@',
  '&',
  '#',
  '!',
  '~',
  '_',
  '*',
  '`',
  '|',
  '«',
};
const Set<String> SYMBOLS = {
  '¬',
  '>',
  '<',
  '@',
  '&',
  '#',
  '!',
  '~',
  '_',
  '*',
  '`',
  '|',
  '«',
};

class Token {
  var _kind = '';
  var _content = '';

  Token(String kind, {String text = ''}) {
    if (KINDS.contains(kind)) {
      _kind = kind;
      if (kind == '«') {
        _content = '\n';
      } else  if (kind == '¬') {
        _content = ' ';
      } else if (kind == 'a') {
        _content = text;
      } else {
        _content = kind;
      }
    }
  }

  bool isNewline() {
    return _kind == '«';
  }

  bool isWhiteSpace() {
    return _kind == '¬';
  }

  String kind() {
    return _kind;
  }

  String content() {
    return _content;
  }
}

class Scanner {
  RegExp pattern = RegExp(r'([^«]*?)(«|$)');
  var _tokenlist = List<Token>();
  var _kindlist = '';
  var _pos = 0;
  Match _match;

  Scanner(List<Token> tokenList) {
    _tokenlist = tokenList;
    var getKindList = '';
    for (var item in tokenList) {
      getKindList += item.kind();
    }
    _kindlist = getKindList;
    _pos = 0;
    _match = null;
  }

  List<Token> tokenList() {
    return _tokenlist;
  }

  String kindList() {
    return _kindlist;
  }

  int pos() {
    return _pos;
  }

  static Scanner tokenize(String text) {
    var rect = List<Token>();
    var content = '';
    var normText = text
        .replaceAll("\r\n", "«")
        .replaceAll("\n", "«")
        .replaceAll("\r", "«")
        .replaceAll(' ', '¬');

    for (var i = 0; i < normText.length; i++) {
      final str = normText[i];
      if (SYMBOLS.contains(str)) {
        if (content.isNotEmpty) {
           seperateRawTextTokenToTokens(rect,content);
          content = '';
        }
        rect.add(Token(str));
      } else {
        content += str;
      }
    }
    if (content.isNotEmpty) {
       seperateRawTextTokenToTokens(rect,content);
    }
    return Scanner(rect);
  }

//通过下列方法 把rawText以https://的开始位置为界再次分割成多个Token
  static seperateRawTextTokenToTokens(rect,content)
  {
    if (content.length >= 12) {//链接最短的数字 提高分割效率
            RegExp pattern = new RegExp(r'(http[s]?|ftp|news)://');
            Iterable<RegExpMatch> ms = pattern.allMatches(content);
            if (ms.isNotEmpty){
              var stars = [0];
              for (var m in ms) {
                stars.add(m.start);
              }
              stars.add(content.length);
              var i = 0;
              while (i < stars.length-1) {
                String sub = content.substring(stars[i],stars[i+1]);
                rect.add(Token('a', text: sub));
                 i += 1;
              }
            }else{
              rect.add(Token('a', text: content));
            }
         }else{
          rect.add(Token('a', text: content));
         }
  }



  Match match(RegExp pat) {
    _match = pat.matchAsPrefix(_kindlist, _pos);
    return _match;
  }

  bool exhausted() {
    return _pos >= _kindlist.length;
  }

  List<Token> nextLine() {
    var m = pattern.matchAsPrefix(_kindlist, _pos);
    _match = m;
    if (m == null) {
      return [];
    }
    return consume();
  }

  List<Token> consume() {
    final m = _match;
    if (m != null) {
      //与沈阿姨不一样的地方，如果为空直接抛出异常
      _pos = m.end;
      return _tokenlist.sublist(m.start, m.end);
    } else {
      print("consume处报错了");
      return [];
    }
  }

  Token consumeOneToken() {
    if (!exhausted()) {
      final ret = _tokenlist[_pos];
      _pos += 1;
      return ret;
    } else {
      print("exhausted处报错了");
      return null;
    }
  }

  void reset() {
    _pos = 0;
    _match = null;
  }
}
