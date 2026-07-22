import 'dart:ui';
import 'package:gerenciador_gastos_v2/services/database_service.dart';

class GroupService {
  bool isExpenseSelected = false;
  List<int> indexList = [];
  List<bool> checkColor = List.generate(
    DatabaseService.instance().expenses.length, 
    (index) => false
  );
  int? cardIndex;

  final List<Color> colors = [
    const Color.fromARGB(255, 210, 232, 236),
    const Color.fromARGB(255, 255, 140, 132)
  ];

  static final _instance = GroupService._();
  GroupService._();
  factory GroupService.instance() => _instance;
}