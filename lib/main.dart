import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import './ui/screens.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> pages = [
    const ProductsOverviewScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const UserProductsScreen(),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepOrange,
            ).copyWith(
              secondary: Colors.deepOrange,
            ),
          ),
          home: authManager.isAuth
              ? Scaffold(
                  body: pages[_selectedPageIndex],
                  // bottomNavigationBar: BottomNavigationBar(
                  //   items: const [
                  //     BottomNavigationBarItem(
                  //       icon: Icon(Icons.home),
                  //       label: 'Home',
                  //     ),
                  //     BottomNavigationBarItem(
                  //       icon: Icon(Icons.shopping_cart),
                  //       label: 'Cart',
                  //     ),
                  //     BottomNavigationBarItem(
                  //       icon: Icon(Icons.list),
                  //       label: 'Orders',
                  //     ),
                  //     BottomNavigationBarItem(
                  //       icon: Icon(Icons.person),
                  //       label: 'User',
                  //     ),
                  //   ],
                  //   currentIndex: _selectedPageIndex,
                  //   onTap: _selectPage,
                  // ),
                  // persistentFooterButtons: <Widget>[
                  //   Container(
                  //     color: Colors.deepOrange, // Màu nền cam cho footer
                  //     height: 60, // Chiều cao của footer
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment
                  //           .spaceEvenly, // Các biểu tượng cách đều nhau
                  //       children: <Widget>[
                  //         Icon(
                  //           Icons.home,
                  //           color: Colors.white, // Màu biểu tượng trắng
                  //           size: 30, // Kích thước biểu tượng
                  //         ),
                  //         Icon(
                  //           Icons.shopping_cart,
                  //           color: Colors.white, // Màu biểu tượng trắng
                  //           size: 30, // Kích thước biểu tượng
                  //         ),
                  //         Icon(
                  //           Icons.person,
                  //           color: Colors.white, // Màu biểu tượng trắng
                  //           size: 30, // Kích thước biểu tượng
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                  // bottomNavigationBar: CurvedNavigationBar(
                  //     backgroundColor: Colors.transparent,
                  //     onTap: (index) {
                  //       // _handleNavigation(index);
                  //     },
                  //     height: 70,
                  //     color: Color(0xff4c53a5),
                  //     items: [
                  //       Icon(
                  //         Icons.browser_updated_sharp,
                  //         size: 30,
                  //         color: Colors.white,
                  //       ),
                  //       Icon(
                  //         Icons.home,
                  //         size: 30,2
                  //         color: Colors.white,
                  //       ),
                  //       Icon(
                  //         Icons.person,
                  //         size: 30,
                  //         color: Colors.white,
                  //       ),
                  //     ]),
                )
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  },
                ),
          routes: {
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == EditProductScreen.routeName) {
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditProductScreen(
                    productId != null
                        ? ctx.read<ProductsManager>().findById(productId)
                        : null,
                  );
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}
