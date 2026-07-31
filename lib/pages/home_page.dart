import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/calculation_page.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/pages/action_expense_page.dart';
import 'package:gerenciador_gastos_v2/pages/action_group_page.dart';
import 'package:gerenciador_gastos_v2/pages/group_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/group_card.dart';
import 'package:gerenciador_gastos_v2/widgets/search_bar/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ChangePage {
  final _db = DatabaseService.instance();

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
        backgroundColor: AppThemes.color3,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppThemes.color3,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            children: <Widget>[
              const SizedBox(height: 10),
              SearchBarWidget(navigation: navigation),
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
                      color: AppThemes.color4,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: size.height * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: FutureBuilder(
                      future: _db.groups,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Card(
                            color: AppThemes.color1,
                            child: Center(
                              child: Text(
                                "Sem grupos criados",
                                style: const TextStyle(
                                  color: AppThemes.color4,
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: GroupCard(
                                color: ColorConversion.colorsMap[snapshot.data![index].color]!,
                                groupName: snapshot.data![index].name,
                                width: (size.width - 30) * 0.5,
                                onTap: () async {
                                  await _db.selectExpensesByGroup(groupID: snapshot.data![index].id);
                                  navigation(
                                    page: GroupPage(
                                      groupID: snapshot.data![index].id,
                                    ),
                                    index: index,
                                  );
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
    await _db.selectGroups();
  }

  void navigation({required Widget page, int? index = 0}) {
    if (_db.groupsWithoutFuture.isEmpty && page.runtimeType != ActionGroupPage) {
      return;
    }

    goNextPage(
      context: context,
      index: index ?? 0,
      page: page,
      thenFunction: ({response}) async {
        await _db.selectGroups();
        setState(() {});
      }
    );
  }
}
