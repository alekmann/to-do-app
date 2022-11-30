import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../widgets/futureTabs.dart';

// Class that writes to file
class ListStorage {
  // Gets local path and return as String
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Returns the local file specified with name
  Future<File> _localFile(String name) async {
    final path = await _localPath;
    return File('$path/$name');
  }

  // Creates starter folder if not already there.
  Future<void> createFolder() async {
    const folderName = "listAndItems";

    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;

    final path = Directory("$dir/$folderName");

    if (await path.exists()) {
    } else {
      path.create();
    }
  }

  // Create new file with same name as object.
  Future<void> addList(String name) async {
    createFolder();
    final file = await _localFile("/listAndItems/$name");
    ListAndItems lai = ListAndItems(name, []);

    String jsonLai = jsonEncode(lai);

    // Write the file
    try {
      file.writeAsString(jsonLai);
    } catch (e) {
      print("Det skjedde en feil: $e");
    }
  }

  // Adds item to list/file.
  Future<void> addItem(String listName, CheckBoxItem item) async {
    createFolder();
    final file = await _localFile("/listAndItems/$listName");

    // Read file
    String contents = await file.readAsString();
    var jsonRespons = jsonDecode(contents);

    ListAndItems res = ListAndItems.fromJson(jsonRespons);

    res.items?.add(item);

    String jsonRes = jsonEncode(res);

    // Write to file
    try {
      file.writeAsString(jsonRes);
    } catch (e) {
      print("Could not add item to list: $e");
    }
  }

  //Reads file and returns content
  Future<ListAndItems> readList(String name) async {
    createFolder();

    final file = await _localFile("/listAndItems/$name");

    // Read the file
    String contents = await file.readAsString();
    var jsonResponse = jsonDecode(contents);

    // Return object
    ListAndItems res = ListAndItems.fromJson(jsonResponse);

    return res;
  }

  // Returns all listAndItems instances/file names
  Future<List<String>> getListNames() async {
    createFolder();

    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/listAndItems';
    final myDir = Directory(pdfDirectory);

    var _folders = myDir.listSync(recursive: true, followLinks: false);

    List<String> fse = [];

    for (FileSystemEntity f in _folders) {
      fse.add(basename(f.toString().substring(0, f.toString().length - 1)));
    }

    return fse;
  }

  // Returns the items of a list.
  Future<List<CheckBoxItem>> getItems(String listName) async {
    createFolder();

    final file = await _localFile("/listAndItems/$listName");

    // Read the file
    String contents = await file.readAsString();
    var jsonResponse = jsonDecode(contents);

    // Return object
    ListAndItems res = ListAndItems.fromJson(jsonResponse);

    List<CheckBoxItem> cbiList = [];

    for (CheckBoxItem cbi in res.items!) {
      cbiList.add(cbi);
    }

    return cbiList;
  }

  // Changes the isChecked of a Checkbox item
  Future<int> changeIsChecked(String listName, List<CheckBoxItem> cbi) async {
    createFolder();

    final file = await _localFile("/listAndItems/$listName");

    ListAndItems newLai = ListAndItems(listName, cbi);

    String jsonRes = jsonEncode(newLai);

    // Write to file
    try {
      file.writeAsString(jsonRes);
    } catch (e) {
      print("Could not change isChecked: $e");
    }
    return 0;
  }

  // Returns the to-do items
  Future<List<CheckBoxItem>> getToDoItems(String listName) async {
    createFolder();

    final file = await _localFile("/listAndItems/$listName");

    // Read the file
    String contents = await file.readAsString();
    var jsonResponse = jsonDecode(contents);

    // Return object
    ListAndItems res = ListAndItems.fromJson(jsonResponse);

    List<CheckBoxItem> cbiList = [];

    for (CheckBoxItem cbi in res.items!) {
      if (cbi.isChecked == false) {
        cbiList.add(cbi);
      }
    }

    return cbiList;
  }

  // Returns done items
  Future<List<CheckBoxItem>> getDoneItems(String listName) async {
    createFolder();

    final file = await _localFile("/listAndItems/$listName");

    // Read the file
    String contents = await file.readAsString();
    var jsonResponse = jsonDecode(contents);

    // Return object
    ListAndItems res = ListAndItems.fromJson(jsonResponse);

    List<CheckBoxItem> cbiList = [];

    for (CheckBoxItem cbi in res.items!) {
      if (cbi.isChecked) {
        cbiList.add(cbi);
      }
    }
    return cbiList;
  }

  // Deletes a file/list
  void deleteList(String listName) async {
    createFolder();

    try {
      final file = await _localFile("/listAndItems/$listName");
      await file.delete();
    } catch (e) {
      print("Could not delete file: $e");
    }
  }
}

class ListAndItems {
  late String name;
  late List<CheckBoxItem>? items;

  ListAndItems(this.name, [this.items]);

  Map toJson() => {'name': name, 'items': items};

  factory ListAndItems.fromJson(dynamic json) {
    final itemsList = json['items'] as List;
    List items = itemsList.map((i) => CheckBoxItem.fromJson(i)).toList();

    return ListAndItems(json['name'] as String, items as List<CheckBoxItem>);
  }

  @override
  String toString() {
    return "navn: $name" + ", items: $items";
  }
}
