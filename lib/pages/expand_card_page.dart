import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/action_expense_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/confirmation_dialog.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_snackbar.dart';

class ExpandCardPage extends StatefulWidget {
  final int index;

  const ExpandCardPage({required this.index, super.key});

  @override
  State<ExpandCardPage> createState() => _ExpandCardPageState();
}

class _ExpandCardPageState extends State<ExpandCardPage> 
with ConfirmationDialog, ShowColoredSnackBar, ChangePage {
  final _db = DatabaseService.instance();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Detalhes do Gasto",
          style: TextStyle(
            color: Color.fromARGB(255, 136, 136, 136),
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Color.fromARGB(255, 136, 136, 136),
      ),
      backgroundColor: const Color.fromARGB(255, 234, 242, 252),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 234, 242, 252),
        child: Column(
          spacing: 10,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              _db.expenses[widget.index].name,
              style: TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Container(
                height: size.height * 0.5,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 136, 136, 136),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: <Widget>[
                      Text(
                        "Preço: R\$ ${_db.expenses[widget.index].price}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 136, 136, 136),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        "Forma de pagamento: ${_db.expenses[widget.index].paymentMethod}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 136, 136, 136),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      if (_db.expenses[widget.index].paymentMethod ==
                          "Crédito") ...[
                        Text(
                          "Parcelas: ${_db.expenses[widget.index].installments}",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 136, 136, 136),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                      ],
                      Text(
                        "Data de vencimento: ${_db.expenses[widget.index].date}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 136, 136, 136),
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  )
                )
              )
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: .center,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      goNextPage(
                        context: context, 
                        index: widget.index, 
                        page: ActionExpensePage(
                          action: ActionsEnum.update,
                          expenseData: _db.expenses[widget.index],
                        )
                      );
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 136, 136, 136),
                          ),
                        ),
                      ),
                    ),
                    label: const Text(
                      "Editar",
                      style: TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                      ),
                    ),
                    icon: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 136, 136, 136),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: () async {
                      final response = await confirmDialog(
                        context: context,
                        title: "🚨  Atenção  🚨",
                        content: "Tem certeza que deseja apagar esse gasto?",
                      );
                      if (response) {
                        await _db.deleteExpense(
                          expenseID: _db.expenses[widget.index].id,
                        );
                        showSnackBar();
                      }
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 255, 140, 132),
                          ),
                        ),
                      ),
                    ),
                    label: const Text(
                      "Deletar",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 140, 132),
                      ),
                    ),
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 140, 132)
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }

  void showSnackBar() {
    if (!mounted) { return; }
    
    showColoredSnackBar(
      context: context,
      msm: "Gasto removido com sucesso!",
      txtColor: const Color.fromARGB(255, 210, 232, 236),
    );
    Navigator.pop<bool?>(context, true);
  }
}
