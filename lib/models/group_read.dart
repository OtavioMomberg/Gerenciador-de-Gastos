import 'package:gerenciador_gastos_v2/database/db_columns_info.dart';

class GroupRead {
  final int id;
  final String name;
  final String color;

  const GroupRead({
    required this.id,
    required this.name,
    required this.color
  });

  factory GroupRead.fromMap({required Map<String, dynamic> map}) {
    return GroupRead(
      id: map[DbColumnsInfo.idGroupTable] as int, 
      name: map[DbColumnsInfo.nameGroupTable] as String, 
      color: map[DbColumnsInfo.colorGroupTable] as String
    );
  }
}