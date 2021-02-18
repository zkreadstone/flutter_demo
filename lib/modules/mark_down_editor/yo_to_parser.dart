import 'block_node.dart';
import 'in_line_node.dart';
import 'scanner.dart';

class NodeList {
  var isBlock = true;
  List nodeList;
  //var nodeList = List<Node>();

  NodeList({bool isblock = true}) {
    isBlock = isblock;
    nodeList = List();
  }

  void append(node, classType) {
    if ((isBlock && classType == BlockNode) ||
        (!isBlock && classType == InlineNode)) {
      if (nodeList.length == 0 ||
          (nodeList.length > 0 && 
              (nodeList.last.toString() != node.toString() || (node is UserMention || node is ChannelMention || node is RoleMention)))) {
        nodeList.add(node);
        return;
      }
      if (node is Paragraph || node is Quote || node is RawText) {
        var getNode = nodeList.last;
        if (getNode is Paragraph) {
          getNode.merge(node);
        } else if (getNode is Quote) {
          getNode.merge(node);
        } else if (getNode is RawText) {
          getNode.merge(node);
        }
      }
    }
  }

  List<dynamic> toList() {
    return nodeList;
  }
}

class Parser {
  final outBlockNodeTypes = [FencedCode, Quote];
  final innerBlockNodeTypes = [FencedCode];
  List inlineNodeTypes = [
    UserMention,
    RoleMention,
    ChannelMention,
    Hidden,
    CodeSpan,
    Url,
    Strike,
    Bold,
    Underline,
    Italics,
    CustomEmoji,
  ];
  var callMaps;
  List<String> urls = List<String>();
  String contentStr = '';
  Document parseScanner(Scanner scanners) {
    urls.clear();
    contentStr = '';
    // callMaps = callMap;
    //先将文本分块为BlockNode: FencedCode, Quote, Paragraph.
    var root = Document(scanners.tokenList());
    root.children = parseBlock(root, outBlockNodeTypes);

    // 再将第二级的BlockNode进一步分块为BlockNode: FencedCode, Paragraph.
    for (var node in root.children) {
      if (node.hasChild) {
        node.children = parseBlock(node, innerBlockNodeTypes);
      }
    }
    //  经过两遍解析, 已不可能再分解出新的BlockNode了
    //  将BlockNode进一步拆分为InlineNode
    for (var node in root.children) {
      if (node.hasChild) {
        for (var subNode in node.children) {
          if (subNode is Paragraph) {
            subNode.children = parseInline(subNode,isQuote: node.runtimeType.toString() == 'Quote');
          }
        }
      } else {
        if (node is Paragraph) {
          node.children = parseInline(node);
        }
      }
    }
    return root;
  }

  List<dynamic> parseBlock(BlockNode node, List nodeTypes) {
    // 递归的分解BlockNode到BlockNode
    // :param node:
    // :return:
    var scanner = node.toScanner();
    var children = NodeList(isblock: true);

    while (!scanner.exhausted()) {
      var isBreak = false;
      for (var nodeType in nodeTypes) {
        if (nodeType.toString() == 'FencedCode') {
          if (FencedCode.match(scanner) != null) {
            var getNode = FencedCode.parse(scanner);
            children.append(getNode, BlockNode);
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'Quote') {
          if (Quote.match(scanner) != null) {
            var getNode = Quote.parse(scanner);
            children.append(getNode, BlockNode);
            isBreak = true;
            break;
          }
        }
      }
      if (!isBreak) {
        Token oneToken = scanner.consumeOneToken();
        var getNode = Paragraph([oneToken]);
        children.append(getNode, BlockNode);
      }
    }
    return children.toList();
  }
  //isQuote 参数为了统计富文本里的url 引用里的只识别不预览
  List<dynamic> parseInline(node,{bool isQuote = false}) {
    // 将一个BlockNode分解为一组InlineNode
    // :param node:
    // :return:
    Scanner scanner = node.toScanner();
    var children = NodeList(isblock: false);
    var inLineNodes;

    while (!scanner.exhausted()) {
      var isBreak = false;
      for (var nodeType in inlineNodeTypes) {
        if (nodeType.toString() == 'Hidden') {
          if (Hidden.match(scanner) != null) {
            inLineNodes = Hidden.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'CodeSpan') {
          if (CodeSpan.match(scanner) != null) {
            inLineNodes = CodeSpan.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'Url') {
          if (Url.match(scanner) != null) {
            inLineNodes = Url.parse(scanner);
            if (!isQuote) {
              urls.add(inLineNodes.content);
            }
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'Strike') {
          if (Strike.match(scanner) != null) {
            inLineNodes = Strike.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'Bold') {
          if (Bold.match(scanner) != null) {
            inLineNodes = Bold.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'Underline') {
          if (Underline.match(scanner) != null) {
            inLineNodes = Underline.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'Italics') {
          if (Italics.match(scanner) != null) {
            inLineNodes = Italics.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'UserMention' && callMaps != null && callMaps.keys.length > 0) {
          if (UserMention.match(scanner) != null) {
            inLineNodes = UserMention.parse(scanner,callMaps);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'RoleMention' && callMaps != null && callMaps.keys.length > 0) {
          if (RoleMention.match(scanner) != null) {
            inLineNodes = RoleMention.parse(scanner,callMaps);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'ChannelMention' && callMaps != null && callMaps.keys.length > 0) {
          if (ChannelMention.match(scanner) != null) {
            inLineNodes = ChannelMention.parse(scanner,callMaps);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
        if (nodeType.toString() == 'CustomEmoji') {
          if (CustomEmoji.match(scanner) != null) {
            inLineNodes = CustomEmoji.parse(scanner);
            if (inLineNodes.hasChild) {
              inLineNodes.children = parseInline(inLineNodes,isQuote: isQuote);
            }
            isBreak = true;
            break;
          }
        }
      }
      if (!isBreak) {
        isBreak = false;
        final content = scanner.consumeOneToken().content();
        inLineNodes = RawText(content);
      }
      contentStr += inLineNodes.content;
      children.append(inLineNodes, InlineNode);
    }
    return children.toList();
  }
}
