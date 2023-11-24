import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../cart/cart_manager.dart';
import 'product_detail_screen.dart';
import 'products_manager.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          GridTile(
            footer: buildGridFooterBar(context),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProductDetailScreen(product)));
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            left: 10,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < 4; i++)
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 10,
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 2,
            right: 10,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 10,
                ),
                Text(
                  'Hà Nội',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return Column(
      children: <Widget>[
        GridTileBar(
          backgroundColor: Colors.black87,
          leading: ValueListenableBuilder<bool>(
            valueListenable: product.isFavoriteListenable,
            builder: (ctx, isFavorite, child) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  ctx.read<ProductsManager>().toggleFavoriteProduct(product);
                },
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              final cart = context.read<CartManager>();
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
                );
            },
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
