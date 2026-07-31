class GroupService {
  bool _isExpenseSelected = false;
  int? _cardIndex;
  final List<int> _indexList = [];

  static final _instance = GroupService._();
  GroupService._();
  factory GroupService.instance() => _instance;

  bool get isExpenseSelected => _isExpenseSelected;
  int? get cardIndex => _cardIndex;
  List<int> get indexList => _indexList;

  void updateIsExpenseSelected() => _isExpenseSelected = !_isExpenseSelected;

  bool? checkCardIndex({required int index}) {
    if (_cardIndex == index && _indexList.length > 1) {
      return false;
    }
    if (_cardIndex == index && _indexList.length == 1) {
      _isExpenseSelected = !_isExpenseSelected;
      _indexList.clear();
      return true;
    }
    return null;
  }

  void checkIndexList({required int index}) {
    if (_indexList.contains(index)) {
      _indexList.remove(index);
    } else {
      _indexList.add(index);
    }
  }

  bool checkOnLongPressIndexList({required int index}) {
    if (_indexList.isNotEmpty) {
      if (!_indexList.contains(index)) {
        return false;
      }
    }
    return true;
  }

  void updateOnLongPressValues({required int index}) {
    _cardIndex = index;
    _isExpenseSelected = !_isExpenseSelected;
  }

  void checkExpenseSelected({required int index}) {
    if (_isExpenseSelected) {
      _indexList.add(index);
    } else {
      _indexList.clear();
    }
  }
}
