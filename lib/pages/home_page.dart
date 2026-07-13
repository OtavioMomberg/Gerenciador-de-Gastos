import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/create_group_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';
import 'package:gerenciador_gastos_v2/utils/text_controllers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = DatabaseService.instance();
  final textControllers = TextControllers.instance();
  
  @override
  void initState() {
    super.initState();
    _db.selectGroups();
    textControllers.getGroupControllers();
    textControllers.getExpenseControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 50,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => createPageGroupPage(), 
                child: const Text("Criar Grupo")
              ),
              ElevatedButton(onPressed: (){}, child: const Text("Adicionar Gasto")),
              const Text("Meus Grupos"),
              SizedBox(
                height: 200,
                child: FutureBuilder(
                  future: _db.groups, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Não tem grupo");
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemExtent: (MediaQuery.of(context).size.width -20) * 0.5,
                      itemBuilder: (context, index) {
                        return Card(
                          color: ColorConversion.colorsMap[snapshot.data![index].color],
                          child: Center(child: Text(snapshot.data![index].name))
                        );
                      }
                    );
                  }
                )
              )
            ]
          )
        )
      )
    );
  }

  Future<void> createPageGroupPage() async {
    await Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, _, _) => CreateGroupPage(),
        transitionsBuilder: (_, animation, _, child) {
          final begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child
          );
        }
      )
    ).then((_) => setState((){
      _db.selectGroups();
    }));
    textControllers.clearGroupsList();
  }

  @override
  void dispose() {
    textControllers.getGroupControllers();
    textControllers.getExpenseControllers();

    if (textControllers.groupsList.isNotEmpty) { 
      for (var group in textControllers.groupsList) {
        group.dispose();
      }
    }

    if (textControllers.groupsList.isNotEmpty) {
      for (var expense in textControllers.expensesList) {
        expense.dispose();
      }
    }

    super.dispose();
  }
}