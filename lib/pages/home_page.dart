import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/calculation_page.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/pages/action_expense_page.dart';
import 'package:gerenciador_gastos_v2/pages/action_group_page.dart';
import 'package:gerenciador_gastos_v2/pages/group_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/group_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ChangePage {
  final _db = DatabaseService.instance();
  final groupService = GroupService.instance();

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
                    fontWeight: FontWeight.bold
                  )
                )
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
                      page: ActionGroupPage(action: ActionsEnum.create)
                    )
                  ),
                  Expanded(
                    child: Button(
                      label: "Adicionar Gasto",
                      height: 100,
                      navigation: navigation,
                      page: ActionExpensePage(action: ActionsEnum.create)
                    )
                  )
                ]
              ),
              Button(
                label: "Calcular Gastos", 
                height: 60,
                navigation: navigation,
                page: CalculationPage()
              ),
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
                  const SizedBox(height: 10),    
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
                                  fontWeight: FontWeight.bold
                                )
                              )
                            )
                          );
                        }
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return GroupCard(
                              color: ColorConversion.colorsMap[snapshot.data![index].color]!, 
                              groupName: snapshot.data![index].name, 
                              width: (size.width - 30) * 0.5, 
                              onTap: () async {
                                await _db.selectExpensesByGroup(groupID: snapshot.data![index].id);
                                groupService.populateCheckColor(len: _db.expensesWithoutFuture.length);
                                navigation(page: GroupPage(groupID: snapshot.data![index].id), index: index);
                              }, 
                              onLongPress: () {
                                navigation(
                                  page: ActionGroupPage(
                                    action: ActionsEnum.update,
                                    groupData: snapshot.data![index]
                                  ),
                                  index: index
                                );
                              }
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

  void navigation({required Widget page, int index = 0}) {
    goNextPage(
      context: context, 
      index: index, 
      page: page,
      thenFunction: ({response}) {
        _db.selectGroups();
        setState(() {});
      }
    );
  }
}