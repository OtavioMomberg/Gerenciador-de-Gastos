import 'dart:ui';

class GroupService {
  bool isExpenseSelected = false;
  int? cardIndex;
  List<int> indexList = [];

  final List<Color> colors = [
    const Color.fromARGB(255, 210, 232, 236),
    const Color.fromARGB(255, 255, 140, 132)
  ];

  static final _instance = GroupService._();
  GroupService._();
  factory GroupService.instance() => _instance;
}