import 'package:flutter/material.dart';
import '../../../core/base/base_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Explore',
      showAppBar: false,
      child: Center(child: Text('Explore Page - Coming Soon')),
    );
  }
}
