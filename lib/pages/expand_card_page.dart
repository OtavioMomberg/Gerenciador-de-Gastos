import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/action_expense_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/confirmation_dialog.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/widgets/text_button_colored.dart';

class ExpandCardPage extends StatefulWidget {
  final int index;

  const ExpandCardPage({
    required this.index, 
    super.key
  });

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
        backgroundColor: AppThemes.color3,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Detalhes do Gasto",
          style: AppThemes.textStyle
        ),
        foregroundColor: AppThemes.color4
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        padding: const EdgeInsets.all(10),
        color: AppThemes.color3,
        child: Column(
          spacing: 10,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              _db.expensesWithoutFuture[widget.index].name,
              style: TextStyle(
                color: AppThemes.color4,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            Flexible(
              child: Material(
                borderRadius: AppThemes.borderRadius,
                color: AppThemes.color1,
                elevation: 10,
                shadowColor: AppThemes.color1,
                child: Container(
                  height: size.height * 0.5,
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: AppThemes.borderRadius,
                    color: AppThemes.color1
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: <Widget>[
                        Text(
                          "Preço: R\$ ${_db.expensesWithoutFuture[widget.index].price}",
                          style: AppThemes.textStyle
                        ),
                        const Divider(color: AppThemes.color4),
                        const SizedBox(height: 10),
                        Text(
                          "Forma de pagamento: ${_db.expensesWithoutFuture[widget.index].paymentMethod}",
                          style: AppThemes.textStyle
                        ),
                        const Divider(color: AppThemes.color4),
                        const SizedBox(height: 10),
                        if (_db.expensesWithoutFuture[widget.index].paymentMethod == "Crédito") ...[
                          Text(
                            "Parcelas: ${_db.expensesWithoutFuture[widget.index].installments}",
                            style: AppThemes.textStyle
                          ),
                          const Divider(color: AppThemes.color4),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          "Data de vencimento: ${_db.expensesWithoutFuture[widget.index].date}",
                          style: AppThemes.textStyle
                        )
                      ]
                    )
                  )
                )
              )
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Row(
                mainAxisAlignment: .center,
                children: <Widget>[
                  Expanded(
                    child: TextButtonColored(
                      icon: Icons.edit, 
                      color: AppThemes.color4, 
                      label: "Editar", 
                      function: () => goNextPage(
                        context: context, 
                        index: widget.index, 
                        page: ActionExpensePage(
                          action: ActionsEnum.update,
                          expenseData: _db.expensesWithoutFuture[widget.index],
                        ),
                        thenFunction: thenFunction
                      )
                    )
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButtonColored(
                      icon: Icons.delete, 
                      color: AppThemes.color2, 
                      label: "Deletar", 
                      function: () async {
                        final response = await confirmDialog(
                          context: context,
                          title: "🚨  Atenção  🚨",
                          content: "Tem certeza que deseja apagar esse gasto?",
                        );
                        if (response) {
                          await _db.deleteExpense(
                            expenseID: _db.expensesWithoutFuture[widget.index].id,
                          );
                          showSnackBar();
                        }
                      }
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

  void thenFunction({bool? response}) async {
    if (response != null && response) {
      await _db.selectExpensesByGroup(groupID: _db.expensesWithoutFuture[widget.index].groupID);
      if (!mounted) { return; }
      setState(() {});
    }
  }

  void showSnackBar() {
    if (!mounted) { return; }
    
    showColoredSnackBar(
      context: context,
      msm: "Gasto removido com sucesso!",
      txtColor: AppThemes.color1,
    );
    Navigator.pop<bool?>(context, true);
  }
}
