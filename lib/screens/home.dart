import 'package:flutter/material.dart';
import 'package:odbfinder/screens/messege.dart';
import 'package:odbfinder/screens/profile.dart';
import 'package:odbfinder/screens/roomdesc.dart';
import 'package:odbfinder/screens/dorm_model.dart';

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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  final Set<int> _favoriteIds = {};

  final Color darkBlue = const Color(0xFF0A4F7D);

  // -------------------------------------------------------------------------
  // FAVORITE TOGGLE
  // -------------------------------------------------------------------------
  void _toggleFavorite(int dormId) {
    setState(() {
      if (_favoriteIds.contains(dormId)) {
        _favoriteIds.remove(dormId);
      } else {
        _favoriteIds.add(dormId);
      }
    });
  }

  // -------------------------------------------------------------------------
  // SCREENS
  // -------------------------------------------------------------------------
  List<Widget> _getScreens() {
    return [
      const MessagesScreen(),

      const NotificationsScreenContent(),

      HomeContentBody(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
      ),

      FavoritesScreenContent(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
      ),

      const ProfileScreen(),
    ];
  }

  // -------------------------------------------------------------------------
  // APP BAR TITLE
  // -------------------------------------------------------------------------
  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Messages';

      case 1:
        return 'Notifications';

      case 2:
        return 'OBD FINDER';

      case 3:
        return 'Favorites';

      default:
        return 'OBD FINDER';
    }
  }

  // -------------------------------------------------------------------------
  // BUILD
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 4
          ? null
          : AppBar(
              backgroundColor: darkBlue,
              title: Text(
                _getAppBarTitle(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 0,
              toolbarHeight: 80,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
            ),

      // Keep only the selected screen visible
      body: IndexedStack(index: _currentIndex, children: _getScreens()),

      // ---------------------------------------------------------------------
      // BOTTOM NAVIGATION
      // ---------------------------------------------------------------------
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(icon: Icons.chat_bubble_rounded, index: 0),

            _buildNavItem(icon: Icons.notifications, index: 1, showBadge: true),

            _buildNavItem(icon: Icons.home, index: 2),

            _buildNavItem(icon: Icons.favorite, index: 3),

            _buildNavItem(icon: Icons.person, index: 4),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // BOTTOM NAV ITEM
  // -------------------------------------------------------------------------
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: isSelected ? 30 : 26,
              color: isSelected ? Colors.white : Colors.black,
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
                    minWidth: 10,
                    minHeight: 10,
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
          Icon(
            Icons.notifications_off_outlined,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No current Notification yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FAVORITES CONTENT
// ---------------------------------------------------------------------------
class FavoritesScreenContent extends StatelessWidget {
  final Set<int> favoriteIds;
  final Function(int) onToggleFavorite;

  const FavoritesScreenContent({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favoritedDorms = sampleDorms
        .where((dorm) => favoriteIds.contains(dorm.id))
        .toList();

    // No favorites
    if (favoritedDorms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No Saved Favorites Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // Favorites list
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favoritedDorms.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final dorm = favoritedDorms[index];

        return buildExploreCard(
          context: context,
          dorm: dorm,
          isFavorited: true,
          onFavoriteTap: () => onToggleFavorite(dorm.id),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// HOME CONTENT BODY
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

  final Color lightGrey = const Color(0xFFE0E0E0);

  final Color cardGrey = const Color(0xFFD4D4D4);

  final Color darkBlue = const Color(0xFF0A4F7D);

  // -------------------------------------------------------------------------
  // DISPOSE SEARCH CONTROLLER
  // -------------------------------------------------------------------------
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // FILTER MODAL
  // -------------------------------------------------------------------------
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Options',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Budget Range (₱)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (val) {
                              final double? minVal = double.tryParse(val);

                              if (minVal != null &&
                                  minVal >= 500 &&
                                  minVal <= tempPriceRange.end) {
                                setModalState(() {
                                  tempPriceRange = RangeValues(
                                    minVal,
                                    tempPriceRange.end,
                                  );
                                });
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: TextField(
                            controller: maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (val) {
                              final double? maxVal = double.tryParse(val);

                              if (maxVal != null &&
                                  maxVal <= 10000 &&
                                  maxVal >= tempPriceRange.start) {
                                setModalState(() {
                                  tempPriceRange = RangeValues(
                                    tempPriceRange.start,
                                    maxVal,
                                  );
                                });
                              }
                            },
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
                      labels: RangeLabels(
                        '₱${tempPriceRange.start.round()}',
                        '₱${tempPriceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          tempPriceRange = values;

                          minPriceController.text = values.start
                              .round()
                              .toString();

                          maxPriceController.text = values.end
                              .round()
                              .toString();
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Max Distance from School: '
                      '${tempMaxDistance.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    Slider(
                      value: tempMaxDistance,
                      min: 0.5,
                      max: 10.0,
                      divisions: 19,
                      activeColor: darkBlue,
                      label: '${tempMaxDistance.toStringAsFixed(1)} km',
                      onChanged: (double value) {
                        setModalState(() {
                          tempMaxDistance = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Dormitory Preference',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _buildGenderChip('Any', tempGender, (selected) {
                          setModalState(() => tempGender = selected);
                        }),

                        const SizedBox(width: 8),

                        _buildGenderChip('Male', tempGender, (selected) {
                          setModalState(() => tempGender = selected);
                        }),

                        const SizedBox(width: 8),

                        _buildGenderChip('Female', tempGender, (selected) {
                          setModalState(() => tempGender = selected);
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              side: BorderSide(color: darkBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: darkBlue, fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // -------------------------------------------------------------------------
  // GENDER CHIP
  // -------------------------------------------------------------------------
  Widget _buildGenderChip(
    String label,
    String currentSelection,
    Function(String) onSelect,
  ) {
    final bool isSelected = currentSelection == label;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: darkBlue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (bool selected) {
        if (selected) {
          onSelect(label);
        }
      },
    );
  }

  // -------------------------------------------------------------------------
  // HOME BODY
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSearchBar()),

              const SizedBox(width: 12),

              _buildFilterButton(),
            ],
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Recommended'),

          const Divider(color: Colors.black54),

          const SizedBox(height: 8),

          _buildHorizontalCardList(),

          const SizedBox(height: 24),

          _buildSectionTitle('Recently Viewed'),

          const Divider(color: Colors.black54),

          const SizedBox(height: 8),

          _buildHorizontalCardList(),

          const SizedBox(height: 24),

          const Text(
            'Explore',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),

          const Divider(color: Colors.black54),

          const SizedBox(height: 12),

          // -----------------------------------------------------------------
          // EXPLORE DORM LIST
          // -----------------------------------------------------------------
          ...sampleDorms.map((dorm) {
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
          }),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SEARCH BAR
  // -------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search, color: Colors.black, size: 24),
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // FILTER BUTTON
  // -------------------------------------------------------------------------
  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _openFilterModal,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'Filter',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SECTION TITLE
  // -------------------------------------------------------------------------
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // HORIZONTAL CARD LIST
  // -------------------------------------------------------------------------
  Widget _buildHorizontalCardList() {
    return Row(
      children: [
        _buildPhotoCard(),

        const SizedBox(width: 16),

        _buildPhotoCard(),

        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: lightGrey, shape: BoxShape.circle),
          child: const Icon(Icons.chevron_right, size: 20, color: Colors.black),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // PHOTO CARD
  // -------------------------------------------------------------------------
  Widget _buildPhotoCard() {
    return Container(
      width: 130,
      height: 180,
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Photo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
//
// IMPORTANT:
// This card now opens RoomDetailScreen from roomdesc.dart.
//
// DO NOT create another RoomDetailScreen class in this file.
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
      height: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFD4D4D4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // ---------------------------------------------------------------
          // PHOTO
          // ---------------------------------------------------------------
          Container(
            width: 104,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Photo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ---------------------------------------------------------------
          // DORM INFORMATION
          // ---------------------------------------------------------------
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dorm.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      dorm.priceAndRating,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      dorm.distance,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      dorm.preference,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // ---------------------------------------------------------
                // FAVORITE BUTTON
                // ---------------------------------------------------------
                Positioned(
                  bottom: 4,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.black,
                      size: 24,
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

// ---------------------------------------------------------------------------
// IMPORTANT
// ---------------------------------------------------------------------------
// There is intentionally NO RoomDetailScreen class here.
//
// RoomDetailScreen is imported from:
//     screens/roomdesc.dart
//
// This fixes the problem where Chat and Book previously used:
//     onPressed: () {}
//
// The RoomDetailScreen in roomdesc.dart contains:
//     onPressed: _openChatScreen
//     onPressed: _openBookingStatus
// ---------------------------------------------------------------------------
