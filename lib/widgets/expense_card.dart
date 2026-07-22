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
        
      elevation: 5,
      type: MaterialType.card,
      //shadowColor: groupService.colors[groupService.indexColor].withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: const Color.fromARGB(255, 234, 242, 252),
        highlightColor: const Color.fromARGB(255, 234, 242, 252),
        onTap: () {
          if (groupService.isExpenseSelected) {
            if (groupService.cardIndex == index) { return; }

            final id = _db.expenses[index].id;

            if (groupService.indexList.contains(id)) {
              groupService.indexList.remove(id);
              groupService.checkColor[index] = false;
            } else {
              groupService.indexList.add(id);
              groupService.checkColor[index] = true;
            }
            setStateCallback();
          } else {  
            goNextPage(
              context: context, 
              index: index, 
              page: ExpandCardPage(index: index),
              thenFunction: thenFunction,
            );
          }
        },
        onLongPress: () {
          /*if (groupService.indexList.isNotEmpty) {
            if (groupService.indexList.first != index) {
              return;
            }
          }*/
          groupService.cardIndex = index;
          final id = _db.expenses[index].id;
          groupService.isExpenseSelected = !groupService.isExpenseSelected;

          if (groupService.isExpenseSelected) { 
            groupService.indexList.add(id);
            groupService.checkColor[index] = true;
          } else {
            groupService.indexList.clear();
            groupService.checkColor.clear();
            groupService.checkColor = List.generate(_db.expenses.length, (index) => false);
          }
          setStateCallback();
        },
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
                      _db.expenses[index].name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      _db.expenses[index].date,
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
                  "R\$ ${_db.expenses[index].price}",
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
}
