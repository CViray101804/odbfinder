import 'package:flutter/material.dart';
import 'package:odbfinder/screens/chat.dart';
import 'package:odbfinder/screens/messege.dart';

class AdminProfileScreen extends StatefulWidget {
  final String landlordName;

  const AdminProfileScreen({
    super.key,
    this.landlordName = 'Juan Dela Cruz',
  });

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final Color darkBlue = const Color(0xFF0A4F7D);
  final Color cardGrey = const Color(0xFFD9D9D9);

  // Filter tab selection: 'All', 'Available', 'Reserved', 'Fully Booked'
  String selectedFilter = 'All';

  // Sample listing data for managed rooms/bedspaces
  final List<Map<String, dynamic>> rooms = [
    {
      'title': 'Bedspace #3',
      'gender': 'Female Unit',
      'roomNo': 'Room 102',
      'cost': '₱2,500/mo',
      'availableCount': '2 available beds',
      'status': 'Available',
      'isFavorite': false,
    },
    {
      'title': 'Bedspace #1',
      'gender': 'Male Unit',
      'roomNo': 'Room 101',
      'cost': '₱3,000/mo',
      'availableCount': '0 available beds',
      'status': 'Fully Booked',
      'isFavorite': true,
    },
    {
      'title': 'Private Room A',
      'gender': 'Solo / Shared',
      'roomNo': 'Room 201',
      'cost': '₱5,000/mo',
      'availableCount': '1 reserved bed',
      'status': 'Reserved',
      'isFavorite': false,
    },
  ];

  List<Map<String, dynamic>> get filteredRooms {
    if (selectedFilter == 'All') return rooms;
    return rooms.where((room) => room['status'] == selectedFilter).toList();
  }

  int _getCategoryCount(String category) {
    if (category == 'All') return rooms.length;
    return rooms.where((room) => room['status'] == category).length;
  }

  // =========================================================
  // NAVIGATE TO CHAT & UPDATE GLOBAL MESSAGES LIST
  // =========================================================
  Future<void> _openChatWithAdmin() async {
    // Check if a conversation with this admin already exists in messege.dart
    final existingIndex = globalConversations.indexWhere(
      (conversation) => conversation['landlordName'] == widget.landlordName,
    );

    // If it doesn't exist yet, insert a new entry into globalConversations
    if (existingIndex == -1) {
      globalConversations.insert(
        0,
        {
          'landlordName': widget.landlordName,
          'lastMessage': 'Started a conversation',
          'time': 'Just now',
        },
      );
    }

    // Await navigation so state refreshes when coming back from chat
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          landlordName: widget.landlordName,
          shouldGoToMessagesOnBack: false,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: darkBlue,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 70,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // --- ADMIN / LANDLORD PROFILE HEADER CARD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Avatar with Blue Verified Badge
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC4C4C4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 75,
                            color: Colors.black,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.lightBlueAccent,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Admin Name & Property Info
                    Text(
                      widget.landlordName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Property owner of Sunshine Dormitory',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Ratings & Response Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8 (24 Reviews) • Fast Reply',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Chat Button connecting to ChatDetailScreen & messege.dart
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cardGrey,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _openChatWithAdmin,
                      child: const Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.black26, thickness: 1, height: 1),

            // --- SECTION HEADER ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Text(
                'Managed Listing & Rooms',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(color: Colors.black26, thickness: 1, height: 1),

            const SizedBox(height: 12),

            // --- FILTER CHIPS BAR ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Available'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Reserved'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Fully Booked'),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Colors.black26, thickness: 1, height: 1),

            // --- MANAGED ROOMS LIST ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];
                return _buildRoomCard(room);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to construct filter pills
  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedFilter == label;
    final int count = _getCategoryCount(label);

    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      selectedColor: cardGrey,
      backgroundColor: cardGrey.withOpacity(0.5),
      labelStyle: TextStyle(
        color: Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            selectedFilter = label;
          });
        }
      },
    );
  }

  // Helper widget to construct listing cards
  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Photo Placeholder / Image Thumbnail
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${room['gender']} [${room['roomNo']}]',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${room['cost']} • ${room['availableCount']}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Status Badge & Favorite Icon Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(room['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        room['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        room['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: room['isFavorite'] ? Colors.red : Colors.black,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          room['isFavorite'] = !room['isFavorite'];
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green.shade600;
      case 'Reserved':
        return Colors.orange.shade700;
      case 'Fully Booked':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }
}