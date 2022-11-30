import 'package:flutter/material.dart';
import 'package:to_do_application/storage/listStorage.dart';

final _formKey = GlobalKey<FormState>();
ListStorage listStorage = ListStorage();
TextEditingController listNameController = TextEditingController();

// Add list popup
class AddList {
  static Future<void> addListDialog(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: listNameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.list_alt),
                            hintText: 'Navn på liste',
                            labelText: 'Navn *',
                          ),
                          onFieldSubmitted: (value) {
                            _formKey.currentState?.save();
                            listStorage.addList(listNameController.text);
                            listNameController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Lagre"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              listStorage.addList(listNameController.text);
                              listNameController.clear();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
