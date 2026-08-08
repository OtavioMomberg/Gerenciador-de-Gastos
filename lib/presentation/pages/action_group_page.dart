import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/core/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/core/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/core/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/core/utils/sort_image.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/button.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/color/expansible_body.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/color/expansible_header.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/image_widget.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/text_input.dart';

class ActionGroupPage extends StatefulWidget {
  final ActionsEnum action;
  final GroupRead? groupData;

  const ActionGroupPage({
    required this.action, 
    this.groupData, 
    super.key
  });

  @override
  State<ActionGroupPage> createState() => _ActionGroupPageState();
}

class _ActionGroupPageState extends State<ActionGroupPage> with ErrorDialog, ShowColoredSnackBar {
  final _controller = ControllerUtils.instance();
  final _color = ColorConversion.instance();
  final _groupService = GroupService();
  
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.color3,
        foregroundColor: AppThemes.color4,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarColor: AppThemes.color3,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: AppThemes.color3,
      body: SafeArea(
        top: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppThemes.color3,
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              children: <Widget>[
                Text(
                  widget.action == ActionsEnum.update ? "Atualizar Grupo" : "Criar Grupo",
                  style: const TextStyle(
                    color: AppThemes.color4,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextInput(
                  controller: _controller.groupName!,
                  textHint: "Nome do grupo: Ex. Grupo",
                ),
                ExpansibleWidget(
                  controller: _controller.expansibleColorController!,
                  header: ExpansibleHeader(
                    controller: _controller.expansibleColorController!,
                    setStateCallback: () => setState((){}),
                  ),
                  body: ExpansibleBody(
                    controller: _controller.expansibleColorController!,
                    setStateCallback: () => setState(() {}),
                  ),
                ),
                const SizedBox(height: 10),
                Button(
                  label: widget.action == ActionsEnum.update ? "Atualizar Grupo" : "Criar Grupo",
                  height: 60,
                  icon: widget.action == ActionsEnum.update ? Icons.edit_outlined : Icons.add_box_outlined,
                  function: () {
                    executeAction(
                      isCreate: _groupService.checkGroupFields(
                        context: context, 
                        closeDialog: closeDialog
                      )
                    );
                  }
                ),
                const SizedBox(height: 5),
                ImageWidget(imagePath: SortImage.getImagePath()),
              ]
            )
          )
        ),
      )
    );
  }

  void init() {
    _groupService.getGroupControllers();
    
    if (widget.groupData != null && widget.action == ActionsEnum.update) {
      _groupService.getData(groupData: widget.groupData!);
    }

    if (_controller.groupName!.text.isNotEmpty && _controller.groupColor!.text.isNotEmpty) {
      _color.cor = ColorConversion.colorsMap[_controller.groupColor!.text]!;
    } else {
      _color.cor = const Color.fromARGB(255, 234, 242, 252);
    }
  }

  void executeAction({required bool isCreate}) async {
    if (isCreate) { 
      _groupService.executeAction(isCreate: widget.action == ActionsEnum.create);
      showResponse(isSuccess: true, isCreate: widget.action == ActionsEnum.create);
      return;
    }
    showResponse(isSuccess: false);
  }

  void showResponse({required bool isSuccess, bool? isCreate}) {
    if (isSuccess) {
      if (!mounted) { return; }
      showColoredSnackBar(
        context: context, 
        msm: (isCreate ?? true) ? "Grupo adicionado com sucesso!" : "Grupo atualizado com sucesso!", 
        txtColor: const Color.fromARGB(255, 210, 232, 236)
      );
      (isCreate ?? true) ? Navigator.pop(context) : Navigator.pop<bool?>(context, true); 

      setState(() {});
      return;
    }
    showError(
      context: context, 
      title: "⚠️  Erro  ⚠️", 
      content: "Nome ou Cor não informados.", 
      closeDialog: closeDialog
    );
  }

  void closeDialog() {
    if (!mounted) { return; }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _groupService.getGroupControllers();

    if (_controller.groupsList.isNotEmpty) {
      for (var group in _controller.groupsList) {
        group.dispose();
      }
    }
    _controller.expansibleColorController!.dispose();
    super.dispose();
  }
}
