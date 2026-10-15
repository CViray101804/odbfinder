import 'package:flutter/material.dart';
import 'package:odbfinder/screens/messege.dart';
import 'package:odbfinder/screens/profile.dart' hide SavedScreen;
import 'package:odbfinder/screens/roomdesc.dart';
import 'package:odbfinder/screens/saved.dart';

// ---------------------------------------------------------------------------
// DORM MODEL
// ---------------------------------------------------------------------------
class Dorm {
  final int id;
  final String name;
  final String priceAndRating;
  final String distance;
  final String preference;

  const Dorm({
    required this.id,
    required this.name,
    required this.priceAndRating,
    required this.distance,
    required this.preference,
  });
}

// ---------------------------------------------------------------------------
// SAMPLE DORM DATA
// ---------------------------------------------------------------------------
final List<Dorm> sampleDorms = [
  const Dorm(
    id: 0,
    name: 'Sunshine Student Residence',
    priceAndRating: '₱3,500/Mo • ★ 4.8',
    distance: '0.5 km from school',
    preference: 'Female only',
  ),
  const Dorm(
    id: 1,
    name: 'University Haven Dorm',
    priceAndRating: '₱2,800/Mo • ★ 4.5',
    distance: '1.2 km from school',
    preference: 'Male/Female',
  ),
  const Dorm(
    id: 2,
    name: 'Academic Plaza Suites',
    priceAndRating: '₱4,200/Mo • ★ 4.9',
    distance: '0.8 km from school',
    preference: 'Male only',
  ),
];

