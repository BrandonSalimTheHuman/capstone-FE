import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl =
            (baseUrl ?? _resolveBaseUrl()).replaceAll(RegExp(r'/$'), '') {
    if (kDebugMode) {
      debugPrint('ApiService base URL: $_baseUrl');
    }
  }

  final http.Client _client;
  final String _baseUrl;

  static const Map<String, String> _phraseSynonyms = {
    'zero sugar': 'zerosugar',
    'sugar free': 'zerosugar',
    'no sugar': 'zerosugar',
    'diet': 'zerosugar',
    'full cream': 'fullcream',
    'low fat': 'lowfat',
  };

  static const Map<String, String> _tokenSynonyms = {
    'choc': 'chocolate',
    'choco': 'chocolate',
    'coca': 'cocacola',
    'cola': 'cocacola',
    '&': 'and',
    'n': 'and',
    'pkt': 'pack',
    'pk': 'pack',
    'pcs': 'pack',
    'ea': 'each',
  };

  static const Set<String> _stopTokens = {
    'the',
    'a',
    'an',
    'and',
    'with',
    'of',
    'in',
    'for',
    'to',
    'from',
    'by',
  };

  static String _resolveBaseUrl() {
    const definedBaseUrl = String.fromEnvironment('API_BASE_URL');
    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    if (definedBaseUrl.isNotEmpty) {
      if (isAndroid &&
          (definedBaseUrl.contains('127.0.0.1') ||
              definedBaseUrl.contains('localhost'))) {
        return definedBaseUrl
            .replaceAll('127.0.0.1', '10.0.2.2')
            .replaceAll('localhost', '10.0.2.2');
      }
      return definedBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:8000';
    }

    if (isAndroid) {
      return 'http://10.0.2.2:8000';
    }

    return 'http://localhost:8000';
  }

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse('$_baseUrl$path')
        .replace(queryParameters: queryParameters);
  }

  Future<List<Map<String, dynamic>>> _getList(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _client.get(_buildUri(path, queryParameters));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'GET $path failed with ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Expected a JSON list from $path');
    }

    return decoded
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }

  Future<Map<String, dynamic>> _getMap(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _client.get(_buildUri(path, queryParameters));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'GET $path failed with ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw Exception('Expected a JSON object from $path');
    }

    return Map<String, dynamic>.from(decoded);
  }

  Future<Map<String, dynamic>> _postMap(
      String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      _buildUri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'POST $path failed with ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw Exception('Expected a JSON object from $path');
    }

    return Map<String, dynamic>.from(decoded);
  }

  Future<Map<String, dynamic>> _putMap(
      String path, Map<String, dynamic> body) async {
    final response = await _client.put(
      _buildUri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'PUT $path failed with ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw Exception('Expected a JSON object from $path');
    }

    return Map<String, dynamic>.from(decoded);
  }

  int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  double _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    if (value is num) {
      return value.toDouble();
    }
    return 0;
  }

  String _normalizeToken(String token) {
    var normalized = _tokenSynonyms[token] ?? token;

    // Simple singularization for common plural noise.
    if (normalized.length > 3 && normalized.endsWith('s')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }

  String _normalizePhrases(String input) {
    var normalized = input;
    for (final entry in _phraseSynonyms.entries) {
      normalized = normalized.replaceAll(
        RegExp('\\b${RegExp.escape(entry.key)}\\b'),
        entry.value,
      );
    }
    return normalized;
  }

  bool _isSizeLikeToken(String token) {
    return RegExp(r'^\d+(?:\.\d+)?(?:g|kg|ml|l|pack|pk|ea|each)$')
            .hasMatch(token) ||
        RegExp(r'^\d+(?:\.\d+)?x\d+$').hasMatch(token);
  }

  String _buildDisplayName(String productName, String size) {
    final cleanedProductName = productName.trim();
    final cleanedSize = size.trim();
    if (cleanedSize.isEmpty) {
      return cleanedProductName;
    }

    final normalizedName =
        cleanedProductName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final normalizedSize = cleanedSize
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');

    if (normalizedSize.isNotEmpty && normalizedName.contains(normalizedSize)) {
      return cleanedProductName;
    }

    return '$cleanedProductName | $cleanedSize';
  }

  String _canonicalKey(String name, String size) {
    final cleanedName = _normalizePhrases(name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim());

    final tokens = cleanedName
        .split(' ')
        .where((token) => token.isNotEmpty)
        .map(_normalizeToken)
        .where((token) =>
            token.isNotEmpty &&
            !_stopTokens.contains(token) &&
            !_isSizeLikeToken(token))
        .toSet()
        .toList()
      ..sort();

    final normalizedSize = size
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');

    return '${tokens.join(' ')}|$normalizedSize';
  }

  List<GroceryItem> _mergeEquivalentItems(List<GroceryItem> items) {
    final grouped = <String, Map<String, dynamic>>{};

    for (final item in items) {
      final rawNameParts = item.name.split('|');
      final baseName = rawNameParts.first.trim();
      final size = rawNameParts.length > 1 ? rawNameParts.last.trim() : '';
      final key = _canonicalKey(baseName, size);

      final entry = grouped.putIfAbsent(key, () {
        return {
          'id': item.id,
          'name': item.name,
          'imageUrl': item.imageUrl,
          'pricesByStore': <String, StorePrice>{},
        };
      });

      // Keep the most descriptive display name.
      final existingName = (entry['name'] as String);
      if (item.name.length > existingName.length) {
        entry['name'] = item.name;
      }

      if ((entry['imageUrl'] as String).isEmpty && item.imageUrl.isNotEmpty) {
        entry['imageUrl'] = item.imageUrl;
      }

      final pricesByStore = entry['pricesByStore'] as Map<String, StorePrice>;
      for (final price in item.prices) {
        final existingPrice = pricesByStore[price.store];
        if (existingPrice == null || price.price < existingPrice.price) {
          pricesByStore[price.store] = price;
        }
      }
    }

    final merged = grouped.values.map((entry) {
      final pricesByStore = entry['pricesByStore'] as Map<String, StorePrice>;
      return GroceryItem(
        id: entry['id'] as String,
        name: entry['name'] as String,
        imageUrl: entry['imageUrl'] as String,
        prices: pricesByStore.values.toList(),
      );
    }).toList();

    return merged;
  }

  Future<Map<int, String>> fetchStoreNames() async {
    final stores =
        await _getList('/stores/', queryParameters: {'limit': '200'});
    final map = <int, String>{};

    for (final store in stores) {
      final id = _asInt(store['store_id']);
      final name = (store['store_name'] ?? '').toString();
      if (id > 0 && name.isNotEmpty) {
        map[id] = name;
      }
    }

    return map;
  }

  Future<List<Map<String, dynamic>>> _fetchProducts({
    String? query,
    int limit = 100,
  }) async {
    final cleanedQuery = query?.trim() ?? '';
    final params = {'skip': '0', 'limit': '$limit'};

    if (cleanedQuery.isNotEmpty) {
      return _getList('/products/search/', queryParameters: {
        ...params,
        'q': cleanedQuery,
      });
    }

    return _getList('/products/', queryParameters: params);
  }

  Future<List<Map<String, dynamic>>> _fetchProductStorePrices(
      int productId) async {
    try {
      return await _getList('/prices/compare/$productId');
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
            'Skipping price comparison for product $productId due to error: $error');
      }
      return [];
    }
  }

  Future<GroceryItem?> _mapProductToItem(
    Map<String, dynamic> product,
    Map<int, String> storeNames,
  ) async {
    final productId = _asInt(product['product_id']);
    if (productId <= 0) {
      return null;
    }

    final productName =
        (product['product_name'] ?? 'Unknown Product').toString();
    final size = (product['size'] ?? '').toString().trim();
    final displayName = _buildDisplayName(productName, size);

    final rawPrices = await _fetchProductStorePrices(productId);
    if (rawPrices.isEmpty) {
      return null;
    }

    final prices = rawPrices.map((priceData) {
      final storeId = _asInt(priceData['store_id']);
      final storeName = storeNames[storeId] ?? 'Store $storeId';

      return StorePrice(
        store: storeName,
        price: _asDouble(priceData['price']),
        logoAsset: storeName.toLowerCase(),
      );
    }).toList();

    return GroceryItem(
      id: productId.toString(),
      name: displayName,
      imageUrl: (product['image'] ?? '').toString(),
      prices: prices,
    );
  }

  Future<List<GroceryItem>> fetchCatalog(
      {String? query, int limit = 60}) async {
    final stores = await fetchStoreNames();
    final products = await _fetchProducts(query: query, limit: limit);

    // Avoid spiking the backend with dozens of parallel compare-price calls.
    const batchSize = 8;
    final cleaned = <GroceryItem>[];

    for (var i = 0; i < products.length; i += batchSize) {
      final batch = products.skip(i).take(batchSize).toList();
      final items = await Future.wait(
        batch.map((product) => _mapProductToItem(product, stores)),
      );
      cleaned.addAll(items.whereType<GroceryItem>());
    }

    final merged = _mergeEquivalentItems(cleaned);

    if (kDebugMode && merged.length != cleaned.length) {
      debugPrint(
          'Merged ${cleaned.length} raw items into ${merged.length} canonical items.');
    }

    merged.sort((a, b) => a.name.compareTo(b.name));
    return merged;
  }

  Future<List<ShoppingList>> fetchShoppingLists({
    required int userId,
    int limit = 100,
  }) async {
    final response = await _getList(
      '/lists/user/$userId',
      queryParameters: {'skip': '0', 'limit': '$limit'},
    );

    return response.map((row) {
      return ShoppingList(
        id: _asInt(row['parent_list_id']).toString(),
        name: (row['list_name'] ?? 'Untitled List').toString(),
        items: [],
      );
    }).toList();
  }

  Future<ShoppingList> fetchShoppingListDetail({
    required int parentListId,
  }) async {
    final storesById = await fetchStoreNames();
    final parent = await _getMap('/lists/$parentListId');

    final listName = (parent['list_name'] ?? 'Untitled List').toString();
    final storeLists = ((parent['store_lists'] ?? []) as List)
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();

    final items = <ShoppingListItem>[];

    for (final storeList in storeLists) {
      final storeId = _asInt(storeList['store_id']);
      final storeName = storesById[storeId] ?? 'Store $storeId';
      final rawItems = ((storeList['items'] ?? []) as List)
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();

      for (final rawItem in rawItems) {
        final productId = _asInt(rawItem['product_id']);
        final quantity = _asInt(rawItem['quantity']);
        if (productId <= 0) {
          continue;
        }

        Map<String, dynamic>? product;
        try {
          product = await _getMap('/products/$productId');
        } catch (_) {
          continue;
        }

        final productName =
            (product['product_name'] ?? 'Unknown Product').toString();
        final size = (product['size'] ?? '').toString().trim();
        final displayName = _buildDisplayName(productName, size);
        final rawPrices = await _fetchProductStorePrices(productId);

        final prices = rawPrices.map((priceData) {
          final dataStoreId = _asInt(priceData['store_id']);
          final dataStoreName = storesById[dataStoreId] ?? 'Store $dataStoreId';
          return StorePrice(
            store: dataStoreName,
            price: _asDouble(priceData['price']),
            logoAsset: dataStoreName.toLowerCase(),
          );
        }).toList();

        final selectedPriceData = rawPrices
            .cast<Map<String, dynamic>?>()
            .firstWhere(
                (priceData) => _asInt(priceData?['store_id']) == storeId,
                orElse: () => null);
        final selectedPrice = selectedPriceData == null
            ? null
            : StorePrice(
                store: storeName,
                price: _asDouble(selectedPriceData['price']),
                logoAsset: storeName.toLowerCase(),
              );

        final groceryItem = GroceryItem(
          id: productId.toString(),
          name: displayName,
          imageUrl: (product['image'] ?? '').toString(),
          prices: prices,
        );

        items.add(
          ShoppingListItem(
            item: groceryItem,
            quantity: quantity > 0 ? quantity : 1,
            selectedPrice: selectedPrice,
            backendListItemId: _asInt(rawItem['list_item_id']),
          ),
        );
      }
    }

    return ShoppingList(
      id: parentListId.toString(),
      name: listName,
      items: items,
    );
  }

  Future<ShoppingList> createShoppingList({
    required int userId,
    required String name,
  }) async {
    final created = await _postMap('/lists/', {
      'user_id': userId,
      'list_name': name,
    });

    return ShoppingList(
      id: _asInt(created['parent_list_id']).toString(),
      name: (created['list_name'] ?? name).toString(),
      items: [],
    );
  }

  Future<void> addProductToList({
    required int parentListId,
    required int productId,
    required String storeName,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      return;
    }

    final stores = await fetchStoreNames();
    int? storeId;
    for (final entry in stores.entries) {
      if (entry.value.toLowerCase().trim() == storeName.toLowerCase().trim()) {
        storeId = entry.key;
        break;
      }
    }

    if (storeId == null) {
      throw Exception('Store "$storeName" was not found in backend stores.');
    }

    final parent = await _getMap('/lists/$parentListId');
    final storeLists = ((parent['store_lists'] ?? []) as List)
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();

    Map<String, dynamic>? targetStoreList;
    for (final storeList in storeLists) {
      if (_asInt(storeList['store_id']) == storeId) {
        targetStoreList = storeList;
        break;
      }
    }

    if (targetStoreList == null) {
      targetStoreList = await _postMap('/lists/$parentListId/stores/', {
        'store_id': storeId,
      });
      targetStoreList['items'] = [];
    }

    final storeListId = _asInt(targetStoreList['store_list_id']);
    final items = ((targetStoreList['items'] ?? []) as List)
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();

    Map<String, dynamic>? existingItem;
    for (final item in items) {
      if (_asInt(item['product_id']) == productId) {
        existingItem = item;
        break;
      }
    }

    if (existingItem != null) {
      final itemId = _asInt(existingItem['list_item_id']);
      final currentQty = _asInt(existingItem['quantity']);
      await _putMap('/items/$itemId', {
        'quantity': currentQty + quantity,
      });
      return;
    }

    await _postMap('/store-lists/$storeListId/items/', {
      'product_id': productId,
      'quantity': quantity,
      'is_checked': false,
    });
  }

  Future<void> updateListItemQuantity({
    required int listItemId,
    required int quantity,
  }) async {
    if (listItemId <= 0 || quantity <= 0) {
      return;
    }

    await _putMap('/items/$listItemId', {
      'quantity': quantity,
    });
  }

  Future<void> deleteListItem({
    required int listItemId,
  }) async {
    if (listItemId <= 0) {
      return;
    }

    final uri = _buildUri('/items/$listItemId');
    final response = await _client.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'DELETE /items/$listItemId failed (${response.statusCode}): '
        '${response.body}',
      );
    }
  }
}
