class ExpenseWrite {
  final String name;
  final String price;
  final String paymentMethod;
  final String date;
  final int groupID;

  const ExpenseWrite({
    required this.name,
    required this.price, 
    required this.paymentMethod,
    required this.date,
    required this.groupID
  });
}