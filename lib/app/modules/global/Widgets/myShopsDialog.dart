import 'package:errandia/app/APi/business.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopSelectionDialog extends StatefulWidget {
  final Function(Shop) onShopSelected;

  ShopSelectionDialog({required this.onShopSelected});

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
    // Placeholder for your API call
    // Replace this with your actual API call logic
    var response = await BusinessAPI.userShops_(1);
    print("response my shops: ${response['items']}");

  // convert response['items'] to json
  //   Shops.Items = List.from(response['items']).map(
  //     <Shop>((shop) => Shop.fromJson(shop)).toList();

    if (mounted) {
      setState(() {
        shops = response['items'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Shop'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            isLoading
                ? const CircularProgressIndicator()
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
                  child: Text(shop.name),
                );
              }).toList(),
            ),
          ],
        ),
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
    await Future.delayed(Duration(seconds: 2));
    // Simulated response
    return [
      Shop(id: 1, name: "Shop 1"),
      Shop(id: 2, name: "Shop 2"),
      // Add more shops as needed
    ];
  }
}