import 'package:flutter/material.dart';
import 'package:odbfinder/screens/chat.dart';

// Global conversation list starts empty and will populate from your database later[cite: 7]
List<Map<String, String>> globalConversations = [];

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterConversations);
  }

  // Helper to filter conversations based on the search input
  List<Map<String, String>> get _filteredConversations {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return globalConversations;
    } else {
      return globalConversations.where((chat) {
        final name = (chat['landlordName'] ?? '').toLowerCase();
        final message = (chat['lastMessage'] ?? '').toLowerCase();
        return name.contains(query) || message.contains(query);
      }).toList();
    }
  }

  void _filterConversations() {
    setState(() {});
  }

  void _deleteConversation(Map<String, String> chat) {
    setState(() {
      globalConversations.remove(chat);
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
    // Refresh list upon returning from chat
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentConversations = _filteredConversations;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // --- MODERN SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search chats or landlords...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
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
                        color: Colors.grey.shade500,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // --- CONVERSATION LIST ---
          Expanded(
            child: currentConversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No messages yet'
                              : 'No conversations found',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: currentConversations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final chat = currentConversations[index];
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
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF004D7A).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 28,
                                  color: Color(0xFF004D7A),
                                ),
                              ),
                            ),
                            title: Text(
                              landlordName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                chat['lastMessage'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            trailing: Text(
                              chat['time'] ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () => _openChatScreen(landlordName),
                          ),
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