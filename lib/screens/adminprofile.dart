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
  final Color darkBlue = const Color(0xFF004D7A);

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

  Future<void> _openChatWithAdmin() async {
    final existingIndex = globalConversations.indexWhere(
      (conversation) => conversation['landlordName'] == widget.landlordName,
    );

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Admin Profile',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // --- ADMIN / LANDLORD PROFILE HEADER CARD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar with Blue Verified Badge
                    Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 55,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.lightBlue,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

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
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Ratings & Response Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 18),
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
                    const SizedBox(height: 20),

                    // Chat Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: darkBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _openChatWithAdmin,
                        child: const Text(
                          'Chat with Landlord',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- SECTION HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Managed Listings & Rooms',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- FILTER CHIPS BAR ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

            const SizedBox(height: 16),

            // --- MANAGED ROOMS LIST ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];
                return _buildRoomCard(room);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedFilter == label;
    final int count = _getCategoryCount(label);

    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      selectedColor: darkBlue,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? darkBlue : Colors.grey.shade300,
        ),
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

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          // Photo Placeholder
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: darkBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 32,
                color: darkBlue,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${room['gender']} [${room['roomNo']}]',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${room['cost']} • ${room['availableCount']}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        room['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        room['isFavorite']
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: room['isFavorite'] ? Colors.red : Colors.grey.shade400,
                        size: 20,
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