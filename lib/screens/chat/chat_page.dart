import 'package:flutter/material.dart';
import '../../../core/base/base_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Chat',
      showAppBar: false,
      child: Center(child: Text('Chat Page - Coming Soon')),
    );
  }
}
