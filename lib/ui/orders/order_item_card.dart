import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_item.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          buildOrderSummary(),
          if (_expanded) buildOrderDetails()
        ],
      ),
    );
  }

  Widget buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      height: min(widget.order.productCount * 20.0 + 10, 100),
      child: ListView(
        children: widget.order.products
            .map((prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      prod.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${prod.quantity}x ${prod.price.toStringAsFixed(3)}VNĐ',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey, // Set the background color to gray.
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: ListTile(
          title: Text(
            'Tổng hóa đơn : ${widget.order.amount.toStringAsFixed(3)} VNĐ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.close_fullscreen : Icons.open_in_new),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
      ),
    );
  }
}
