import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:gerenciador_gastos_v2/core/di/app_dependencies.dart';
import 'package:gerenciador_gastos_v2/services/calculation_service.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/core/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/button.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/groupID/expansible_id_body.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/groupID/expansible_id_header.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/payment_method/expansible_payment_body.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/payment_method/expansible_payment_header.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/text_input.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> with ErrorDialog, ChangePage {
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  final _calculationService = CalculationService();

  @override
  void initState() {
    super.initState();
    _calculationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.color3,
        foregroundColor: AppThemes.color4,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Calcule seus Gastos",
          style: AppThemes.textStyle
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarColor: AppThemes.color3,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppThemes.color3,
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: <Widget>[
                ExpansibleWidget(
                  header: ExpansibleIdHeader(
                    controller: _controller.expansibleGroupIDController!, 
                    setStateCallback: () => setState((){})
                  ), 
                  body: ExpansibleIdBody(
                    controller: _controller.expansibleGroupIDController!,
                    db: AppDependencies.db,
                    setStateCallback: () => setState((){})
                  ), 
                  controller: _controller.expansibleGroupIDController!
                ),
                ExpansibleWidget(
                  header: ExpansiblePaymentHeader(
                    controller: _controller.expansiblePaymentController!, 
                    setStateCallback: () => setState((){})
                  ), 
                  body: ExpansiblePaymentBody(
                    controller: _controller.expansiblePaymentController!,
                    paymentList: _expansibleVariables.paymentMethodsCalculation,
                    setStateCallback: () => setState((){})
                  ), 
                  controller: _controller.expansiblePaymentController!
                ),
                Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    const Text(
                      "(*Opcional)",
                      style: TextStyle(
                        color: AppThemes.color2,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextInput(
                      controller: _calculationService.day,
                      textHint: "Dia:",
                      inputType: TextInputType.number
                    )
                  ]
                ),
                Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    const Text(
                      "(*Opcional)",
                      style: TextStyle(
                        color: AppThemes.color2,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextInput(
                      controller: _calculationService.month,
                      textHint: "Mês:",
                      inputType: TextInputType.number
                    )
                  ]
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Calcular", 
                  height: 60,
                  function: () async {
                    final check = await _calculationService.checkData(
                      context: context, 
                      closeDialog: closeDialog
                    );
                    if (check) { 
                      _calculationService.doCalculations();
                      setState(() {});
                    }
                  }
                ),
                if (_calculationService.result.isNotEmpty)...[
                  const SizedBox(height: 10),
                  const Text(
                    "Resultado",
                    style: TextStyle(
                      color: AppThemes.color4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: AppThemes.borderRadius,
                      border: Border.all(color: AppThemes.color4)
                    ),
                    child: Center(
                      child: Text(
                        !(_calculationService.result.startsWith("0") && _calculationService.result == "0") 
                          ? "R\$ ${_calculationService.result}" 
                          : "Sem gastos no ${_controller.expensePaymentMethod!.text}",
                        style: TextStyle(
                          color: AppThemes.color4,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      )
                    )
                  ),
                  Row(
                    spacing: 10,
                    children: <Widget>[
                      Expanded(
                        child: Button(
                          label: "Ver gastos",
                          height: 60,
                          icon: Icons.receipt_long_outlined,
                          function: () => _calculationService.checkCalculatePage(context: context),
                        )
                      ),
                      Expanded(
                        child: Button(
                          label: "Limpar", 
                          height: 60,
                          icon: Icons.cleaning_services_outlined,
                          function: () {
                            _calculationService.clearFields();
                            setState(() {});
                          }
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 10)  
                ]
              ]
            )
          ),
        )
      )
    );
  }

  void closeDialog() {
    _controller.expenseGroupID!.clear();
    _controller.expensePaymentMethod!.clear();
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _calculationService.day.dispose();
    _calculationService.month.dispose();
    _controller.expenseGroupID!.dispose();
    _controller.expensePaymentMethod!.dispose();
    _controller.expansibleGroupIDController!.dispose();
    _controller.expansiblePaymentController!.dispose();
    super.dispose();
  }
}