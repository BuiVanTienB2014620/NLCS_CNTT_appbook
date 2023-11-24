import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myshop/ui/products/ItemBottomNavBar.dart';

import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Đánh giá",
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xff4c53a5),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3), // 5px left padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Move the stars to the left
                children: [
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (index) {},
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.minus,
                          size: 18,
                          color: Color(0xff4c53a5),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "01",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4c53a5),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 18,
                          color: Color(0xff4c53a5),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff4c53a5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Kích cở:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff4c53a5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(children: [
                    for (int i = 1; i < 6; i++)
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                              ),
                            ]),
                        child: Text(
                          i.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4c53a5),
                          ),
                        ),
                      )
                  ]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Màu:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff4c53a5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(children: [
                    for (int i = 0; i < 5; i++)
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Clrs[i],
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                              ),
                            ]),
                      )
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ItemBottomNavBar(product),
    );
  }
}

List<Color> Clrs = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.orange,
];
