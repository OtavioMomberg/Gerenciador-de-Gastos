import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/models/group_write.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';
//import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';

class GroupService with ErrorDialog {
  bool _isExpenseSelected = false;
  int? _cardIndex;
  late GroupWrite groupData;
  final List<int> _indexList = [];
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  GroupService();

  static final _instance = GroupService._();
  GroupService._();
  factory GroupService.instance() => _instance;

  final _controller = ControllerUtils.instance();
  final _db = DatabaseService.instance();
  //final _expansibleVariables = ExpansibleVariables.instance();

  bool get isExpenseSelected => _isExpenseSelected;
  int? get cardIndex => _cardIndex;
  List<int> get indexList => _indexList;

  void executeAction({required bool isCreate}) async {
      buildGroupWriteObject();
      isCreate
        ? await _db.addGroup(groupData: groupData)
        : await _db.updateGroup(groupData: groupData, groupID: int.parse(_controller.groupID!.text));  
  }

  void getGroupControllers() {
    _controller.groupsList.clear();

    _controller.groupsList.add(_controller.groupID = TextEditingController());
    _controller.groupsList.add(_controller.groupName = TextEditingController());
    _controller.groupsList.add(_controller.groupColor = TextEditingController());
    
    _controller.expansibleColorController = ExpansibleController();
  }

  bool checkGroupFields({required BuildContext context, required VoidCallback closeDialog}) {
    if (_controller.groupName!.text.isEmpty) { return false; }
    if (_controller.groupColor!.text.isEmpty) { return false; }

    if (!_controller.groupName!.text[0].contains(RegExp("[aA-zZ]"))) {
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

  void getData({required GroupRead groupData}) {
    _controller.groupName!.text = groupData.name;
    _controller.groupColor!.text = groupData.color;
    _controller.groupID!.text = groupData.id.toString();
  }

  void buildGroupWriteObject() {
    groupData = GroupWrite(
      name: _controller.groupName!.text,
      color: _controller.groupColor!.text,
    );
  }

  void updateIsExpenseSelected() => _isExpenseSelected = !_isExpenseSelected;

  bool? checkCardIndex({required int index}) {
    if (_cardIndex == index && _indexList.length > 1) {
      return false;
    }
    if (_cardIndex == index && _indexList.length == 1) {
      _isExpenseSelected = !_isExpenseSelected;
      _indexList.clear();
      return true;
    }
    return null;
  }

  void checkIndexList({required int index}) {
    if (_indexList.contains(index)) {
      _indexList.remove(index);
    } else {
      _indexList.add(index);
    }
  }

  bool checkOnLongPressIndexList({required int index}) {
    if (_indexList.isNotEmpty) {
      if (!_indexList.contains(index)) {
        return false;
      }
    }
    return true;
  }

  void updateOnLongPressValues({required int index}) {
    _cardIndex = index;
    _isExpenseSelected = !_isExpenseSelected;
  }

  void checkExpenseSelected({required int index}) {
    if (_isExpenseSelected) {
      _indexList.add(index);
    } else {
      _indexList.clear();
    }
  }

  bool checkGroupPageValues({
    required BuildContext context, 
    required int groupID,
    required VoidCallback closeDialog
  }) {
    if (month.text.isEmpty && year.text.isEmpty) {
      updateFilter(groupID: groupID, getAllExpenses: true);
      return true;
    }
    if (month.text.isEmpty || year.text.isEmpty) {
      showError(
        context: context,
        title: "Mês ou ano vazios",
        content: "Todos os campos devem ser preenchidos",
        closeDialog: closeDialog,
      );
      return false;
    }
    if (int.parse(month.text) < 0 || int.parse(month.text) > 12) {
      showError(
        context: context,
        title: "Mês inválido",
        content: "O mês deve ser entre 1 e 12",
        closeDialog: closeDialog,
      );
      return false;
    }
    if (int.parse(year.text) < DateTime.now().year) {
      showError(
        context: context,
        title: "Ano inválido",
        content: "O ano não pode ser anterior a ${DateTime.now().year}",
        closeDialog: closeDialog,
      );
      return false;
    }
    updateFilter(groupID: groupID);
    return true;
  }

  void updateFilter({required int groupID, bool? getAllExpenses}) async {
    if (getAllExpenses != null) {
      if (getAllExpenses) {
        await _db.selectExpensesByGroup(groupID: groupID);
      }
    } else {
      await _db.selectExpensesByDate(
        groupID: groupID,
        month: month.text,
        year: year.text,
      );
    }

    month.clear();
    year.clear();
    if (getAllExpenses != null) { getAllExpenses = null; }
  }
}
