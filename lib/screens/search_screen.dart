import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'home_screen.dart' show getItemIcon;
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool isDark;
  const SearchScreen({super.key, this.isDark = true});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  List<GroceryItem> _results = SampleData.items;
  bool _searched = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _searched = true;
      _results = query.isEmpty
          ? SampleData.items
          : SampleData.items
              .where((i) => i.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final searchBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Icon(Icons.arrow_back, color: textColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: searchBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _ctrl,
                      autofocus: false,
                      onChanged: _search,
                      onSubmitted: _search,
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Search for groceries...',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: textColor.withOpacity(0.4)),
                        prefixIcon: Icon(Icons.search,
                            color: textColor.withOpacity(0.5)),
                        suffixIcon: _ctrl.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear,
                                    color: textColor.withOpacity(0.5),
                                    size: 18),
                                onPressed: () {
                                  _ctrl.clear();
                                  _search('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Results count
          if (_searched && _results.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_results.length} result${_results.length == 1 ? '' : 's'}',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: textColor.withOpacity(0.5)),
                ),
              ),
            ),
          Expanded(
            child: _searched && _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: textColor.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'No results found',
                          style: GoogleFonts.poppins(
                              color: textColor.withOpacity(0.5), fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _SearchResultCard(
                          item: _results[index], isDark: isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final GroceryItem item;
  final bool isDark;

  const _SearchResultCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    final sortedPrices = [...item.prices]
      ..sort((a, b) => a.price.compareTo(b.price));
    final cheapestPrice = sortedPrices.first.price;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductScreen(item: item, isDark: isDark)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image/icon
            Container(
              width: 64,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                getItemIcon(item.imageUrl),
                size: 32,
                color: isDark ? Colors.white38 : Colors.black26,
              ),
            ),
            const SizedBox(width: 14),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Store price row
                  Row(
                    children: sortedPrices.take(4).map((sp) {
                      final isCheapest = sp.price == cheapestPrice;
                      return Expanded(
                        child: Column(
                          children: [
                            _StoreLogoSmall(store: sp.store, size: 30),
                            const SizedBox(height: 4),
                            Text(
                              '\$${sp.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: isCheapest
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isCheapest
                                    ? (isDark
                                        ? AppColors.purpleLight
                                        : Colors.green.shade700)
                                    : textColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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

class _StoreLogoSmall extends StatelessWidget {
  final String store;
  final double size;

  const _StoreLogoSmall({required this.store, required this.size});

  @override
  Widget build(BuildContext context) {
    Color color;
    String letter;
    switch (store.toLowerCase()) {
      case 'coles':
        color = AppColors.colesRed;
        letter = 'C';
        break;
      case 'woolworths':
        color = AppColors.woolworthsGreen;
        letter = 'W';
        break;
      case 'aldi':
        color = AppColors.aldiBlue;
        letter = 'A';
        break;
      case 'iga':
        color = Colors.red.shade700;
        letter = 'I';
        break;
      default:
        color = Colors.grey;
        letter = store[0].toUpperCase();
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size * 0.42,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
