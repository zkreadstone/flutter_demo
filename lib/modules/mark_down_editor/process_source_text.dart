import 'process_source_model.dart';

class ProcessSourceText {
  String _sourceText;
  List<Channel> _matchList;

  ProcessSourceText(String sourcetext, List<dynamic> matchedList) {
    _sourceText = sourcetext;
    _matchList = List<Channel>();
    for (final item in matchedList) {
      Channel contentItem = Channel();
      if (item.runtimeType.toString() == "Author") {
        contentItem.id = item.userId;
        contentItem.name = item.username;
        contentItem.avatar = item.avatar;
        contentItem.sourceType = SourceType.user;
      }
      //modType;//数据类型 0 user  1role  2channel
      if (item.runtimeType.toString() == "AtSearchModel") {
        contentItem.id = item.id;
        contentItem.name = item.name;
        contentItem.sourceType = item.modType == 0
            ? SourceType.user
            : (item.modType == 1 ? SourceType.role : SourceType.channel);
      }
      // if (item.runtimeType.toString() == "Datum") {
      //   contentItem.id = item.id;
      //   contentItem.name = item.name;
      //   contentItem.sourceType = SourceType.channel;
      // }
      // if (item.runtimeType.toString() == "Role") {
      //   contentItem.id = item.id;
      //   contentItem.name = item.name;
      //   contentItem.sourceType = SourceType.role;
      // }
      _matchList.add(contentItem);
    }
    _matchList.sort((left, right) => right.name.compareTo(left.name));
    print('');
  }

  String outPutText() {
    //获取转译后的字符串
    if (_matchList.length <= 0) {
      return _sourceText;
    }
    var outPutTextStr = _sourceText;
    for (var item in _matchList) {
      //遍历是否存在用户
      if (outPutTextStr.contains(item.name)) {
        String placeStr = (item.sourceType == SourceType.user)
            ? '<@!${item.id}>'
            : ((item.sourceType == SourceType.role)
                ? '<@&${item.id}>'
                : '<#${item.id}>');
        String fromStr = (item.sourceType == SourceType.user)
            ? '@${item.name}'
            : ((item.sourceType == SourceType.role)
                ? '@${item.name}'
                : '#${item.name}');
        outPutTextStr = outPutTextStr.replaceFirst(fromStr, placeStr);
        print("");
      }
    }
    return outPutTextStr;
  }
}
