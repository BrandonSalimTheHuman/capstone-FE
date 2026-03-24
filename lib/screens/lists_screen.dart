import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'shopping_list_detail_screen.dart';

class ListsScreen extends StatefulWidget {
  final bool isDark;
  const ListsScreen({super.key, this.isDark = true});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<ShoppingList> _lists = List.from(SampleData.lists);

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
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  _lists = [
                    ..._lists,
                    ShoppingList(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: ctrl.text.trim(),
                      items: [],
                    ),
                  ];
                });
              }
              Navigator.pop(ctx);
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
                  onTap: _addList,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.purple : AppColors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 16),
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
          // List items
          Expanded(
            child: _lists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list_alt_outlined,
                            size: 48, color: textColor.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'No lists yet',
                          style: GoogleFonts.poppins(
                              color: subtitleColor, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + New list to get started',
                          style: GoogleFonts.poppins(
                              color: subtitleColor.withOpacity(0.7),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _lists.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final list = _lists[index];
                      final itemCount = list.items.length;
                      final storeCount = list.stores.length;
                      final total = list.totalPrice;

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShoppingListDetailScreen(
                              list: list,
                              isDark: isDark,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.purple.withOpacity(0.2)
                                      : Colors.black.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.format_list_bulleted,
                                    color: isDark
                                        ? AppColors.purple
                                        : Colors.black,
                                    size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      itemCount == 0
                                          ? 'Empty list'
                                          : '$itemCount item${itemCount == 1 ? '' : 's'}'
                                              '${storeCount > 0 ? ' · $storeCount store${storeCount == 1 ? '' : 's'}' : ''}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: subtitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (total > 0)
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Icon(Icons.chevron_right,
                                  color: subtitleColor, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
