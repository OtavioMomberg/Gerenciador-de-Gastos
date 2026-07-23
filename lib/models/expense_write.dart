const Map<int, int> daysInMonth = {
  1: 31, 
  2: 28,  
  3: 31,  
  4: 30,  
  5: 31, 
  6: 30,  
  7: 31, 
  8: 31,  
  9: 30, 
  10: 31, 
  11: 30, 
  12: 31
};

class ExpenseWrite {
  final String name;
  String price;
  final String paymentMethod;
  String date;
  int? installments;
  final int groupID;

  ExpenseWrite({
    required this.name,
    required this.price, 
    required this.paymentMethod,
    required this.date,
    this.installments = 1,
    required this.groupID
  });

  void decreaseInstallment() {
    if (installments != null) {
      installments = installments! - 1;
    }
  }

  void increaseMonth({required int day}) {
    int num = 0;
    int maxDays = 0;

    if (date[3] == "0") {
      num = int.parse(date[4]) + 1;
      maxDays = daysInMonth[num]!;

      if (day >= maxDays) {
        date = date.replaceRange(0, 2, maxDays.toString());
      }

      if (num == 10) {
        date = date.replaceRange(3, 5, (num).toString());
        return;
      } else {
        date = "${date.substring(0, 4)}$num${date.substring(5, 10)}";
        return;
      }
    }

    num = int.parse(date.substring(3, 5)) + 1;
    if (num <= 12) {
      maxDays = daysInMonth[num]!;
      if (day >= maxDays) {
        date = date.replaceRange(0, 2, maxDays.toString());
      }

      date = date.replaceRange(3, 5, num.toString());
      return;
    }
    maxDays = daysInMonth[1]!;
    if (day >= maxDays) {
      date = date.replaceRange(0, 2, maxDays.toString());
    }

    int year = int.parse(date.substring(6, 10)) + 1;
    date = "${date.substring(0, 3)}01/$year";
  }
}