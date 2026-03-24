import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool isDark;
  const SearchScreen({super.key, this.isDark = true});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _api = ApiService();
  final _ctrl = TextEditingController();

  List<GroceryItem> _allItems = [];
  List<GroceryItem> _results = [];
  bool _isLoading = true;
  bool _searched = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadInitialResults();
  }

  Future<void> _loadInitialResults() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final items = await _api.fetchCatalog(limit: 60);
      if (!mounted) {
        return;
      }

      setState(() {
        _allItems = items;
        _results = items;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Initial catalog load failed: $error');
      if (!mounted) {
        return;
      }

      setState(() {
        _allItems = SampleData.items;
        _results = SampleData.items;
        _isLoading = false;
        _errorText =
            'Could not load backend data. Showing sample data instead.';
      });
    }
  }

  Future<void> _search(String query) async {
    final cleanedQuery = query.trim();
    if (cleanedQuery.isEmpty) {
      setState(() {
        _searched = false;
        _results = _allItems;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _searched = true;
    });

    try {
      final items = await _api.fetchCatalog(query: cleanedQuery, limit: 60);
      if (!mounted) {
        return;
      }

      setState(() {
        _results = items;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Search request failed for "$cleanedQuery": $error');
      if (!mounted) {
        return;
      }

      setState(() {
        _results = _allItems
            .where((item) =>
                item.name.toLowerCase().contains(cleanedQuery.toLowerCase()))
            .toList();
        _isLoading = false;
        _errorText = 'Search API unavailable. Showing local filtered results.';
      });
    }
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
                      onSubmitted: _search,
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Search for groceries',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: textColor.withOpacity(0.4)),
                        prefixIcon: Icon(Icons.search,
                            color: textColor.withOpacity(0.5)),
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
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _errorText!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: isDark ? AppColors.purple : AppColors.black,
                    ),
                  )
                : _searched && _results.isEmpty
                    ? Center(
                        child: Text(
                          'No results found',
                          style: GoogleFonts.poppins(
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          return _SearchResultCard(item: item, isDark: isDark);
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

    // Sort prices to find cheapest
    final sortedPrices = [...item.prices]
      ..sort((a, b) => a.price.compareTo(b.price));
    final hasPrices = sortedPrices.isNotEmpty;

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
            Container(
              width: 64,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.local_drink_outlined,
                  size: 36, color: isDark ? Colors.white38 : Colors.black26),
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
                  ),
                  const SizedBox(height: 10),
                  if (!hasPrices)
                    Text(
                      'No prices available',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: textColor.withOpacity(0.6),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...sortedPrices.take(4).map((sp) {
                          final isCheapest =
                              sp.price == sortedPrices.first.price;
                          return Column(
                            children: [
                              _storeLogo(sp.store, 28),
                              const SizedBox(height: 4),
                              Text(
                                '\$${sp.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isCheapest
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                            ],
                          );
                        }),
                        if (sortedPrices.length < 4)
                          ...List.generate(
                            4 - sortedPrices.length,
                            (index) => const SizedBox(width: 28),
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

  Widget _storeLogo(String store, double size) {
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
        color = Colors.red;
        letter = 'I';
        break;
      default:
        color = Colors.grey;
        letter = store[0];
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(letter,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: size * 0.45,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}
