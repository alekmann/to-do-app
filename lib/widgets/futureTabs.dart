import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_application/storage/listStorage.dart';

class FutureTabs extends StatefulWidget {
  const FutureTabs({Key? key}) : super(key: key);

  @override
  State<FutureTabs> createState() => _FutureTabsState();
}

// Class with widgets
class _FutureTabsState extends State<FutureTabs> {
  ListStorage listStorage = ListStorage();
  List<String> currentList = [];
  int current = 0;

  TextEditingController itemController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: listStorage.getListNames(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData && snapshot.data?.length != 0) {
          currentList = snapshot.data!;
          return Column(
            children: [
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.all(5),
                            width: 80,
                            height: 45,
                            decoration: BoxDecoration(
                                color: current == index
                                    ? Colors.white
                                    : Colors.white70,
                                borderRadius: current == index
                                    ? BorderRadius.circular(10)
                                    : BorderRadius.circular(5),
                                border: current == index
                                    ? Border.all(
                                        color: Colors.lightBlue.shade300,
                                        width: 2)
                                    : null),
                            child: Center(
                              child: Text(
                                snapshot.data![index],
                                style: GoogleFonts.laila(
                                    fontWeight: FontWeight.w600,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey.shade500),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: current == index,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                // width: double.infinity,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            controller: itemController,
                            decoration: const InputDecoration.collapsed(
                                hintText: "Navn på arbeidsoppgave"),
                            validator: (value) {
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              setState(() {
                                listStorage.addItem(currentList[current],
                                    CheckBoxItem(itemController.text, false));
                                itemController.clear();
                              });
                            },
                            onEditingComplete: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  listStorage.addItem(currentList[current],
                                      CheckBoxItem(itemController.text, false));
                                  itemController.clear();
                                });
                                setState(() {});
                              },
                              child: const Text("Legg til"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 500,
                child: FutureBuilder<List<CheckBoxItem>>(
                  future: listStorage.getItems(snapshot.data![current]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CheckBoxItem> _items = snapshot.data!;

                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            const Text("To Do: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25)),
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: _items
                                  .where((i) => i.isChecked == false)
                                  .map(
                                    (CheckBoxItem item) => CheckboxListTile(
                                      title: Text(item.title),
                                      value: item.isChecked,
                                      onChanged: (bool? val) async {
                                        item.isChecked = val!;
                                        await listStorage.changeIsChecked(
                                            currentList[current], _items);

                                        setState(() {});
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                            const Text(
                              "Done: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: _items
                                  .where((i) => i.isChecked)
                                  .map(
                                    (CheckBoxItem item) => CheckboxListTile(
                                      title: Text(item.title),
                                      value: item.isChecked,
                                      onChanged: (bool? val) async {
                                        item.isChecked = val!;
                                        await listStorage.changeIsChecked(
                                            currentList[current], _items);

                                        setState(() {});
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  listStorage.deleteList(currentList[current]);
                  if (current != 0) {
                    current -= 1;
                  }
                  setState(() {});
                },
                child: const Text("Slett liste"),
              ),
            ],
          );
        } else {
          return Container(
            child: Column(
              children: const [Text("Trykk på + for å legge til en ny liste!")],
            ),
          );
        }
      },
    );
  }
}

class CheckBoxItem {
  String title;
  bool isChecked;

  CheckBoxItem(this.title, this.isChecked);

  factory CheckBoxItem.fromJson(dynamic json) {
    return CheckBoxItem(json['title'] as String, json['isChecked'] as bool);
  }

  Map toJson() => {'title': title, 'isChecked': isChecked};

  @override
  String toString() {
    return "Tittel: $title, isChecked: $isChecked";
  }
}
