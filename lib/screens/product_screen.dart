import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ProductScreen extends StatefulWidget {
  final GroceryItem item;
  final bool isDark;

  const ProductScreen({super.key, required this.item, this.isDark = true});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService _api = ApiService();
  static const int _guestUserId =
      int.fromEnvironment('DEMO_USER_ID', defaultValue: 1);

  int _quantity = 1;
  String? _selectedStore;

  Future<void> _showAddToListDialog() async {
    final productId = int.tryParse(widget.item.id) ?? 0;
    if (productId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item cannot be added yet.')),
      );
      return;
    }

    final selectedStoreName = _selectedStore;
    if (selectedStoreName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a store first.')),
      );
      return;
    }

    if (widget.item.prices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No store prices available for this item.')),
      );
      return;
    }

    final selectedStore = widget.item.prices.firstWhere(
      (price) => price.store == selectedStoreName,
      orElse: () => widget.item.prices.first,
    );

    final added = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _AddToListWidget(
          isDark: widget.isDark,
          api: _api,
          userId: _guestUserId,
          productId: productId,
          quantity: _quantity,
          selectedStore: selectedStore,
        ),
      ),
    );

    if (added == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to shopping list.')),
      );
    }
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
    final cheapestPrice = sortedPrices.first.price;

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
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Quantity:',
                                style: GoogleFonts.poppins(
                                    fontSize: 15, color: textColor)),
                            const SizedBox(width: 16),
                            _QuantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_quantity > 1) setState(() => _quantity--);
                              },
                              isDark: isDark,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                        )),
                    const SizedBox(height: 16),
                    // Store prices
                    ...sortedPrices.map((sp) {
                      final isSelected = _selectedStore == sp.store;
                      final isCheapest = sp.price == cheapestPrice;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedStore = sp.store),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: isDark
                                        ? AppColors.purple
                                        : Colors.black,
                                    width: 2)
                                : null,
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
                                  ],
                                ),
                              ),
                              Text(
                                '\$${sp.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isCheapest
                                      ? (isDark
                                          ? AppColors.purpleLight
                                          : Colors.green.shade700)
                                      : textColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Checkbox
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark
                                          ? AppColors.purple
                                          : Colors.black)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? (isDark
                                            ? AppColors.purple
                                            : Colors.black)
                                        : textColor.withOpacity(0.3),
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
                        icon: const Icon(Icons.add_shopping_cart_outlined,
                            size: 20),
                        label: Text(
                          'Add to shopping list',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDark ? AppColors.purple : AppColors.black,
                          foregroundColor: Colors.white,
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
        child:
            Icon(icon, color: isDark ? Colors.black : Colors.white, size: 20),
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
  final ApiService api;
  final int userId;
  final int productId;
  final int quantity;
  final StorePrice selectedStore;

  const _AddToListWidget({
    required this.isDark,
    required this.api,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.selectedStore,
  });

  @override
  Widget build(BuildContext context) {
    return _AddToListDialogBody(
      isDark: isDark,
      api: api,
      userId: userId,
      productId: productId,
      quantity: quantity,
      selectedStore: selectedStore,
    );
  }
}

class _AddToListDialogBody extends StatefulWidget {
  final bool isDark;
  final ApiService api;
  final int userId;
  final int productId;
  final int quantity;
  final StorePrice selectedStore;

  const _AddToListDialogBody({
    required this.isDark,
    required this.api,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.selectedStore,
  });

  @override
  State<_AddToListDialogBody> createState() => _AddToListDialogBodyState();
}

class _AddToListDialogBodyState extends State<_AddToListDialogBody> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<ShoppingList> _lists = [];
  String? _selectedListId;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    setState(() => _isLoading = true);
    try {
      final lists = await widget.api.fetchShoppingLists(userId: widget.userId);
      if (!mounted) {
        return;
      }
      setState(() {
        _lists = lists;
        _selectedListId = lists.isNotEmpty ? lists.first.id : null;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load your shopping lists.')),
      );
    }
  }

  Future<void> _createNewList() async {
    final ctrl = TextEditingController();
    final createdName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New List'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'List name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    final listName = createdName?.trim() ?? '';
    if (listName.isEmpty) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final created = await widget.api.createShoppingList(
        userId: widget.userId,
        name: listName,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _lists = [..._lists, created];
        _selectedListId = created.id;
        _isSubmitting = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create list.')),
      );
    }
  }

  Future<void> _submit() async {
    final listId = int.tryParse(_selectedListId ?? '');
    if (listId == null || listId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose or create a list.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.api.addProductToList(
        parentListId: listId,
        productId: widget.productId,
        storeName: widget.selectedStore.store,
        quantity: widget.quantity,
      );

      if (!mounted) {
        return;
      }
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not add item to list.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : Colors.black;
    final bg = widget.isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add to list (${widget.selectedStore.store})',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(_selectedListId),
                  initialValue: _selectedListId,
                  decoration: const InputDecoration(labelText: 'Shopping list'),
                  items: _lists
                      .map((list) => DropdownMenuItem<String>(
                            value: list.id,
                            child: Text(list.name),
                          ))
                      .toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) => setState(() => _selectedListId = value),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : _createNewList,
                      child: const Text('Create New List'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed:
                          _isSubmitting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add Item'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
