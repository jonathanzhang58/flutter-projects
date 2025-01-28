import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/data/dummy_items.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
String? _error;
List<GroceryItem> _groceryItems = [];
bool _isLoading = true;
  void _loadItems() async {
    final url = Uri.https(
        'flutter-test-9e58b-default-rtdb.firebaseio.com', 'shopping-list.json');
    try {
  final response = await http.get(url);
   if (response.statusCode >= 400) {
      setState(() {

        setState(() {
          _error = 'Failed to load items, try again later.';
        });
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    json.decode(response.body);
    final Map<String, dynamic> listData  = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries){
         final category = categories.entries.firstWhere((i)=> i.value.title == item.value['category']).value;
          loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity: int.parse(item.value['quantity']), category: category));
      }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
} on Exception catch (e) {
  setState(() {
      _error = 'Failed to load items, try again later.';
  });
}
   
  }

  void _removeItem(GroceryItem item) async {
   final index = _groceryItems.indexOf(item);
       setState(() {
      _groceryItems.remove(item);
      
    });
   final url = Uri.https('flutter-test-9e58b-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');
   final response = await http.delete(url);
   if (response.statusCode >= 400) {
     setState(() {
      _groceryItems.insert(index, item);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete item.')));
     });
   }

  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    _loadItems();

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No items added yet."),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(
                _groceryItems[index].quantity.toString(),
              )),
        ),
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grocery List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addItem,
            )
          ],
        ),
        body: content);
  }
}
