class ExpansibleVariables {
  static final _instance = ExpansibleVariables._();
  ExpansibleVariables._();
  factory ExpansibleVariables.instance() => _instance;

  String groupName = "Insira o nome de um grupo";
  String groupDate = "Insira a data de vencimento";
  String groupPayment = "Escolha o método de pagamento";

  final List<int> days = List.unmodifiable(
    List.generate(31, (index) => index + 1),
  );
  final List<int> months = List.unmodifiable(
    List.generate(12, (index) => index + 1),
  );

  final List<int> years = [];

  void buildYear({required int currentYear}) {
    if (years.isNotEmpty) { return; }

    currentYear-=1;
    years.addAll(List.generate(30, (index) => currentYear += 1));
  }
}
