import 'package:flutter/material.dart';
import 'package:odbfinder/screens/chat.dart';

// Global conversation list shared across the app
List<Map<String, String>> globalConversations = [
  {
    'landlordName': 'Sample Landlord',
    'lastMessage': 'Hello! Is the bedspace available?',
    'time': '10:30 AM',
  },
];

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _filteredConversations = List.from(globalConversations);
    _searchController.addListener(_filterConversations);
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = List.from(globalConversations);
      } else {
        _filteredConversations = globalConversations.where((chat) {
          final name = (chat['landlordName'] ?? '').toLowerCase();
          final message = (chat['lastMessage'] ?? '').toLowerCase();
          return name.contains(query) || message.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep internal list in sync with global state changes
    if (_searchController.text.isEmpty &&
        _filteredConversations.length != globalConversations.length) {
      _filteredConversations = List.from(globalConversations);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // Removed Scaffold appBar to prevent duplicate top navigation bar
      body: SafeArea(
        child: Column(
          children: [
            // Integrated Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search chats or landlords...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: Icon(
                          Icons.clear,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Messages List
            Expanded(
              child: _filteredConversations.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'No messages yet'
                            : 'No conversations found',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _filteredConversations.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Colors.black12),
                      itemBuilder: (context, index) {
                        final chat = _filteredConversations[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: const CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            chat['landlordName'] ?? '[Landlord Name]',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            chat['lastMessage'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: Text(
                            chat['time'] ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailScreen(
                                  landlordName:
                                      chat['landlordName'] ?? '[Landlord Name]',
                                  shouldGoToMessagesOnBack: false,
                                ),
                              ),
                            );
                            setState(() {
                              _filterConversations();
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}