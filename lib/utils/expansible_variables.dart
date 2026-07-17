enum ListOption { days, months, years }

enum PaymentOptions { debito, credito, pix }

class ExpansibleVariables {
  static final _instance = ExpansibleVariables._();
  ExpansibleVariables._();
  factory ExpansibleVariables.instance() => _instance;

  static const String name = "Nome do grupo:";
  static const String date = "Data de vencimento:";
  static const String payment = "Método de pagamento:";

  String groupName = name;
  String groupDate = date;
  String groupPayment = payment;

  final List<String> paymentMethods = List.unmodifiable(["Débito", "Crédito", "PIX"]);

  final List<int> days = List.unmodifiable(List.generate(31, (index) => index + 1));

  final List<int> months = List.unmodifiable(List.generate(12, (index) => index + 1));

  final int yearsQuantity = 30;

  final List<int> years = [];

  void buildYear({required int currentYear}) {
    if (years.isNotEmpty) { return; }

    currentYear-=1;
    years.addAll(List.generate(yearsQuantity, (index) => currentYear += 1));
  }

  static const int emptySize = 10;

  final String emptyStr = " " * emptySize;

  bool checkDateStr() {
    if (groupDate.length == 10 && !groupDate.contains(" ")) {
      return true;
    }
    return false;
  }

  List<int> getList({required ListOption option}) {
    switch (option) {
      case ListOption.days:
        return days;
      case ListOption.months:
        return months;
      case ListOption.years:
        return years;
    }
  }
}
