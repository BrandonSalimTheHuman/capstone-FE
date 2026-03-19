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
  List<ShoppingList> _lists = SampleData.lists;

  void _addList() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark
            ? AppColors.darkSurface
            : Colors.white,
        title: Text('New List',
            style: GoogleFonts.poppins(
                color: widget.isDark ? Colors.white : Colors.black)),
        content: TextField(
          controller: ctrl,
          style: GoogleFonts.poppins(
              color: widget.isDark ? Colors.white : Colors.black),
          decoration: const InputDecoration(hintText: 'List name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                setState(() {
                  _lists = [
                    ..._lists,
                    ShoppingList(
                      id: DateTime.now().toString(),
                      name: ctrl.text,
                      items: [],
                    ),
                  ];
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Icon(Icons.arrow_back, color: textColor),
                ),
                Text(
                  'My Lists',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                GestureDetector(
                  onTap: _addList,
                  child: Icon(Icons.add, color: textColor, size: 26),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _lists.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final list = _lists[index];
                final storesText = ['Aldi', 'Coles', 'Woolworths']
                    .take(index + 1)
                    .join(', ');
                final totals = [7.50, 16.70, 20.50, 10.20];
                final total =
                    index < totals.length ? totals[index] : 0.0;

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
                        Icon(Icons.format_list_bulleted,
                            color: AppColors.purple, size: 28),
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
        ],
      ),
    );
  }
}
