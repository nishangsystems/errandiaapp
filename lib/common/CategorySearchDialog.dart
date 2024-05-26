import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

// Custom Category Search Widget
class CategorySearchDialog extends StatelessWidget {
  final List<dynamic> categoryList;
  final Function(dynamic) onCategorySelected;

  CategorySearchDialog({super.key, required this.categoryList, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Category'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5, // 50% of the screen height
        child: Column(
          children: [
            TypeAheadField<dynamic>(
              decorationBuilder: (context, child) => DecoratedBox(
                decoration: BoxDecoration(
                  color: CupertinoTheme.of(context)
                      .barBackgroundColor
                      .withOpacity(1),
                  border: Border.all(
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.systemGrey4,
                      context,
                    ),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: child,
              ),
              builder: (context, controller, focusNode) => TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: false,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                  isDense: true,
                  hintText: 'Start typing to search...',

                  // rounded border
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
              suggestionsCallback: (pattern) async {
                return product_controller.categoryList
                    .where((category) => category['name']
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, dynamic suggestion) {
                return ListTile(
                  title: Text(suggestion['name']),
                );
              },
              onSelected: (dynamic suggestion) {
                onCategorySelected(suggestion);
                Get.back();
              },
              direction: VerticalDirection.down,
              transitionBuilder: (context, animation, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn
                  ),
                  child: child,
                );
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  var category = categoryList[index];
                  return ListTile(
                    title: Text(category['name']),
                    onTap: () {
                      onCategorySelected(category);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
