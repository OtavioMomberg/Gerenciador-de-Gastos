import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
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
  final _groupService = GroupService.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.color3,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Meus Gastos",
          style: AppThemes.textStyle
        ),
        foregroundColor: AppThemes.color4,
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await filter();
              if (!mounted) { return; }
              setState(() {});
            },
            icon: Icon(
              Icons.filter_alt,
              color: AppThemes.color4,
              fontWeight: FontWeight.bold
            )
          ),
          IconButton(
            onPressed: () async {
              final message = "Tem certeza que deseja apagar o grupo?\nTodos os gastos do grupo serão apagados também.";
              if (await deleteProcess(message: message)) {
                await _db.deleteGroup(groupID: widget.groupID);
                await _db.selectGroups();
                showResponse(message: "Grupo removido com sucesso!");
              }
            },
            icon: const Icon(
              Icons.delete,
              color: AppThemes.color2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        color: AppThemes.color3,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            IgnorePointer(
              ignoring: _groupService.isExpenseSelected ? false : true,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: _groupService.isExpenseSelected ? 1.0 : 0.0,
                child: Button(
                  label: "Apagar Selecionados",
                  height: 60,
                  function: () async {
                    if (await deleteProcess(
                      message: "Tem certeza que deseja apagar esses gastos?",
                    )) {
                      await _db.deleteSelectedExpenses(
                        expenseID: _groupService.indexList,
                      );
                      showResponse(message: "Gastos removidos com sucesso!");
                      _groupService.updateIsExpenseSelected();
                      _groupService.indexList.clear();
                    }
                  }
                )
              )
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: _db.expenses,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: AppThemes.color1,
                        child: Center(
                          child: Text(
                            "Nenhum gasto encontrado",
                            style: AppThemes.textStyle
                          )
                        )
                      )
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ExpenseCard(
                          index: index,
                          expense: snapshot.data![index],
                          length: snapshot.data!.length,
                          setStateCallback: () => setState(() {}),
                          thenFunction: thenFunction
                        )
                      );
                    }
                  );
                }
              )
            )
          ]
        )
      )
    );
  }

  Future<void> filter() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppThemes.color3,
        title: Center(
          child: const Text(
            "Filtro",
            style: AppThemes.textStyle
          )
        ),
        content: Column(
          mainAxisSize: .min,
          spacing: 10,
          children: <Widget>[
            TextInput(
              controller: _groupService.month,
              textHint: "Mês",
              inputType: TextInputType.number
            ),
            TextInput(
              controller: _groupService.year,
              textHint: "Ano",
              inputType: TextInputType.number
            ),
            const SizedBox(height: 10),
            Button(
              label: "Filtrar", 
              height: 60, 
              function: () {
                bool check = _groupService.checkGroupPageValues(
                  context: context, 
                  groupID: widget.groupID,
                  closeDialog: closeDialog
                );
                if (!check || !mounted) { return; }
                Navigator.pop(context);
              } 
            )
          ]
        )
      )
    );
  }

  void closeDialog() {
    _groupService.month.clear();
    _groupService.year.clear();
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  Future<bool> deleteProcess({required String message}) async {
    final response = await confirmDialog(
      context: context,
      title: "🚨  Atenção  🚨",
      content: message
    );
    return response;
  }

  void showResponse({required String message}) {
    if (!mounted) {
      return;
    }

    showColoredSnackBar(
      context: context,
      msm: message,
      txtColor: AppThemes.color1,
    );
    Navigator.pop(context);
  }

  void changePage({required int index, required Widget page}) {
    goNextPage(
      context: context,
      index: index,
      page: page,
      thenFunction: thenFunction,
    );
  }

  void thenFunction({bool? response}) async {
    await _db.selectExpensesByGroup(groupID: widget.groupID);
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _groupService.month.dispose();
    _groupService.year.dispose();
    super.dispose();
  }
}
