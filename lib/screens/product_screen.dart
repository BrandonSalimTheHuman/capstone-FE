import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class ProductScreen extends StatefulWidget {
  final GroceryItem item;
  final bool isDark;

  const ProductScreen({super.key, required this.item, this.isDark = true});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _quantity = 1;
  String? _selectedStore;

  void _showAddToListDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _AddToListWidget(isDark: widget.isDark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final imgBg = isDark ? AppColors.darkSurface : AppColors.lightBgDeep;

    // Sort prices by cheapest
    final sortedPrices = [...widget.item.prices]
      ..sort((a, b) => a.price.compareTo(b.price));

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // Product image area
          Container(
            color: imgBg,
            height: 280,
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.local_drink_outlined,
                    size: 120,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: textColor, size: 22),
                          const SizedBox(width: 6),
                          Text('Back',
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details
          Expanded(
            child: Container(
              color: bg,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Quantity control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Quantity:',
                            style: GoogleFonts.poppins(
                                fontSize: 15, color: textColor)),
                        const SizedBox(width: 16),
                        _QuantityButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (_quantity > 1)
                              setState(() => _quantity--);
                          },
                          isDark: isDark,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_quantity',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                        ),
                        _QuantityButton(
                          icon: Icons.add,
                          onTap: () => setState(() => _quantity++),
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Store prices
                    ...sortedPrices.map((sp) {
                      final isSelected = _selectedStore == sp.store;
                      final isCheapest = sp.price == sortedPrices.first.price;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedStore = sp.store),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _StoreLogoWidget(store: sp.store, size: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sp.store,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      '\$${sp.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Checkbox
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.purple
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.purple
                                        : textColor.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 18)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    // Add to shopping list button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showAddToListDialog,
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(
                          'Add to shopping list',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDark ? AppColors.darkCard : AppColors.lightCard,
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _QuantityButton(
      {required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            color: isDark ? Colors.black : Colors.white, size: 20),
      ),
    );
  }
}

class _StoreLogoWidget extends StatelessWidget {
  final String store;
  final double size;

  const _StoreLogoWidget({required this.store, required this.size});

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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AddToListWidget extends StatelessWidget {
  final bool isDark;
  const _AddToListWidget({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ADD TO EXISTING LIST',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'CREATE NEW LIST',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
