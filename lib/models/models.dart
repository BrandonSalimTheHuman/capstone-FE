class GroceryItem {
  final String id;
  final String name;
  final String imageUrl;
  final List<StorePrice> prices;

  GroceryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.prices,
  });

  double get cheapestPrice =>
      prices.map((p) => p.price).reduce((a, b) => a < b ? a : b);

  StorePrice get cheapestStore =>
      prices.reduce((a, b) => a.price < b.price ? a : b);
}

class StorePrice {
  final String store;
  final double price;
  final String logoAsset;

  StorePrice({
    required this.store,
    required this.price,
    required this.logoAsset,
  });
}

class ShoppingList {
  final String id;
  String name;
  List<ShoppingListItem> items;

  ShoppingList({required this.id, required this.name, required this.items});

  double get totalPrice => items.fold(
        0,
        (sum, item) => sum + (item.selectedPrice?.price ?? 0) * item.quantity,
      );

  List<String> get stores => items
      .where((i) => i.selectedPrice != null)
      .map((i) => i.selectedPrice!.store)
      .toSet()
      .toList();
}

class ShoppingListItem {
  final GroceryItem item;
  int quantity;
  StorePrice? selectedPrice;

  ShoppingListItem({
    required this.item,
    this.quantity = 1,
    this.selectedPrice,
  });
}

// Sample data
class SampleData {
  static List<GroceryItem> get items => [
        GroceryItem(
          id: '1',
          name: 'Whole Milk',
          imageUrl: 'milk',
          prices: [
            StorePrice(store: 'SuperMart', price: 3.99, logoAsset: 'supermart'),
            StorePrice(store: 'Coles', price: 4.50, logoAsset: 'coles'),
            StorePrice(store: 'Woolworths', price: 4.20, logoAsset: 'woolworths'),
          ],
        ),
        GroceryItem(
          id: '2',
          name: 'Chicken Breast',
          imageUrl: 'chicken',
          prices: [
            StorePrice(store: 'SuperMart', price: 2.99, logoAsset: 'supermart'),
            StorePrice(store: 'Coles', price: 3.50, logoAsset: 'coles'),
            StorePrice(store: 'Woolworths', price: 3.20, logoAsset: 'woolworths'),
          ],
        ),
        GroceryItem(
          id: '3',
          name: 'Canned Tomatoes',
          imageUrl: 'tomatoes',
          prices: [
            StorePrice(
                store: 'Discount Grocer', price: 1.79, logoAsset: 'discount'),
            StorePrice(store: 'Coles', price: 2.20, logoAsset: 'coles'),
            StorePrice(store: 'Woolworths', price: 2.00, logoAsset: 'woolworths'),
          ],
        ),
        GroceryItem(
          id: '4',
          name: 'Avocado',
          imageUrl: 'avocado',
          prices: [
            StorePrice(
                store: 'Fresh Foods', price: 4.29, logoAsset: 'freshfoods'),
            StorePrice(store: 'Coles', price: 4.80, logoAsset: 'coles'),
            StorePrice(store: 'Woolworths', price: 4.50, logoAsset: 'woolworths'),
          ],
        ),
        GroceryItem(
          id: '5',
          name: 'Organic Bananas',
          imageUrl: 'bananas',
          prices: [
            StorePrice(
                store: 'Fresh Foods', price: 2.49, logoAsset: 'freshfoods'),
            StorePrice(store: 'Coles', price: 2.80, logoAsset: 'coles'),
            StorePrice(store: 'Woolworths', price: 2.60, logoAsset: 'woolworths'),
          ],
        ),
        GroceryItem(
          id: '6',
          name: 'Coca-Cola Classic Soft Drink Bottle | 1.25L',
          imageUrl: 'coke',
          prices: [
            StorePrice(store: 'Coles', price: 4.00, logoAsset: 'coles'),
            StorePrice(store: 'Aldi', price: 3.25, logoAsset: 'aldi'),
            StorePrice(store: 'Woolworths', price: 5.25, logoAsset: 'woolworths'),
            StorePrice(store: 'IGA', price: 5.50, logoAsset: 'iga'),
          ],
        ),
        GroceryItem(
          id: '7',
          name: 'Coca-Cola Zero Sugar Soft Drink Bottle | 1.25L',
          imageUrl: 'coke_zero',
          prices: [
            StorePrice(store: 'Coles', price: 4.00, logoAsset: 'coles'),
            StorePrice(store: 'Aldi', price: 3.25, logoAsset: 'aldi'),
            StorePrice(store: 'Woolworths', price: 5.00, logoAsset: 'woolworths'),
            StorePrice(store: 'IGA', price: 5.50, logoAsset: 'iga'),
          ],
        ),
      ];

  static List<ShoppingList> get lists => [
        ShoppingList(
          id: '1',
          name: 'Party Supplies',
          items: [],
        ),
        ShoppingList(
          id: '2',
          name: 'Weekly Groceries',
          items: [],
        ),
        ShoppingList(
          id: '3',
          name: 'Household Essentials',
          items: [],
        ),
        ShoppingList(
          id: '4',
          name: 'Back to School',
          items: [],
        ),
      ];
}
