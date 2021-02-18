import 'scanner.dart';

class BlockNode {
  static RegExp pattern = new RegExp(r'');
  var hasChild = false; //表示这个节点是否可能有子节点
  var content = ''; //此节点的文本内容
  var tokenList = List<Token>(); //组成此节点的Token列表
  List children = List<dynamic>(); //此节点的Token列表
  var _scanned = false; //此节点下的token列表是否被扫描过

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }

  Scanner toScanner() {
    if (tokenList.length > 0 && !_scanned) {
      _scanned = true;
      return Scanner(tokenList);
    } else {
      return null;
    }
  }
}

class Document extends BlockNode {
  Document(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }
}

class BlankLine extends BlockNode {
  static RegExp pattern = new RegExp(r'«');

  BlockNode parse(Scanner scanner) {
    scanner.consume();
    return BlankLine();
  }

  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }
}

class Paragraph extends BlockNode {
  Paragraph(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }
  static BlockNode parse(Scanner scanner) {
    final matchedTokens = scanner.consume();
    return new Paragraph(matchedTokens);
  }

  bool empty() {
    return tokenList.length == 0;
  }

  merge(other) {
    if (other is Paragraph) {
      tokenList.addAll(other.tokenList);
    }
  }
}

class FencedCode extends BlockNode {
  static RegExp pattern = new RegExp(r'(?<!`)```(?!`)(.*?)(?<!`)```(?!`)(«?)');
  // ignore: non_constant_identifier_names
  static Set<String> LANGS = {
    'asciidoc',
    'autohotkey',
    'bash',
    'c++',
    'css',
    'html',
    'ini',
    'json',
    'markdown',
    'dart',
    'tex',
    'xml'
  };
  String langs;

  FencedCode(String lgs, String con) {
    langs = lgs;
    content = con;
  }
  static Match match(Scanner scanner) {
    return scanner.match(pattern);
  }

  static BlockNode parse(Scanner scanner) {
    var matchedTokens = scanner.consume();
    if (matchedTokens.last.isNewline()) {
      matchedTokens = matchedTokens.sublist(3, matchedTokens.length - 4);
    } else {
      matchedTokens = matchedTokens.sublist(3, matchedTokens.length - 3);
    }

    final firstToken = matchedTokens[0];
    var langs = '';
    var content = '';
    if (!firstToken.isNewline() && LANGS.contains(firstToken)) {
      langs = firstToken.content();
      for (var i = 1; i < matchedTokens.length; i++) {
        content += matchedTokens[i].content();
      }
    } else {
      for (var i = 0; i < matchedTokens.length; i++) {
        content += matchedTokens[i].content();
      }
    }
    return FencedCode(langs.trim(), content);
  }
}

class Quote extends BlockNode {
  static RegExp pattern = new RegExp(r'>(?!$)');

  Quote(List<Token> tokenlist) {
    hasChild = true;
    tokenList = tokenlist;
  }

  static Match match(Scanner scanner) {
    final m = scanner.match(pattern);
    if (m == null) {
      return null;
    }
    //判断是否为行首
    final getTokenList = scanner.tokenList();
    if (scanner.pos() != 0 && !getTokenList[m.start - 1].isNewline()) {
      return null;
    }
    //判断下一个token是否以空格开头
    if (scanner.exhausted()) {
      return null;
    }
    final nextToken = scanner.tokenList()[m.start + 1];
    if (!nextToken.content().startsWith(' ')) {
      return null;
    }
    return m;
  }

  static BlockNode parse(Scanner scanner) {
    var matchedTokens = scanner.consume();
    if (matchedTokens.length == 1 && matchedTokens[0].kind() == '>') {
      return Quote(scanner.nextLine());
    } else {
      return null;
    }
  }

  merge(other) {
    if (other is Quote) {
      tokenList += other.tokenList;
    }
  }

  //在第一个文本Node里插入回复 @xxx 

  //移除最后一个/n
  removeLastNextLine() {
    if (children.isNotEmpty) {
      var last = children.last;
      while (last.children.isNotEmpty) {
        last = last.children.last;
      }
      RegExp pattern0 = new RegExp(r'([.\S\s]*?)\n$',multiLine:true);
      Match m = pattern0.firstMatch(last.content);
      
      last.content = m == null ? last.content : last.content.substring(0,last.content.length-1);
     }
  }
}
