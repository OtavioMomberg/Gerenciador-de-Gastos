import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/routes/app_routes.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/confirmation_dialog.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/pages/action_expense_page.dart';
import 'package:gerenciador_gastos_v2/pages/action_group_page.dart';
import 'package:gerenciador_gastos_v2/pages/group_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ConfirmationDialog, ShowColoredSnackBar {
  final _db = DatabaseService.instance();
  final textControllers = ControllerUtils.instance();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 234, 242, 252),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 234, 242, 252),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            children: <Widget>[
              const SizedBox(height: 10),
              SearchBar(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 210, 232, 236),
                ),
                leading: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontWeight: FontWeight.bold,
                ),
                elevation: const WidgetStatePropertyAll(5),
                hintText: "Pesquisar",
                hintStyle: const WidgetStatePropertyAll(
                  TextStyle(
                    color: Color.fromARGB(255, 136, 136, 136),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: Button(
                      label: "Criar Grupo",
                      height: 100,
                      navigation: navigation,
                      page: ActionGroupPage(action: ActionsEnum.create),
                    ),
                  ),
                  Expanded(
                    child: Button(
                      label: "Adicionar Gasto",
                      height: 100,
                      navigation: navigation,
                      page: ActionExpensePage(action: ActionsEnum.create),
                    ),
                  ),
                ],
              ),
              Button(label: "Calcular Gastos", height: 60),
              const SizedBox(height: 30),
              Column(
                children: <Widget>[
                  const Text(
                    "Meus Grupos",
                    style: TextStyle(
                      color: Color.fromARGB(255, 136, 136, 136),
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(
                    height: size.height * 0.35,
                    child: FutureBuilder(
                      future: _db.groups,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Card(
                            color: const Color.fromARGB(255, 210, 232, 236),
                            child: Center(
                              child: Text(
                                "Sem grupos criados",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 136, 136, 136),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                await _db.selectExpensesByDate(
                                  groupID: snapshot.data![index].id, 
                                  month: DateTime.now().month.toString(), 
                                  year: DateTime.now().year.toString()
                                );
                                navigation(page: GroupPage(groupID: snapshot.data![index].id));
                              },
                              onLongPress: () => navigation(
                                page: ActionGroupPage(
                                  action: ActionsEnum.update,
                                  groupData: snapshot.data![index]
                                )
                              ),
                              //onDoubleTap: () async => await deleteProcess(groupID: snapshot.data![index].id),
                              child: SizedBox(
                                width: (size.width - 30) * 0.5,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: ColorConversion
                                      .colorsMap[snapshot.data![index].color],
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index].name,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 136, 136, 136),
                                        fontWeight: FontWeight.bold
                                      )
                                    )
                                  )
                                )
                              )
                            );
                          }
                        );
                      }
                    )
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }

  Future<void> init() async {
    _db.selectGroups();
  }

  Future<void> navigation({required Widget page}) async {
    await Navigator.push(
      context,
      AppRoutes.dynamicRoute(page: page),
    ).then((_) async {
      _db.selectGroups();
      setState(() {});
    });
  }

  Future<void> deleteProcess({required int groupID}) async {
    final response = await confirmDialog(
      context: context,
      title: "🚨  Atenção  🚨",
      content: "Tem certeza que deseja apagar o grupo?\nTodos os gastos do grupo serão apagados também.",
    );
    if (response) {
      await _db.deleteGroup(groupID: groupID);
      _db.selectGroups();
      showResponse();
    }
  }

  void showResponse() {
    setState(() {});
    if (!mounted) {
      return;
    }
    showColoredSnackBar(
      context: context,
      msm: "Grupo removido com sucesso!",
      txtColor: const Color.fromARGB(255, 210, 232, 236),
    );
  }
}
