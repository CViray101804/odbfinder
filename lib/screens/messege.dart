import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final Color lightGrey = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    // Return only a Padding/Column (No Scaffold, No AppBar, No BottomNavBar)
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Icon(Icons.search, color: Colors.black, size: 24),
              ],
            ),
          ),

          // Empty State Message
          const Expanded(
            child: Center(
              child: Text(
                'No recent chats yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
