import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/pages/expand_card_page.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';

class ExpenseCard extends StatelessWidget with ChangePage {
  final int index;
  final void Function({bool? response})? thenFunction;
  final VoidCallback setStateCallback;
  final ExpenseRead expense;
  final int length;

  ExpenseCard({
    required this.index,
    required this.setStateCallback,
    required this.expense,
    required this.length,
    this.thenFunction,
    super.key,
  });

  final groupService = GroupService.instance();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: groupService.indexList.contains(index)
        ? groupService.colors[1]
        : groupService.colors[0],
      elevation: 5,
      shadowColor: groupService.indexList.contains(index)
        ? groupService.colors[1]
        : groupService.colors[0],
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          groupService.isExpenseSelected
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
                      style: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      expense.date,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.bold
                      )
                    )
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "R\$ ${expense.price}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 136, 136, 136),
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  void selectCard() {
    if (groupService.cardIndex == index && groupService.indexList.length > 1) {
      return;
    }
    if (groupService.cardIndex == index && groupService.indexList.length == 1) {
      groupService.isExpenseSelected = !groupService.isExpenseSelected;
      groupService.indexList.clear();
      setStateCallback();
      return;
    }

    if (groupService.indexList.contains(index)) {
      groupService.indexList.remove(index);
    } else {
      groupService.indexList.add(index);
    }
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
    if (groupService.indexList.isNotEmpty) {
      if (!groupService.indexList.contains(index)) {
        return;
      }
    }

    groupService.cardIndex = index;
    groupService.isExpenseSelected = !groupService.isExpenseSelected;

    if (groupService.isExpenseSelected) {
      groupService.indexList.add(index);
    } else {
      groupService.indexList.clear();
    }
    setStateCallback();
  }
}
