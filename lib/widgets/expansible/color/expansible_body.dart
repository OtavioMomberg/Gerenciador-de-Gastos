import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';

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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 136, 136, 136)),
      ),
      height: 250,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          ...List.generate(ColorConversion.listColors.length, (int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () {
                  _color.cor = ColorConversion.colorsMap[ColorConversion.listColors[index]]!;
                  _controller.groupColor!.text = ColorConversion.listColors[index].toString();
                  setStateCallback();
                  controller.collapse();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromARGB(255, 136, 136, 136),
                    ),
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
}
