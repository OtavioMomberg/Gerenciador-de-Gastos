import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/confirmation_dialog.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/expense_card.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class GroupPage extends StatefulWidget {
  final int groupID;

  const GroupPage({required this.groupID, super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> 
  with ErrorDialog, ConfirmationDialog, ShowColoredSnackBar, ChangePage {
  final _db = DatabaseService.instance();
  final groupService = GroupService.instance();
  final month = TextEditingController();
  final year = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Meus Gastos",
          style: TextStyle(
            color: Color.fromARGB(255, 136, 136, 136),
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: const Color.fromARGB(255, 136, 136, 136),
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            onPressed: () async {
              await filter();
              if (!mounted) { return; }
              setState(() {});
            },
            icon: Icon(
              Icons.filter_alt,
              color: const Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold
            )
          ),
          IconButton(
            onPressed: () async {
              final message = "Tem certeza que deseja apagar o grupo?\nTodos os gastos do grupo serão apagados também.";
              if (await deleteProcess(message: message)) {
                await _db.deleteGroup(groupID: widget.groupID);
                _db.selectGroups();
                showResponse(message: "Grupo removido com sucesso!");
              }
              
            }, 
            icon: const Icon(
              Icons.delete, 
              color: Color.fromARGB(255, 255, 140, 132), 
              fontWeight: FontWeight.bold
            )
          )
        ]
      ),
      backgroundColor: const Color.fromARGB(255, 234, 242, 252),
      body: Container(
        color: const Color.fromARGB(255, 234, 242, 252),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[ 
            IgnorePointer(
              ignoring: groupService.isExpenseSelected ? false : true,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: groupService.isExpenseSelected ? 1.0 : 0.0,
                child: Button(
                  label: "Apagar Selecionados", 
                  height: 60,
                  function: () async {
                    if (await deleteProcess(message: "Tem certeza que deseja apagar esse gasto?")) {
                      await _db.deleteSelectedExpenses(expenseID: groupService.indexList);
                      showResponse(message: "Gastos removidos com sucesso!");
                    }
                  }
                )
              )
            ),
            const SizedBox(height: 10),
            if (_db.expenses.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _db.expenses.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ExpenseCard(
                        index: index,
                        setStateCallback: () => setState(() {}),
                        thenFunction: thenFunction
                      )
                    );
                  }
                )
              ),
            ] else ...[
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Card(
                  color: const Color.fromARGB(255, 210, 232, 236),
                  child: Center(
                    child: Text(
                      "Nenhum gasto encontrado",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> filter() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        title: Center(
          child: const Text(
            "Filtro",
            style: TextStyle(
              color: Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: .min,
          spacing: 10,
          children: <Widget>[
            TextInput(
              controller: month,
              textHint: "Mês",
              inputType: TextInputType.number,
            ),
            TextInput(
              controller: year,
              textHint: "Ano",
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Button(label: "Filtrar", height: 60, function: checkValues),
          ],
        ),
      ),
    );
  }

  void checkValues() {
    if (month.text.isEmpty || year.text.isEmpty) {
      showError(
        context: context,
        title: "Mês ou ano vazios",
        content: "Todos os campos devem ser preenchidos",
        closeDialog: closeDialog,
      );
      return;
    }
    if (int.parse(month.text) < 0 || int.parse(month.text) > 12) {
      showError(
        context: context,
        title: "Mês inválido",
        content: "O mês deve ser entre 1 e 12",
        closeDialog: closeDialog,
      );
      return;
    }
    if (int.parse(year.text) < DateTime.now().year) {
      showError(
        context: context,
        title: "Ano inválido",
        content: "O ano não pode ser anterior a ${DateTime.now().year}",
        closeDialog: closeDialog,
      );
      return;
    }
    updateFilter();
  }

  void updateFilter() {
    if (int.parse(month.text) == 0) {
      _db.selectExpensesByGroup(groupID: widget.groupID);
    } else {
      _db.selectExpensesByDate(
        groupID: widget.groupID,
        month: month.text,
        year: year.text,
      );
    }

    month.clear();
    year.clear();
    Navigator.pop(context);
  }

  void closeDialog() {
    month.clear();
    year.clear();
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  Future<bool> deleteProcess({required String message}) async {
    final response = await confirmDialog(
      context: context,
      title: "🚨  Atenção  🚨",
      content: message,
    );
    return response;
  }

  void showResponse({required String message}) {
    if (!mounted) { return; }

    showColoredSnackBar(
      context: context,
      msm: message,
      txtColor: const Color.fromARGB(255, 210, 232, 236),
    );
    Navigator.pop(context);
  }

  void changePage({required int index, required Widget page}) {
    goNextPage(
      context: context, 
      index: index, 
      page: page,
      thenFunction: thenFunction
    );
  }

  void thenFunction({bool? response}) async {
      await _db.selectExpensesByGroup(groupID: widget.groupID);
      if (!mounted) { return; }
      setState(() {});
  }

  @override
  void dispose() {
    month.dispose();
    year.dispose();
    super.dispose();
  }
}