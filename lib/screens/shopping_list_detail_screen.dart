import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'product_screen.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  final ShoppingList list;
  final bool isDark;

  const ShoppingListDetailScreen({
    super.key,
    required this.list,
    this.isDark = true,
  });

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _api = ApiService();
  late TabController _tabController;
  late List<String> _stores;
  late Map<String, List<_ListItem>> _storeItems;
  final Set<int> _updatingItemIds = <int>{};

  @override
  void initState() {
    super.initState();

    _storeItems = _buildStoreItems();
    _stores = _storeItems.keys.toList();
    if (_stores.isEmpty) {
      _stores = ['All Items'];
      _storeItems = {'All Items': []};
    }

    _tabController = TabController(length: _stores.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  Map<String, List<_ListItem>> _buildStoreItems() {
    final grouped = <String, List<_ListItem>>{};

    for (final shoppingItem in widget.list.items) {
      final store = shoppingItem.selectedPrice?.store ?? 'Unassigned';
      final unitPrice = shoppingItem.selectedPrice?.price ?? 0;

      grouped.putIfAbsent(store, () => []);
      grouped[store]!.add(
        _ListItem(
          item: shoppingItem.item,
          backendListItemId: shoppingItem.backendListItemId,
          name: shoppingItem.item.name,
          price: unitPrice,
          quantity: shoppingItem.quantity,
          emoji: _emojiForItem(shoppingItem.item.name),
        ),
      );
    }

    return grouped;
  }

  String _emojiForItem(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('milk')) {
      return '🥛';
    }
    if (lower.contains('bread')) {
      return '🍞';
    }
    if (lower.contains('banana')) {
      return '🍌';
    }
    if (lower.contains('apple')) {
      return '🍎';
    }
    if (lower.contains('drink') || lower.contains('coca')) {
      return '🥤';
    }
    return '🛒';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double _getStoreTotal(String store) {
    return (_storeItems[store] ?? []).fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  double _getGrandTotal() {
    return _storeItems.values
        .expand((items) => items)
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> _increaseItemQuantity(String store, _ListItem item) async {
    final listItemId = item.backendListItemId;
    if (listItemId == null || listItemId <= 0) {
      setState(() => item.quantity++);
      return;
    }

    if (_updatingItemIds.contains(listItemId)) {
      return;
    }

    setState(() {
      _updatingItemIds.add(listItemId);
      item.quantity++;
    });

    try {
      await _api.updateListItemQuantity(
        listItemId: listItemId,
        quantity: item.quantity,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => item.quantity--);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update item quantity.')),
      );
    } finally {
      if (mounted) {
        setState(() => _updatingItemIds.remove(listItemId));
      }
    }
  }

  Future<void> _decreaseItemQuantity(String store, _ListItem item) async {
    final listItemId = item.backendListItemId;
    if (listItemId == null || listItemId <= 0) {
      setState(() {
        if (item.quantity > 1) {
          item.quantity--;
          return;
        }
        _storeItems[store]?.remove(item);
      });
      return;
    }

    if (_updatingItemIds.contains(listItemId)) {
      return;
    }

    if (item.quantity > 1) {
      setState(() {
        _updatingItemIds.add(listItemId);
        item.quantity--;
      });

      try {
        await _api.updateListItemQuantity(
          listItemId: listItemId,
          quantity: item.quantity,
        );
      } catch (_) {
        if (!mounted) {
          return;
        }

        setState(() => item.quantity++);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update item quantity.')),
        );
      } finally {
        if (mounted) {
          setState(() => _updatingItemIds.remove(listItemId));
        }
      }
      return;
    }

    setState(() => _updatingItemIds.add(listItemId));
    try {
      await _api.deleteListItem(listItemId: listItemId);
      if (!mounted) {
        return;
      }

      setState(() {
        _storeItems[store]?.remove(item);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not remove item from list.')),
      );
    } finally {
      if (mounted) {
        setState(() => _updatingItemIds.remove(listItemId));
      }
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: (widget.isDark ? Colors.white : Colors.black)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    label: Text(
                      'Export PDF',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          widget.isDark ? Colors.white70 : Colors.black54,
                      side: BorderSide(
                        color: widget.isDark ? Colors.white24 : Colors.black12,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(
                      'Share Code',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.isDark ? AppColors.purple : Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final totalBg = isDark ? AppColors.darkCard : AppColors.lightSurface;
    final activeTabColor = isDark ? AppColors.purple : Colors.black;
    final currentStore = _stores[_tabController.index];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: textColor),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.list.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showShareOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Share',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Store tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: textColor,
              unselectedLabelColor: textColor.withOpacity(0.4),
              labelStyle: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
              indicatorColor: activeTabColor,
              indicatorWeight: 2.5,
              tabs: _stores.map((s) => Tab(text: s)).toList(),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _stores.map((store) {
                  final items = _storeItems[store] ?? [];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No items in this list yet.',
                        style: GoogleFonts.poppins(
                          color: textColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductScreen(
                                item: item.item,
                                isDark: isDark,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(item.emoji,
                                      style: const TextStyle(fontSize: 28)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.name} - \$${item.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity} ${item.quantity == 1 ? 'item' : 'items'}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: textColor.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Row(
                                children: [
                                  _QBtn(
                                    icon: Icons.remove,
                                    isDark: isDark,
                                    onTap: () =>
                                        _decreaseItemQuantity(store, item),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${item.quantity}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  _QBtn(
                                    icon: Icons.add,
                                    isDark: isDark,
                                    onTap: () =>
                                        _increaseItemQuantity(store, item),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            // Total bar
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: totalBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$currentStore total',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        '\$${_getStoreTotal(currentStore).toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Grand total (all stores)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        '\$${_getGrandTotal().toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.purpleLight
                              : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _QBtn({required this.icon, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDark ? AppColors.purple : Colors.black,
          shape: BoxShape.circle,
        ),
        child:
            Icon(icon, color: isDark ? Colors.black : Colors.white, size: 18),
      ),
    );
  }
}

class _ListItem {
  final GroceryItem item;
  final int? backendListItemId;
  final String name;
  final double price;
  int quantity;
  final String emoji;

  _ListItem({
    required this.item,
    this.backendListItemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.emoji,
  });
}
