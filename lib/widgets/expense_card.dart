import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/expand_card_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';

class ExpenseCard extends StatelessWidget with ChangePage {
  final int index;
  final void Function({bool? response})? thenFunction;

  ExpenseCard({
    required this.index, 
    this.thenFunction,
    super.key
  });

  final _db = DatabaseService.instance();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 210, 232, 236),
      elevation: 10,
      shadowColor: const Color.fromARGB(255, 210, 232, 236).withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          goNextPage(
            context: context, 
            index: index, 
            page: ExpandCardPage(index: index),
            thenFunction: thenFunction,
          );
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
