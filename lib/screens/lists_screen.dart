import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'shopping_list_detail_screen.dart';

class ListsScreen extends StatefulWidget {
  final bool isDark;
  const ListsScreen({super.key, this.isDark = true});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final ApiService _api = ApiService();
  static const int _guestUserId =
      int.fromEnvironment('DEMO_USER_ID', defaultValue: 1);
  final int _userId = _guestUserId;

  List<ShoppingList> _lists = [];
  bool _isLoading = true;
  bool _isCreating = false;
  String? _errorText;

  Future<void> _openList(ShoppingList list) async {
    final listId = int.tryParse(list.id);
    if (listId == null || listId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid list id.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final detailed = await _api.fetchShoppingListDetail(parentListId: listId);
      if (!mounted) {
        return;
      }

      Navigator.pop(context);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShoppingListDetailScreen(
            list: detailed,
            isDark: widget.isDark,
          ),
        ),
      );
      _loadLists();
    } catch (_) {
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load list items.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final fetchedLists = await _api.fetchShoppingLists(userId: _userId);
      final hydratedLists = await Future.wait(
        fetchedLists.map((list) async {
          final listId = int.tryParse(list.id) ?? 0;
          if (listId <= 0) {
            return list;
          }

          try {
            return await _api.fetchShoppingListDetail(parentListId: listId);
          } catch (_) {
            return list;
          }
        }),
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _lists = hydratedLists;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _lists = SampleData.lists;
        _isLoading = false;
        _errorText =
            'Could not load backend lists. Showing sample lists instead.';
      });
    }
  }

  Future<void> _createList(String name) async {
    setState(() {
      _isCreating = true;
      _errorText = null;
    });

    try {
      final created =
          await _api.createShoppingList(userId: _userId, name: name);
      if (!mounted) {
        return;
      }

      setState(() {
        _lists = [..._lists, created];
        _isCreating = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCreating = false;
        _errorText = 'Failed to create list on backend.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not create list. Please try again.')),
      );
    }
  }

  void _addList() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? AppColors.darkSurface : Colors.white,
        title: Text(
          'New List',
          style: GoogleFonts.poppins(
              color: widget.isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: GoogleFonts.poppins(
              color: widget.isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'e.g. Weekly Groceries',
            hintStyle: GoogleFonts.poppins(
                color: widget.isDark ? Colors.white : Colors.black),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDark ? Colors.white : Colors.black,
                width: 2,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.white70 : Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              final listName = ctrl.text.trim();
              Navigator.pop(ctx);
              if (listName.isNotEmpty) {
                _createList(listName);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isDark ? AppColors.purple : AppColors.black,
              foregroundColor: Colors.white,
            ),
            child: Text('Create', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Lists',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                GestureDetector(
                  onTap: _isCreating ? null : _addList,
                  child: _isCreating
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: textColor,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.purple : AppColors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text('New list',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
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
                  color: subtitleColor,
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
                : RefreshIndicator(
                    onRefresh: _loadLists,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _lists.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final list = _lists[index];
                        final storesText = list.stores.isEmpty
                            ? 'No stores yet'
                            : list.stores.join(', ');
                        final total = list.totalPrice;

                        return GestureDetector(
                          onTap: () => _openList(list),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.format_list_bulleted,
                                    color: AppColors.purple, size: 28),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        storesText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Total: \$${total.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
