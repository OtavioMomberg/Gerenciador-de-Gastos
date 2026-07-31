import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
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
        backgroundColor: AppThemes.color3,
        foregroundColor: AppThemes.color4,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppThemes.color3,
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: <Widget>[
            const Text(
              "Informaçoes Gerais",
              style: TextStyle(
                color: AppThemes.color4,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 10),
            GeneralInfoCard(
              infoList: <String>[
                "\nNome do Grupo: $groupName\n",
                "\nMétodo de Pagamento: $paymentMethod\n",
                "\nQuantidade de Gastos: ${expenses.length}\n"
              ]
            ),
            const SizedBox(height: 10),
            const Text(
              "Gastos",
              style: TextStyle(
                color: AppThemes.color4,
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
                      color: AppThemes.color3,
                      borderRadius: AppThemes.borderRadius,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: AppThemes.borderRadius,
                          side: BorderSide(
                            width: 2,
                            color: AppThemes.color1
                          )
                        ),
                        title: Text(
                          "${expenses[index].name}      R\$ ${expenses[index].price}\n\nData de Validade: ${expenses[index].date}",
                          style: AppThemes.textStyle
                        )
                      )
                    )
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
