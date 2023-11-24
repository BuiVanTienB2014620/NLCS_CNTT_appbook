import 'package:flutter/material.dart';
import 'package:myshop/ui/orders/order_manager.dart';
import 'package:provider/provider.dart';

import 'cart_item_card.dart';
import 'cart_manager.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
      ),
      body: Column(
        children: <Widget>[
          buildCartSummary(cart, context),
          const SizedBox(height: 10),
          Expanded(
            child: buildCartDetails(cart),
          ),
        ],
      ),
    );                     
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => CartItemCard(
              productId: entry.key,
              cardItem: entry.value,
             
            ),
          )
          .toList(),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'TỔNG',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '${cart.totalAmpunt.toStringAsFixed(3)}\VNĐ',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            TextButton(
              onPressed: cart.totalAmpunt <= 0
                  ? null
                  : () {
                      context.read<OrdersManager>().addOrder(
                            cart.products,
                            cart.totalAmpunt,
                          );
                      cart.clearAllItems();
                    },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              child: const Text('Thanh toán'),             
            ),
          ],
        ),
      ),
    );   
  }
}
