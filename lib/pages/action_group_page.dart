import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/models/group_write.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/utils/text_controllers.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/image_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class ActionGroupPage extends StatefulWidget {
  final GroupOptionsEnum action;
  const ActionGroupPage({required this.action, super.key});

  @override
  State<ActionGroupPage> createState() => _ActionGroupPageState();
}

class _ActionGroupPageState extends State<ActionGroupPage> with ErrorDialog, ShowColoredSnackBar {
  final _controller = TextControllers.instance();
  final _color = ColorConversion.instance();
  final _db = DatabaseService.instance();
  final exController = ExpansibleController();

  @override
  void initState() {
    super.initState();

    if (_controller.groupName.text.isNotEmpty && _controller.groupColor.text.isNotEmpty) {
      _color.cor = ColorConversion.colorsMap[_controller.groupColor.text]!;
    } else {
      _color.cor = const Color.fromARGB(255, 234, 242, 252);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        foregroundColor: const Color.fromARGB(255, 136, 136, 136),
        surfaceTintColor: Colors.transparent
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
              Text(
                widget.action == GroupOptionsEnum.atualizarGrupo ? "Atualizar Grupo" : "Criar Grupo",
                style: const TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 20),
              TextInput(controller: _controller.groupName, textHint: "Nome do grupo: Ex. Grupo"),
              ExpansibleWidget(
                controller: exController, 
                setStateCallback: () => setState((){})
              ),
              const SizedBox(height: 20),
              Button(
                label: widget.action == GroupOptionsEnum.atualizarGrupo 
                  ? "Atualizar Grupo" 
                  : "Criar Grupo", 
                height: 60,
                function: executeAction,
              ),
              const SizedBox(height: 5),
              ImageWidget(imagePath: "assets/images/dash.png")
            ]
          )
        )
      )
    );
  }

  void executeAction() {
    final bool check = checkData();

    if (!check) { return; }

    final groupData = GroupWrite(
      name: _controller.groupName.text,
      color: _controller.groupColor.text,
    );
    final checkAction = widget.action == GroupOptionsEnum.criarGrupo;
    checkAction
      ? _db.addGroup(groupData: groupData)
      : _db.updateGroup(groupData: groupData, groupID: int.parse(_controller.groupID.text));

    showColoredSnackBar(
      context: context,
      msm: checkAction ? "Grupo criado com sucesso!" : "Grupo atualizado com sucesso!",
      txtColor: checkAction ? const Color.fromARGB(255, 236, 236, 237) : const Color.fromARGB(255, 210, 232, 236),
    );
    _controller.clearGroupsList();
    Navigator.pop(context);
  }

  bool checkData() {
    if (_controller.groupName.text.isEmpty && _controller.groupColor.text.isEmpty) {
      showError(
        context: context,
        title: "⚠️  Erro  ⚠️",
        content: "Nome ou Cor não informados.",
        closeDialog: closeDialog,
      );
      return false;
    }
    if (!_controller.groupName.text[0].contains(RegExp("[aA-zZ]"))) {
      showError(
        context: context,
        title: "⚠️  Erro  ⚠️",
        content: "O nome deve começar com uma letra.",
        closeDialog: closeDialog,
      );
      return false;
    }
    return true;
  }

  void closeDialog() {
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }
}
