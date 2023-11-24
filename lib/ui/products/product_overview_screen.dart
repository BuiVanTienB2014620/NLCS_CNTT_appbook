import 'package:flutter/material.dart';
import 'package:myshop/ui/screens.dart';
import 'package:provider/provider.dart';

import '../shared/app_drawer.dart';
import 'products_grid.dart';
import 'top_right_badge.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop VT'),
        actions: <Widget>[
          buildProductFilterMenu(),
          buildShoppingCartIcon(),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
                valueListenable: _showOnlyFavorites,
                builder: (context, onlyFavorites, child) {
                  return ProductsGrid(onlyFavorites);
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.favorites) {
          _showOnlyFavorites.value = true;
        } else {
          _showOnlyFavorites.value = false;
        }
      },
      icon: const Icon(
        Icons.settings,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Sản phẩn yêu thích'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Hiển thị tất cả'),
        ),
      ],
    );
  }

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(
              Icons.add_shopping_cart,
            ),
            onPressed: () {
              Navigator.of(ctx).pushNamed(CartScreen.routeName);
            },
          ),
        );
      },
    );
  }
}
