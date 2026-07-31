import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/pages/expand_card_page.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';

class ExpenseCard extends StatelessWidget with ChangePage {
  final int index;
  final int length;
  final ExpenseRead expense;
  final VoidCallback setStateCallback;
  final void Function({bool? response})? thenFunction;

  ExpenseCard({
    required this.index,
    required this.length,
    required this.expense,
    required this.setStateCallback,
    this.thenFunction,
    super.key,
  });

  final _groupService = GroupService.instance();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _groupService.indexList.contains(index)
        ? AppThemes.color2
        : AppThemes.color1,
      elevation: 5,
      shadowColor: _groupService.indexList.contains(index)
        ? AppThemes.color2
        : AppThemes.color1,
      borderRadius: AppThemes.borderRadius,
      child: InkWell(
        borderRadius: AppThemes.borderRadius,
        onTap: () {
          _groupService.isExpenseSelected
            ? selectCard()
            : changePage(context: context);
        },
        onLongPress: unlockSelectOption,
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: <Widget>[
                    Text(
                      expense.name,
                      style: AppThemes.textStyle
                    ),
                    Text(
                      expense.date,
                      style: AppThemes.textStyle
                    )
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "R\$ ${expense.price}",
                  style: AppThemes.textStyle
                )
              )
            ]
          )
        )
      )
    );
  }

  void selectCard() {
    final bool? result = _groupService.checkCardIndex(index: index);

    if (result != null) {
      if (result) {
        setStateCallback();
      }
      return;
    }
    _groupService.checkIndexList(index: index);

    setStateCallback();
  }

  void changePage({required BuildContext context}) {
    goNextPage(
      context: context,
      index: index,
      page: ExpandCardPage(index: index),
      thenFunction: thenFunction,
    );
  }

  void unlockSelectOption() {
    if (!_groupService.checkOnLongPressIndexList(index: index)) {
      return;
    }
    _groupService.updateOnLongPressValues(index: index);

    _groupService.checkExpenseSelected(index: index);

    setStateCallback();
  }
}
