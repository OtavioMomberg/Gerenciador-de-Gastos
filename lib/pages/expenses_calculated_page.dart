import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/widgets/general_info_card.dart';

class ExpensesCalculatedPage extends StatelessWidget {
  final String groupName;
  final String paymentMethod;
  final List<ExpenseRead> expenses;

  const ExpensesCalculatedPage({
    required this.groupName,
    required this.paymentMethod,
    required this.expenses,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        foregroundColor: const Color.fromARGB(255, 136, 136, 136),
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 234, 242, 252),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 234, 242, 252),
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: <Widget>[
            const Text(
              "Informaçoes Gerais",
              style: TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 10),
            GeneralInfoCard(
              infoList: [
                "\nNome do Grupo: $groupName\n",
                "\nMétodo de Pagamento: $paymentMethod\n",
                "\nQuantidade de Gastos: ${expenses.length}\n"
              ]
            ),
            const SizedBox(height: 10),
            const Text(
              "Gastos",
              style: TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      color: const Color.fromARGB(255, 234, 242, 252),
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            width: 2,
                            color: const Color.fromARGB(255, 210, 232, 236)
                          )
                        ),
                        title: Text(
                          "${expenses[index].name}      R\$ ${expenses[index].price}",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 136, 136, 136),
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                    ),
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}
