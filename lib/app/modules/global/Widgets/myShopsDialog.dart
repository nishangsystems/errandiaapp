import 'package:errandia/app/APi/business.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopSelectionDialog extends StatefulWidget {
  final Function(Shop) onShopSelected;
  final String desc;

  ShopSelectionDialog({required this.onShopSelected, required this.desc});

  @override
  _ShopSelectionDialogState createState() => _ShopSelectionDialogState();
}

class _ShopSelectionDialogState extends State<ShopSelectionDialog> {
  List<Shop> shops = [];
  Shop? selectedShop;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    try {
      // Placeholder for your API call
      var response = await BusinessAPI.userShops_(1);
      print("response my shops: ${response['items']}");

      List<Shop> fetchedShops = (response['items'] as List).map((shopData) {
        return Shop.fromJson(shopData); // Assuming Shop has a fromJson method
      }).toList();

      if (mounted) {
        setState(() {
          shops = fetchedShops;
          isLoading = false;
        });
      }
    } catch (error) {
      // Handle any errors here
      print('Error fetching shops: $error');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Shop'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.desc,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(14.0),
                child: CircularProgressIndicator(),
              )
            else
              ListBody(
                children: <Widget>[
                  isLoading
                      ? buildLoadingWidget()
                      : DropdownButtonFormField<Shop>(
                    hint: const Text("Select a Shop"),
                    value: selectedShop,
                    onChanged: (Shop? newValue) {
                      setState(() {
                        selectedShop = newValue;
                      });
                    },
                    items: shops.map<DropdownMenuItem<Shop>>((Shop shop) {
                      return DropdownMenuItem<Shop>(
                        value: shop,
                        child: Text(capitalizeAll(shop.name),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
          ],
        )
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            if (selectedShop != null) {
              widget.onShopSelected(selectedShop!);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<List<Shop>> fetchShopsFromAPI() async {
    // Simulated API call delay
    await Future.delayed(const Duration(seconds: 2));
    // Simulated response
    return [
      Shop(id: 1, name: "Shop 1"),
      Shop(id: 2, name: "Shop 2"),
      // Add more shops as needed
    ];
  }
}