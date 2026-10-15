import 'package:flutter/material.dart';
import 'package:odbfinder/screens/appstatus.dart';
import 'package:odbfinder/screens/chat.dart';
import 'package:odbfinder/screens/home.dart';
import 'package:odbfinder/screens/messege.dart';
import 'package:odbfinder/screens/adminprofile.dart';

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
  final Color darkBlue = const Color(0xFF004D7A);
  late bool _isFavorited;

  // Tracks whether the user currently has an active pending application for this room
  bool _hasActiveApplication = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isFavorited;
  }

  // =========================
  // OPEN CHAT SCREEN
  // =========================
  Future<void> _openChatScreen() async {
    final existingIndex = globalConversations.indexWhere(
      (conversation) => conversation['landlordName'] == widget.dorm.name,
    );

    if (existingIndex == -1) {
      globalConversations.insert(0, {
        'landlordName': widget.dorm.name,
        'lastMessage': 'Inquired about ${widget.dorm.name}',
        'time': 'Just now',
      });
    }

    if (widget.onChatPressed != null) {
      widget.onChatPressed!();
    }

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          landlordName: widget.dorm.name,
          shouldGoToMessagesOnBack: false,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  // =========================
  // OPEN ADMIN / LANDLORD PROFILE
  // =========================
  void _openAdminProfile() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            AdminProfileScreen(landlordName: widget.dorm.name),
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
          hasActiveApplication: _hasActiveApplication,
          onCancelApplication: () {
            setState(() {
              _hasActiveApplication = false;
            });
          },
        ),
      ),
    );
  }

  // =========================
  // TOGGLE SAVED ROOM
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Room Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // MAIN PHOTO GALLERY BOX
            // =========================
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: darkBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: darkBlue,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Main Photo Gallery\n(1/5 Photos)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorited
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: darkBlue,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // DORM TITLE & DETAILS
            // =========================
            Text(
              widget.dorm.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Colors.redAccent,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Unit 402, Sampaloc, Manila (${widget.dorm.distance})',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.dorm.priceAndRating} • 1 month Deposit',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // QUICK SPECS
            // =========================
            const Text(
              'Quick Specs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SpecItem(icon: Icons.bed_outlined, label: 'BEDSPACE'),
                  _SpecItem(
                    icon: Icons.people_outline_rounded,
                    label: '4 MAX/ROOM',
                  ),
                  _SpecItem(
                    icon: Icons.meeting_room_outlined,
                    label: 'EN-SUITE',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // AMENITIES
            // =========================
            const Text(
              'Amenities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AmenityItem(text: 'Free WiFi'),
                        SizedBox(height: 8),
                        _AmenityItem(text: '24/7 CCTV/Security'),
                        SizedBox(height: 8),
                        _AmenityItem(text: 'Water Dispenser'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AmenityItem(text: 'Aircon'),
                        SizedBox(height: 8),
                        _AmenityItem(text: 'Study area & Lounge'),
                        SizedBox(height: 8),
                        _AmenityItem(text: 'Cooking Allowed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // LANDLORD / ADMIN
            // =========================
            const Text(
              'Landlord / Admin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _openAdminProfile,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: darkBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: darkBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dorm.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Rating and Reviews',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkBlue.withOpacity(0.1),
                              foregroundColor: darkBlue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _openChatScreen,
                            child: const Text(
                              'Chat with Landlord',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // =========================
            // BOOK BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _hasActiveApplication = true;
                  });
                  _openBookingStatus();
                },
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // VIEW APPLICATION STATUS BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: darkBlue,
                  side: BorderSide(color: darkBlue.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _openBookingStatus,
                child: const Text(
                  'View Application Status',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF004D7A), size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }
}

class _AmenityItem extends StatelessWidget {
  final String text;

  const _AmenityItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_rounded, color: Colors.green, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
