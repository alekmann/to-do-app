import 'package:flutter/material.dart';
import 'package:to_do_application/widgets/addList.dart';
import 'package:to_do_application/widgets/tabs.dart';

void main() {
  runApp(const MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false,));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('ToDo-app'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  AddList.addListDialog(context).then((_) => setState(() {}));
                },
                child: const Icon(
                  Icons.add,
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
        body: Tabs(),
      ),
    );
  }
}

