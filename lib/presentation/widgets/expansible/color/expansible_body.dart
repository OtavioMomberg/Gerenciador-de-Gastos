import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/core/utils/controllers_utils.dart';

class ExpansibleBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansibleBody({
    required this.controller,
    required this.setStateCallback,
    super.key,
  });

  final _controller = ControllerUtils.instance();
  final _color = ColorConversion.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
      ),
      height: 250,
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          ...List.generate(ColorConversion.listColors.length, (int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () => saveColor(index: index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppThemes.borderRadius,
                    border: Border.all(color: AppThemes.color4),
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
  }

  void saveColor({required int index}) {
    _color.cor = ColorConversion.colorsMap[ColorConversion.listColors[index]]!;
    _controller.groupColor!.text = ColorConversion.listColors[index].toString();
    setStateCallback();
    controller.collapse();
  }
}
