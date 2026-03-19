import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  final ShoppingList list;
  final bool isDark;

  const ShoppingListDetailScreen(
      {super.key, required this.list, this.isDark = true});

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _stores = ['Aldi List', 'Coles List', 'Woolworths List'];

  // Sample items per store
  final Map<String, List<_ListItem>> _storeItems = {
    'Aldi List': [
      _ListItem(name: 'Apples', price: 2.50, quantity: 2, emoji: '🍎'),
      _ListItem(name: 'Bananas', price: 3.00, quantity: 1, emoji: '🍌'),
    ],
    'Coles List': [
      _ListItem(name: 'Orange', price: 1.50, quantity: 2, emoji: '🍊'),
      _ListItem(name: 'Pepsi | 250 ml', price: 2.00, quantity: 1, emoji: '🥤'),
      _ListItem(name: "Elmer's Glue", price: 5.00, quantity: 1, emoji: '🧴'),
    ],
    'Woolworths List': [
      _ListItem(name: 'Milk 2L', price: 3.20, quantity: 1, emoji: '🥛'),
      _ListItem(name: 'Bread', price: 2.80, quantity: 1, emoji: '🍞'),
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

  double _getTotal(String store) {
    return (_storeItems[store] ?? [])
        .fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  double get _grandTotal => _stores.fold(0, (s, st) => s + _getTotal(st));

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          widget.isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'EXPORT AS PDF',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: widget.isDark ? Colors.white70 : Colors.black54,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'SHARE CODE',
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
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
    final activeTabColor = isDark ? AppColors.purple : AppColors.amberDark;

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
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Share',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: textColor,
              unselectedLabelColor: textColor.withOpacity(0.4),
              labelStyle: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  GoogleFonts.poppins(fontSize: 13),
              indicatorColor: activeTabColor,
              indicatorWeight: 2.5,
              tabs: _stores.map((s) => Tab(text: s)).toList(),
            ),
            const SizedBox(height: 8),
            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _stores.map((store) {
                  final items = _storeItems[store] ?? [];
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                                  onTap: () {
                                    if (item.quantity > 1) {
                                      setState(() => item.quantity--);
                                    }
                                  },
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
                                      setState(() => item.quantity++),
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
                  Text(
                    'Total price:',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '\$${_getTotal(_stores[_tabController.index]).toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
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
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDark ? Colors.black : Colors.white, size: 18),
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
