import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

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
  late TabController _tabController;
  final List<String> _stores = ['Aldi', 'Coles', 'Woolworths'];

  // Sample items per store tab (replace with real data from ShoppingList.items)
  final Map<String, List<_ListItem>> _storeItems = {
    'Aldi': [
      _ListItem(name: 'Apples', price: 2.50, quantity: 2, emoji: '🍎'),
      _ListItem(name: 'Bananas', price: 2.49, quantity: 1, emoji: '🍌'),
      _ListItem(name: 'Whole Milk 2L', price: 3.99, quantity: 1, emoji: '🥛'),
    ],
    'Coles': [
      _ListItem(name: 'Orange Juice 1L', price: 4.50, quantity: 1, emoji: '🍊'),
      _ListItem(name: 'Pepsi | 250ml', price: 2.00, quantity: 2, emoji: '🥤'),
      _ListItem(name: 'Bread', price: 3.20, quantity: 1, emoji: '🍞'),
    ],
    'Woolworths': [
      _ListItem(name: 'Whole Milk 2L', price: 4.20, quantity: 1, emoji: '🥛'),
      _ListItem(name: 'Chicken Breast', price: 8.50, quantity: 1, emoji: '🍗'),
      _ListItem(name: 'Avocado', price: 4.50, quantity: 2, emoji: '🥑'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stores.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
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

  double get _grandTotal =>
      _stores.fold(0.0, (s, store) => s + _getStoreTotal(store));

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
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
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
                        'No items for $store',
                        style: GoogleFonts.poppins(
                          color: textColor.withOpacity(0.4),
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
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)} each',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.5),
                                    ),
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
                                  onTap: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        items.removeAt(index);
                                      }
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                _QBtn(
                                  icon: Icons.add,
                                  isDark: isDark,
                                  onTap: () => setState(() => item.quantity++),
                                ),
                              ],
                            ),
                          ],
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
                        '\$${_grandTotal.toStringAsFixed(2)}',
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
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _ListItem {
  final String name;
  final double price;
  int quantity;
  final String emoji;

  _ListItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.emoji,
  });
}
