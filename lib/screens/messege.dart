import 'package:flutter/material.dart';
import 'package:odbfinder/screens/chat.dart';

// Global conversation list shared across the app
List<Map<String, String>> globalConversations = [
  {
    'landlordName': 'John Doe',
    'lastMessage': 'Hello, is the room still available?',
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

  void _deleteConversation(Map<String, String> chat) {
    setState(() {
      globalConversations.remove(chat);
      _filteredConversations.remove(chat);
    });
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    String landlordName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: Text(
            'Are you sure you want to delete your conversation with $landlordName? This action cannot be undone.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openChatScreen(String landlordName) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          landlordName: landlordName,
          shouldGoToMessagesOnBack: false,
        ),
      ),
    );
    _filterConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchController.text.isEmpty) {
      _filteredConversations = List.from(globalConversations);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
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

          // Conversation List
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
                      final landlordName =
                          chat['landlordName'] ?? '[Landlord Name]';

                      return Dismissible(
                        key: Key('${landlordName}_$index'),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await _showDeleteConfirmation(
                            context,
                            landlordName,
                          );
                        },
                        onDismissed: (direction) {
                          _deleteConversation(chat);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Deleted chat with $landlordName',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                        child: ListTile(
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
                            landlordName,
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
                          onTap: () => _openChatScreen(landlordName),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}