import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';

class ItemBottomNavBar extends StatelessWidget {
  static const routeName = '/product-detail';

  const ItemBottomNavBar(
    this.product, {
    super.key,
  });

  final Product product;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${product.price.toStringAsFixed(3)} ₫', // Display price with "₫"
              style: TextStyle(
                // Set price color to black
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff4c53a5),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () { final cart = context.read<CartManager>();
              cart.addItem(product);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Mặt hàng đã được thêm vào giỏ hàng'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'HOÀN TÁC',
                      onPressed: () {
                        cart.removeItem(product.id!);
                      },
                    ),
                  ),
                );},
              icon: Icon(CupertinoIcons.cart_badge_plus),
              label: Text(
                "Thêm vào giỏ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff4c53a5)),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
