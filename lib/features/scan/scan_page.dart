import 'package:flutter/material.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Scan', style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