// ---------------------------------------------------------------------------
// MAIN HOME SCREEN WITH NAVIGATION
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({
    super.key,
    this.userEmail = 'user@example.com',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;
  final Set<int> _favoriteIds = {};
  final Color darkBlue = const Color(0xFF004D7A);

  void _toggleFavorite(int dormId) {
    setState(() {
      if (_favoriteIds.contains(dormId)) {
        _favoriteIds.remove(dormId);
      } else {
        _favoriteIds.add(dormId);
      }
    });
  }

  List<Widget> _getScreens() {
    final savedDormsList = sampleDorms
        .where((dorm) => _favoriteIds.contains(dorm.id))
        .toList();

    return [
      const MessagesScreen(),
      const NotificationsScreenContent(),
      HomeContentBody(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
      ),
      SavedScreen(
        savedDorms: savedDormsList,
        onSavedRemoved: (dorm) {
          _toggleFavorite(dorm.id);
        },
      ),
      ProfileScreen(
        userEmail: widget.userEmail,
        userName: widget.userEmail,
      ),
    ];
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Messages';
      case 1:
        return 'Notifications';
      case 2:
        return 'ODB FINDER';
      case 3:
        return 'Saved Rooms';
      default:
        return 'ODB FINDER';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _currentIndex == 4
          ? null
          : AppBar(
              backgroundColor: darkBlue,
              title: Text(
                _getAppBarTitle(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              elevation: 0,
              toolbarHeight: 70,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
      body: IndexedStack(index: _currentIndex, children: _getScreens()),
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(icon: Icons.chat_bubble_outline_rounded, index: 0),
            _buildNavItem(icon: Icons.notifications_outlined, index: 1, showBadge: true),
            _buildNavItem(icon: Icons.home_rounded, index: 2),
            _buildNavItem(icon: Icons.bookmark_border_rounded, index: 3),
            _buildNavItem(icon: Icons.person_outline_rounded, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    bool showBadge = false,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? darkBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? darkBlue : Colors.grey.shade600,
            ),
            if (showBadge)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 8,
                    minHeight: 8,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NOTIFICATIONS CONTENT
// ---------------------------------------------------------------------------
class NotificationsScreenContent extends StatelessWidget {
  const NotificationsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME CONTENT BODY (Restored Search, Filter, Recommended, Recently Viewed)
// ---------------------------------------------------------------------------
class HomeContentBody extends StatefulWidget {
  final Set<int> favoriteIds;
  final Function(int) onToggleFavorite;

  const HomeContentBody({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  State<HomeContentBody> createState() => _HomeContentBodyState();
}

class _HomeContentBodyState extends State<HomeContentBody> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(1000, 5000);
  double _maxDistance = 2.0;
  String _selectedGender = 'Any';
  final Color darkBlue = const Color(0xFF004D7A);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    RangeValues tempPriceRange = _priceRange;
    double tempMaxDistance = _maxDistance;
    String tempGender = _selectedGender;

    final TextEditingController minPriceController = TextEditingController(
      text: tempPriceRange.start.round().toString(),
    );
    final TextEditingController maxPriceController = TextEditingController(
      text: tempPriceRange.end.round().toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Dormitories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempPriceRange = const RangeValues(1000, 5000);
                              tempMaxDistance = 2.0;
                              tempGender = 'Any';
                              minPriceController.text = '1000';
                              maxPriceController.text = '5000';
                            });
                          },
                          child: const Text(
                            'Reset All',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Budget Range per Month',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min',
                              prefixText: '₱ ',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('-', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max',
                              prefixText: '₱ ',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: tempPriceRange,
                      min: 500,
                      max: 10000,
                      divisions: 19,
                      activeColor: darkBlue,
                      inactiveColor: Colors.grey.shade200,
                      labels: RangeLabels(
                        '₱${tempPriceRange.start.round()}',
                        '₱${tempPriceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          tempPriceRange = values;
                          minPriceController.text = values.start.round().toString();
                          maxPriceController.text = values.end.round().toString();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Max Distance from School',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${tempMaxDistance.toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: tempMaxDistance,
                      min: 0.5,
                      max: 10.0,
                      divisions: 19,
                      activeColor: darkBlue,
                      inactiveColor: Colors.grey.shade200,
                      onChanged: (double value) {
                        setModalState(() {
                          tempMaxDistance = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gender Preference',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Any', 'Male', 'Female'].map((gender) {
                        bool isSelected = tempGender == gender;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected ? darkBlue : Colors.white,
                                side: BorderSide(
                                  color: isSelected ? darkBlue : Colors.grey.shade300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                setModalState(() {
                                  tempGender = gender;
                                });
                              },
                              child: Text(
                                gender,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _priceRange = tempPriceRange;
                            _maxDistance = tempMaxDistance;
                            _selectedGender = tempGender;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    // Filter sample dorms based on selected gender preference
    final filteredDorms = sampleDorms.where((dorm) {
      if (_selectedGender == 'Any') return true;
      if (_selectedGender == 'Male') {
        return dorm.preference.contains('Male') && !dorm.preference.contains('Female');
      }
      if (_selectedGender == 'Female') {
        return dorm.preference.contains('Female');
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SEARCH AND FILTER ROW ---
          Row(
            children: [
              Expanded(child: _buildSearchBar()),
              const SizedBox(width: 12),
              _buildFilterButton(),
            ],
          ),
          const SizedBox(height: 24),

          // --- RECOMMENDED SECTION ---
          _buildSectionTitle('Recommended For You'),
          const SizedBox(height: 12),
          _buildHorizontalCardList(filteredDorms),
          const SizedBox(height: 24),

          // --- RECENTLY VIEWED SECTION ---
          _buildSectionTitle('Recently Viewed'),
          const SizedBox(height: 12),
          _buildHorizontalCardList(filteredDorms),
          const SizedBox(height: 24),

          // --- EXPLORE ALL SECTION ---
          _buildSectionTitle('Explore All'),
          const SizedBox(height: 12),
          filteredDorms.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No dormitories match your selected filter.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                )
              : Column(
                  children: filteredDorms.map((dorm) {
                    final bool isFavorited = widget.favoriteIds.contains(dorm.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: buildExploreCard(
                        context: context,
                        dorm: dorm,
                        isFavorited: isFavorited,
                        onFavoriteTap: () => widget.onToggleFavorite(dorm.id),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
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
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search dorms...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _openFilterModal,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: darkBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            children: [
              Icon(Icons.tune_rounded, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E1E),
      ),
    );
  }

  Widget _buildHorizontalCardList(List<Dorm> dorms) {
    if (dorms.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 185,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dorms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final dorm = dorms[index];
          return _buildPhotoCard(dorm);
        },
      ),
    );
  }

  Widget _buildPhotoCard(Dorm dorm) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, color: Colors.grey, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dorm.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dorm.priceAndRating.split('•').first,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GLOBAL EXPLORE CARD WIDGET
// ---------------------------------------------------------------------------
Widget buildExploreCard({
  required BuildContext context,
  required Dorm dorm,
  required bool isFavorited,
  required VoidCallback onFavoriteTap,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomDetailScreen(
            dorm: dorm,
            isFavorited: isFavorited,
            onFavoriteTap: onFavoriteTap,
          ),
        ),
      );
    },
    child: Container(
      height: 115,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 95,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, color: Colors.grey, size: 32),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dorm.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dorm.priceAndRating,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF004D7A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dorm.distance,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isFavorited ? const Color(0xFF004D7A).withOpacity(0.1) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorited ? Icons.bookmark : Icons.bookmark_border_rounded,
                        color: isFavorited ? const Color(0xFF004D7A) : Colors.grey.shade600,
                        size: 20,
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
  );
}