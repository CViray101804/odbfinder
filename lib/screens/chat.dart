import 'package:flutter/material.dart';
import 'package:odbfinder/screens/imageholder/imageolder.dart';
import 'package:odbfinder/screens/messege.dart';

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}

// Global map to persist chat message histories per landlord
final Map<String, List<ChatMessage>> globalChatHistories = {};

class ChatDetailScreen extends StatefulWidget {
  final String landlordName;
  final bool shouldGoToMessagesOnBack;

  const ChatDetailScreen({
    super.key,
    this.landlordName = '[Landlord Name]',
    this.shouldGoToMessagesOnBack = false,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  bool _isMuted = false;

  // Shared images list starts empty to be populated from the database later
  final List<String> _sharedImages = [];

  // Getter to access persistent global messages for this specific landlord
  List<ChatMessage> get _messages {
    if (!globalChatHistories.containsKey(widget.landlordName)) {
      globalChatHistories[widget.landlordName] = [];
    }
    return globalChatHistories[widget.landlordName]!;
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      if (hasText != _isTyping) {
        setState(() {
          _isTyping = hasText;
        });
      }
    });
  }

  void _handleBackNavigation() {
    if (widget.shouldGoToMessagesOnBack) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MessagesScreen()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isSentByMe: true, timestamp: DateTime.now()),
      );
    });

    final existingIndex = globalConversations.indexWhere(
      (chat) => chat['landlordName'] == widget.landlordName,
    );

    final chatData = {
      'landlordName': widget.landlordName,
      'lastMessage': text,
      'time': 'Just now',
    };

    if (existingIndex != -1) {
      globalConversations[existingIndex] = chatData;
    } else {
      globalConversations.insert(0, chatData);
    }

    if (textToSend == null) {
      _messageController.clear();
    }
  }

  void _sendQuickLike() {
    _sendMessage('👍');
  }

  void _showChatOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      widget.landlordName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004D7A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.photo_library_outlined, color: Color(0xFF004D7A), size: 22),
                      ),
                      title: const Text('Shared Images & Receipts', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${_sharedImages.length} attached photos', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageHolderScreen(
                              landlordName: widget.landlordName,
                              imageUrls: _sharedImages,
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (_isMuted ? Colors.orange : const Color(0xFF004D7A)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _isMuted ? Icons.notifications_off_outlined : Icons.notifications_active_outlined,
                          color: _isMuted ? Colors.orange : const Color(0xFF004D7A),
                          size: 22,
                        ),
                      ),
                      title: Text(_isMuted ? 'Unmute Chat' : 'Mute Notifications', style: const TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                        setModalState(() {});
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isMuted ? 'Notifications muted' : 'Notifications unmuted'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                      ),
                      title: const Text(
                        'Delete Conversation',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteChatDialog();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Delete Chat'),
          content: Text(
            'Are you sure you want to permanently delete your chat with ${widget.landlordName}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleDeleteAndExit();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteAndExit() {
    globalConversations.removeWhere(
      (chat) => chat['landlordName'] == widget.landlordName,
    );
    globalChatHistories.remove(widget.landlordName); // Clear message history too

    if (Navigator.canPop(context)) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MessagesScreen()),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat with ${widget.landlordName} deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF004D7A);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: darkBlue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: _handleBackNavigation,
          ),
          title: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          toolbarHeight: 70,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: darkBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.person_rounded, size: 26, color: darkBlue),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.landlordName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_isMuted)
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(
                              Icons.notifications_off_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded, color: darkBlue, size: 26),
                    onPressed: _showChatOptionsMenu,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'Start asking about the bedspace or dorm!',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Align(
                          alignment: msg.isSentByMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: msg.isSentByMe
                                  ? darkBlue
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(18).copyWith(
                                bottomRight: msg.isSentByMe ? const Radius.circular(4) : const Radius.circular(18),
                                bottomLeft: !msg.isSentByMe ? const Radius.circular(4) : const Radius.circular(18),
                              ),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isSentByMe
                                    ? Colors.white
                                    : const Color(0xFF1E1E1E),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600, size: 24),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_outlined, color: Colors.grey.shade600, size: 24),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.sentiment_satisfied_outlined,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_isTyping) {
                        _sendMessage();
                      } else {
                        _sendQuickLike();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isTyping ? darkBlue : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isTyping ? Icons.send_rounded : Icons.thumb_up_rounded,
                        size: 20,
                        color: _isTyping ? Colors.white : darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}