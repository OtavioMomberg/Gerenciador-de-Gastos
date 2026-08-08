import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerenciador_gastos_v2/core/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/presentation/pages/action_expense_page.dart';
import 'package:gerenciador_gastos_v2/controllers/database_controller.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/confirmation_dialog.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/text_button_colored.dart';

class ExpandCardPage extends StatefulWidget {
  final int index;
  final DatabaseController db;

  const ExpandCardPage({
    required this.index, 
    required this.db,
    super.key
  });

  @override
  State<ExpandCardPage> createState() => _ExpandCardPageState();
}

class _ExpandCardPageState extends State<ExpandCardPage>
    with ConfirmationDialog, ShowColoredSnackBar, ChangePage {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.color3,
        surfaceTintColor: Colors.transparent,
        title: const Text("Detalhes do Gasto", style: AppThemes.textStyle),
        foregroundColor: AppThemes.color4,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarColor: AppThemes.color3,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        padding: const EdgeInsets.all(10),
        color: AppThemes.color3,
        child: SafeArea(
          top: false,
          child: Column(
            spacing: 10,
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                widget.db.expensesWithoutFuture[widget.index].name,
                style: TextStyle(
                  color: AppThemes.color4,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                      color: AppThemes.color1,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: <Widget>[
                          Text(
                            "Preço: R\$ ${widget.db.expensesWithoutFuture[widget.index].price}",
                            style: AppThemes.textStyle,
                          ),
                          const Divider(color: AppThemes.color4),
                          const SizedBox(height: 10),
                          Text(
                            "Forma de pagamento: ${widget.db.expensesWithoutFuture[widget.index].paymentMethod}",
                            style: AppThemes.textStyle,
                          ),
                          const Divider(color: AppThemes.color4),
                          const SizedBox(height: 10),
                          if (widget.db.expensesWithoutFuture[widget.index].paymentMethod == ExpansibleVariables.payment2) ...[
                            Text(
                              "Parcelas: ${widget.db.expensesWithoutFuture[widget.index].installments}",
                              style: AppThemes.textStyle,
                            ),
                            const Divider(color: AppThemes.color4),
                            const SizedBox(height: 10),
                          ],
                          Text(
                            "Data de vencimento: ${widget.db.expensesWithoutFuture[widget.index].date}",
                            style: AppThemes.textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                            expenseData:
                                widget.db.expensesWithoutFuture[widget.index],
                          ),
                          thenFunction: thenFunction,
                        ),
                      ),
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
                            content:
                                "Tem certeza que deseja apagar esse gasto?",
                          );
                          if (response) {
                            await widget.db.deleteExpense(
                              expenseID:
                                  widget.db.expensesWithoutFuture[widget.index].id,
                            );
                            showSnackBar();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void thenFunction({bool? response}) async {
    if (response != null && response) {
      await widget.db.selectExpensesByGroup(
        groupID: widget.db.expensesWithoutFuture[widget.index].groupID,
      );
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  void showSnackBar() {
    if (!mounted) {
      return;
    }

    showColoredSnackBar(
      context: context,
      msm: "Gasto removido com sucesso!",
      txtColor: AppThemes.color1,
    );
    Navigator.pop<bool?>(context, true);
  }
}
