import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Orders', style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
