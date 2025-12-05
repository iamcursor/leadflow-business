import 'package:flutter/material.dart';
import '../../../core/base/base_page.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'My Bookings',
      showAppBar: false,
      child: Center(child: Text('Bookings Page - Coming Soon')),
    );
  }
}
