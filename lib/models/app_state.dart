import 'package:flutter/material.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = true;
  String _userName = 'Brandon';
  List<ShoppingList> _lists = SampleData.lists;

  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;
  List<ShoppingList> get lists => _lists;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void addList(String name) {
    _lists.add(ShoppingList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: [],
    ));
    notifyListeners();
  }

  void addItemToList(String listId, ShoppingListItem item) {
    final list = _lists.firstWhere((l) => l.id == listId);
    list.items.add(item);
    notifyListeners();
  }

  void updateItemQuantity(String listId, String itemId, int quantity) {
    final list = _lists.firstWhere((l) => l.id == listId);
    final item = list.items.firstWhere((i) => i.item.id == itemId);
    item.quantity = quantity;
    notifyListeners();
  }
}
