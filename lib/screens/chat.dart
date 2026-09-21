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
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isMuted = false;

  // Sample images sent by landlord or user
  final List<String> _sharedImages = [
    'https://picsum.photos/300/300?random=1',
    'https://picsum.photos/300/300?random=2',
    'https://picsum.photos/300/300?random=3',
  ];

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

  // =========================================================
  // OPTIONS & ACTION MENU (BOTTOM SHEET)
  // =========================================================
  void _showChatOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),

                    // --- NAVIGATE TO IMAGE HOLDER SCREEN ---
                    ListTile(
                      leading: const Icon(Icons.photo_library_outlined,
                          color: Color(0xFF0A4F7D)),
                      title: const Text('Shared Images & Receipts'),
                      subtitle: Text('${_sharedImages.length} attached photos'),
                      onTap: () {
                        Navigator.pop(context); // Close bottom sheet
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

                    // --- MUTE / UNMUTE ---
                    ListTile(
                      leading: Icon(
                        _isMuted
                            ? Icons.notifications_off_outlined
                            : Icons.notifications_active_outlined,
                        color: _isMuted ? Colors.orange : const Color(0xFF0A4F7D),
                      ),
                      title: Text(_isMuted ? 'Unmute Chat' : 'Mute Notifications'),
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                        setModalState(() {});
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isMuted
                                ? 'Notifications muted'
                                : 'Notifications unmuted'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),

                    // --- REPORT ---
                    ListTile(
                      leading: const Icon(Icons.report_problem_outlined,
                          color: Colors.orange),
                      title: const Text('Report Conversation'),
                      onTap: () {
                        Navigator.pop(context);
                        _showReportCategoryDialog();
                      },
                    ),

                    // --- BLOCK USER ---
                    ListTile(
                      leading: const Icon(Icons.block, color: Colors.red),
                      title: const Text('Block Landlord/User'),
                      onTap: () {
                        Navigator.pop(context);
                        _showBlockDialog();
                      },
                    ),

                    // --- DELETE CHAT ---
                    ListTile(
                      leading: const Icon(Icons.delete_outline, color: Colors.red),
                      title: const Text(
                        'Delete Conversation',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
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

  // --- DIALOG: REPORT WITH SPECIFIC REASON CATEGORIES ---
  void _showReportCategoryDialog() {
    String selectedReason = 'Scam or Fraud';

    final List<String> reportReasons = [
      'Scam or Fraud',
      'Harassment or Bullying',
      'Inappropriate Content or Language',
      'Fake Listing or Misleading Price',
      'Spam or Unwanted Messaging',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Report User',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Why are you reporting this user? Select the reason that best fits:',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ...reportReasons.map((reason) {
                    return RadioListTile<String>(
                      title: Text(
                        reason,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: reason,
                      groupValue: selectedReason,
                      activeColor: const Color(0xFF0A4F7D),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedReason = value;
                          });
                        }
                      },
                    );
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4F7D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reported for "$selectedReason". Our team will review this chat.',
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text(
                    'Submit Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- DIALOG: BLOCK ---
  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Block ${widget.landlordName}?'),
          content: const Text(
            'Blocked users will no longer be able to send you messages or view your profile.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleDeleteAndExit();
              },
              child: const Text('Block', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // --- DIALOG: DELETE CHAT ---
  void _showDeleteChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // --- CLEANLY DELETE & RETURN STRAIGHT TO MESSAGES SCREEN ---
  void _handleDeleteAndExit() {
    globalConversations.removeWhere(
      (chat) => chat['landlordName'] == widget.landlordName,
    );

    // Pops all open routes down to the root screen (MessagesScreen)
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
    const Color darkBlue = Color(0xFF0A4F7D);

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
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: _handleBackNavigation,
          ),
          title: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          toolbarHeight: 65,
        ),
        body: Column(
          children: [
            // USER HEADER WITH OPTIONS ICON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.landlordName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_isMuted)
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(
                              Icons.notifications_off,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline,
                        color: darkBlue, size: 28),
                    onPressed: _showChatOptionsMenu,
                  ),
                ],
              ),
            ),

            // CHAT MESSAGES BODY
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'Start asking about the bedspace or dorm!',
                        style: TextStyle(color: Colors.grey.shade500),
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
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: msg.isSentByMe
                                  ? darkBlue
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isSentByMe
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // INPUT BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo, size: 28),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: const InputDecoration(
                                hintText: 'Message',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.sentiment_satisfied_alt,
                            color: Colors.black87,
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
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        _isTyping ? Icons.send : Icons.thumb_up_alt,
                        size: 28,
                        color: _isTyping ? darkBlue : Colors.black,
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