import 'package:flutter/widgets.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_error.dart';

typedef Controllers = List<TextEditingController>;
typedef ExpansibleControllers = List<ExpansibleController>;

class ControllerUtils with ErrorDialog {
  // GROUP TEXT CONTROLLERS
  TextEditingController? groupID;
  TextEditingController? groupName;
  TextEditingController? groupColor;

  // EXPENSES TEXT CONTROLLERS
  TextEditingController? expenseName;
  TextEditingController? expensePrice;
  TextEditingController? expensePaymentMethod;
  TextEditingController? expenseDate;
  TextEditingController? expenseInstallment;
  TextEditingController? expenseGroupID;

  // EXPANSIBLE CONTROLLERS
  ExpansibleController? expansibleColorController;
  ExpansibleController? expansibleDateController;
  ExpansibleController? expansiblePaymentController;
  ExpansibleController? expansibleGroupIDController;

  final Controllers expensesList = [];
  final Controllers groupsList = [];

  static final _instance = ControllerUtils._();
  ControllerUtils._();
  factory ControllerUtils.instance() => _instance;
}
