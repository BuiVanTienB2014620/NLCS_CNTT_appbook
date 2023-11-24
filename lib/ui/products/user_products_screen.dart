import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../shared/app_drawer.dart';
import 'products_manager.dart';
import 'user_product_list_tile.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final productsManager = ProductsManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: context.read<ProductsManager>().fetchProducts(true),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ProductsManager>().fetchProducts(true),
            child: buildUserProductListView(),
          );
        },
      ),
    );
  }

  Widget buildUserProductListView() {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductListTile(productsManager.items[i]),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
    );
  }
}
