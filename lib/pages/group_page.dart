import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';

class GroupPage extends StatelessWidget {
  GroupPage({super.key});
  final _db = DatabaseService.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text("Meus Gastos"),
            Expanded(
              child: ListView.builder(
                itemCount: _db.expenses.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        color: const Color.fromARGB(255, 210, 232, 236),
                        child: Center(child: Text(_db.expenses[index].name))
                      )
                    ),
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}