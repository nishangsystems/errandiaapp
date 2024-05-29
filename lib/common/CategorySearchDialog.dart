import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

// Custom Category Search Widget
class CategorySearchDialog extends StatefulWidget {
  final List<dynamic> categoryList;
  final Function(dynamic) onCategorySelected;

  CategorySearchDialog({super.key, required this.categoryList, required this.onCategorySelected});

  @override
  _CategorySearchDialogState createState() => _CategorySearchDialogState();
}

class _CategorySearchDialogState extends State<CategorySearchDialog> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = widget.categoryList;
    _searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    setState(() {
      _filteredCategories = widget.categoryList.where((category) {
        final lowerPattern = _searchController.text.toLowerCase();
        return category['name'].toLowerCase().contains(lowerPattern) ||
            category['description'].toLowerCase().contains(lowerPattern);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Category'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5, // 50% of the screen height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              autofocus: false,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search,
                  color: Colors.black87.withOpacity(0.5), size: 20
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                isDense: true,
                hintText: 'Start typing to search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: appcolor().greyColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: Colors.black87.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: Colors.black87.withOpacity(0.5)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.zero ,
                child: ListView.builder(
                  itemCount: _filteredCategories.length,
                  padding:  EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var category = _filteredCategories[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 3, vertical: 0
                      ),
                      dense: true,
                      title: Text(category['name']),
                      subtitle: Text(category['description'],
                        style: const TextStyle(color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onTap: () {
                        widget.onCategorySelected(category);
                        Get.back();
                      },
                    );
                  },
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}