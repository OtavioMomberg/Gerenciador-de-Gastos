import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/expand_card_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';

class ExpenseCard extends StatelessWidget with ChangePage {
  final int index;
  final void Function({bool? response})? thenFunction;
  final VoidCallback setStateCallback;

  ExpenseCard({
    required this.index, 
    required this.setStateCallback,
    this.thenFunction,
    super.key
  });

  final _db = DatabaseService.instance();
  final groupService = GroupService.instance();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: groupService.checkColor[index]
        ? groupService.colors[1]
        : groupService.colors[0],
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          groupService.isExpenseSelected ? selectCard() : changePage(context: context);
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
                     _db.expensesWithoutFuture[index].name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      _db.expensesWithoutFuture[index].date,
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
                  "R\$ ${_db.expensesWithoutFuture[index].price}",
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
    if (groupService.cardIndex == index && groupService.indexList.length > 1) { return; }
      if (groupService.cardIndex == index && groupService.indexList.length == 1) {
        groupService.isExpenseSelected = !groupService.isExpenseSelected;
        groupService.indexList.clear();
        groupService.checkColor.clear();
        groupService.checkColor = List.generate(_db.expensesWithoutFuture.length, (index) => false);
        setStateCallback();
        return;
      }
      final id = _db.expensesWithoutFuture[index].id;

      if (groupService.indexList.contains(id)) {
        groupService.indexList.remove(id);
        groupService.checkColor[index] = false;
      } else {
        groupService.indexList.add(id);
        groupService.checkColor[index] = true;
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
    final id = _db.expensesWithoutFuture[index].id;

    if (groupService.indexList.isNotEmpty) {
      if (!groupService.indexList.contains(id)) { return; } 
    }

    groupService.cardIndex = index;
    groupService.isExpenseSelected = !groupService.isExpenseSelected;

    if (groupService.isExpenseSelected) { 
      groupService.indexList.add(id);
      groupService.checkColor[index] = true;
    } else {
      groupService.indexList.clear();
      groupService.checkColor.clear();
      groupService.checkColor = List.generate(_db.expensesWithoutFuture.length, (index) => false);
    }
    setStateCallback();
  }
}
