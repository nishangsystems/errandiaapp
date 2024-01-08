import 'package:errandia/app/modules/global/storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
List Selected_item_List = [];
class service_category_item_list extends StatefulWidget {
  const service_category_item_list({super.key});

  @override
  State<service_category_item_list> createState() =>
      _service_category_item_listState();
}

class _service_category_item_listState
    extends State<service_category_item_list> {
  @override

  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "Beauty & Hairs",
    },
    {
      "id": 1,
      "value": false,
      "title": "Barber Shop",
    },
    {
      "id": 2,
      "value": false,
      "title": "Beauty Saloon",
    },
    {
      "id": 3,
      "value": false,
      "title": "Cars & Bikes",
    },
    {
      "id": 4,
      "value": false,
      "title": "Decor & Rentals",
    },
    {
      "id": 5,
      "value": false,
      "title": "Electronics & IT",
    },
    {
      "id": 6,
      "value": false,
      "title": "Fashion & Design",
    },
    {
      "id": 7,
      "value": false,
      "title": "Fruits & Milk",
    },
    {
      "id": 8,
      "value": false,
      "title": "Health & Relaxation",
    },
    {
      "id": 9,
      "value": false,
      "title": "Restaurants & Grill",
    },
    {
      "id": 10,
      "value": false,
      "title": "Schools & Training",
    },
  ];

  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      actions: [

        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Accept',
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            'Cancel',
          ),
        ),
      ],
      title: Text('Select Categories'),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: List.generate(
                  checkListItems.length,
                  (index) => CheckboxListTile(
                    onChanged: (value) {
                      checkListItems[index]["value"] = value;
                      setState(() {
                        if (Selected_item_List.contains(checkListItems[index])) {
                        Selected_item_List.remove(checkListItems[index]);
                        service_provider_storage_box.write('Selected_item_List', Selected_item_List);
                      } else {
                        Selected_item_List.add(checkListItems[index]);
                        service_provider_storage_box.write('Selected_item_List', Selected_item_List);
                      }
                      });
                    },
                    title: Text(
                      checkListItems[index]["title"].toString(),
                    ),
                    value: checkListItems[index]["value"],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
