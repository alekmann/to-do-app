import 'package:flutter/material.dart';
import 'package:to_do_application/storage/listStorage.dart';
import 'package:to_do_application/widgets/futureTabs.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  ListStorage listStorage = ListStorage();
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue.shade50,
        body: Container(
          margin: const EdgeInsets.all(5),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              FutureTabs(),
            ],
          ),
        ),
      ),
    );
  }
}
