import 'package:gerenciador_gastos_v2/database/db_columns_info.dart';

class ExpenseRead {
  final int id;
  final String name;
  final String price;
  final String paymentMethod;
  final String date;
  final int? installments;
  final int groupID;

  const ExpenseRead({
    required this.id,
    required this.name,
    required this.price, 
    required this.paymentMethod,
    required this.date,
    this.installments = 1,
    required this.groupID
  });

  factory ExpenseRead.fromMap({required Map<String, dynamic> map}) {
    return ExpenseRead(
      id: map[DbColumnsInfo.idExpenseTable] as int, 
      name: map[DbColumnsInfo.nameExpenseTable] as String, 
      price: map[DbColumnsInfo.priceExpenseTable] as String, 
      paymentMethod: map[DbColumnsInfo.paymentMethodExpenseTable] as String, 
      date: map[DbColumnsInfo.dateExpenseTable] as String, 
      installments: map[DbColumnsInfo.installmentExpenseTable] as int,
      groupID: map[DbColumnsInfo.groupIdExpenseTable] as int
    );
  }

  double? get priceAsDouble => double.tryParse(price);
}