import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/models/group_write.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/utils/text_controllers.dart';

class ActionGroupPage extends StatefulWidget {
  final GroupOptionsEnum action;
  const ActionGroupPage({required this.action, super.key});

  @override
  State<ActionGroupPage> createState() => _ActionGroupPageState();
}

class _ActionGroupPageState extends State<ActionGroupPage> with ErrorDialog {
  final controller = TextControllers.instance();
  final _db = DatabaseService.instance();
  final exController = ExpansibleController();
  late Color cor;

  @override
  void initState() {
    super.initState();

    if (controller.groupName.text.isNotEmpty && controller.groupColor.text.isNotEmpty) {
      cor = ColorConversion.colorsMap[controller.groupColor.text]!;
    } else {
      cor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: <Widget>[
              Text(widget.action == GroupOptionsEnum.atualizarGrupo ? "Atualizar Grupo" : "Criar Grupo"),
              TextFormField(
                controller: controller.groupName,
                decoration: InputDecoration(
                  hint: Text("Insira o nome do grupo:"),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Expansible(
                  headerBuilder: (context, _) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(),
                      ),
                      child: Row(
                        mainAxisAlignment: .center,
                        spacing: 10,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: cor,
                            ),
                            margin: EdgeInsets.all(5),
                            height: 60,
                            width: size.width * 0.7 * 0.5,

                            child: Center(
                              child: Text(
                                cor == Colors.white ? "Selecione uma cor" : "",
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              exController.isExpanded
                                  ? exController.collapse()
                                  : exController.expand();
                            },
                            icon: Icon(
                              exController.isExpanded
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: cor == Colors.white ? Colors.black : cor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  bodyBuilder: (context, _) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      height: 250,
                      child: Column(
                        children: [
                          ...List.generate(ColorConversion.listColors.length, (int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: InkWell(
                                onTap: () {
                                  cor = ColorConversion.colorsMap[ColorConversion.listColors[index]]!;
                                  controller.groupColor.text = ColorConversion.listColors[index].toString();
                                  setState(() {});
                                  exController.collapse();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ColorConversion.colorsMap[ColorConversion.listColors[index]]!,
                                  ),
                                  height: 60,
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.infinity,
                                  child: Text("")
                                )
                              )
                            );
                          })
                        ]
                      )
                    );
                  },
                  controller: exController,
                )
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.groupName.text.isNotEmpty && controller.groupColor.text.isNotEmpty) {
                    final groupData = GroupWrite(
                      name: controller.groupName.text,
                      color: controller.groupColor.text,
                    );
                    widget.action == GroupOptionsEnum.criarGrupo
                      ? _db.addGroup(groupData: groupData)
                      : _db.updateGroup(groupData: groupData, groupID: int.parse(controller.groupID.text));
                    controller.clearGroupsList();
                    Navigator.pop(context);
                  } else {
                    showError(
                      context: context,
                      title: "⚠️  Erro  ⚠️",
                      content: "Nome ou Cor não informados.",
                      closeDialog: closeDialog,
                    );
                  }
                },
                child: Text(widget.action == GroupOptionsEnum.atualizarGrupo ? "Atualizar Grupo" : "Criar Grupo")
              )
            ]
          )
        )
      )
    );
  }

  void closeDialog() {
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }
}
