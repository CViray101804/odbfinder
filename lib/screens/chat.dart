import 'package:flutter/material.dart';
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
                ],
              ),
            ),
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