import 'package:flutter/material.dart';
import 'package:odbfinder/screens/appstatus.dart';
import 'package:odbfinder/screens/chat.dart';
import 'package:odbfinder/screens/home.dart';
import 'package:odbfinder/screens/messege.dart';

class RoomDetailScreen extends StatefulWidget {
  final Dorm dorm;
  final bool isFavorited;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onChatPressed;

  const RoomDetailScreen({
    super.key,
    required this.dorm,
    required this.isFavorited,
    required this.onFavoriteTap,
    this.onChatPressed,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isFavorited;
  }

  // =========================
  // OPEN CHAT SCREEN
  // =========================
  void _openChatScreen() {
    final existingIndex = globalConversations.indexWhere(
      (conversation) =>
          conversation['landlordName'] == widget.dorm.name,
    );

    if (existingIndex == -1) {
      globalConversations.insert(
        0,
        {
          'landlordName': widget.dorm.name,
          'lastMessage': 'Inquired about ${widget.dorm.name}',
          'time': 'Just now',
        },
      );
    }

    if (widget.onChatPressed != null) {
      widget.onChatPressed!();
    }

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          landlordName: widget.dorm.name,
          shouldGoToMessagesOnBack: false,
        ),
      ),
    );
  }

  // =========================
  // OPEN BOOKING STATUS
  // =========================
  void _openBookingStatus() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ApplicationStatusScreen(
          dormName: widget.dorm.name,
          location: 'Unit 402, Sampaloc, Manila (${widget.dorm.distance})',
          price: widget.dorm.priceAndRating,
        ),
      ),
    );
  }

  // =========================
  // FAVORITE
  // =========================
  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });

    widget.onFavoriteTap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // TOP BLUE BAR
            // =========================
            Container(
              color: const Color(0xFF004D7A),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // PAGE TITLE
                    // =========================
                    const Center(
                      child: Text(
                        'Room Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // MAIN PHOTO GALLERY BOX
                    // =========================
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Main Photo Gallery\n(1/5 Photos)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: GestureDetector(
                            onTap: _toggleFavorite,
                            child: Icon(
                              _isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // DORM TITLE & DETAILS
                    // =========================
                    Text(
                      widget.dorm.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Unit 402, Sampaloc, Manila (${widget.dorm.distance})',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.dorm.priceAndRating} * 1 month Deposit',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // QUICK SPECS
                    // =========================
                    const Divider(color: Colors.black, thickness: 1),
                    const Text(
                      'Quick Specs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.black, thickness: 1),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('[BEDSPACE]', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('[4 MAX/ROOM]', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('[EN-SUITE]', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    // =========================
                    // AMENITIES
                    // =========================
                    const Divider(color: Colors.black, thickness: 1),
                    const Text(
                      'Amenities',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.black, thickness: 1),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• Free WiFi'),
                                Text('• 24/7 CCTV/Security'),
                                Text('• Water Dispenser'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• Aircon'),
                                Text('• Study area & Lounge'),
                                Text('• Cooking Allowed'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =========================
                    // LANDLORD / ADMIN
                    // =========================
                    const Divider(color: Colors.black, thickness: 1),
                    const Text(
                      'Landlord / Admin',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.black, thickness: 1),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[${widget.dorm.name}]',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Rating and Reviews',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 110,
                              height: 32,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: _openChatScreen,
                                child: const Text(
                                  'Chat',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // BOOK BUTTON
                    // =========================
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C93BF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          onPressed: _openBookingStatus,
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}