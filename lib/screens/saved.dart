import 'package:flutter/material.dart';
import 'package:odbfinder/screens/home.dart';
import 'package:odbfinder/screens/roomdesc.dart';

class SavedScreen extends StatefulWidget {
  final List<Dorm> savedDorms;
  final Function(Dorm dorm)? onSavedRemoved;

  const SavedScreen({super.key, required this.savedDorms, this.onSavedRemoved});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final Color darkBlue = const Color(0xFF004D7A);

  void _handleRemove(Dorm dorm, int index) {
    if (widget.onSavedRemoved != null) {
      widget.onSavedRemoved!(dorm);
    }
    setState(() {
      widget.savedDorms.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from saved items'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Removed the duplicate local AppBar so HomeScreen's AppBar handles the top header
      body: widget.savedDorms.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: darkBlue.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border_rounded,
                        size: 56,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No saved rooms yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the bookmark or save icon on any room listing to keep track of your top choices here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: widget.savedDorms.length,
              itemBuilder: (context, index) {
                final dorm = widget.savedDorms[index];
                return _buildSavedCard(dorm, index);
              },
            ),
    );
  }

  Widget _buildSavedCard(Dorm dorm, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailScreen(
                dorm: dorm,
                isFavorited: true,
                onFavoriteTap: () {
                  _handleRemove(dorm, index);
                },
              ),
            ),
          );
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Photo Thumbnail
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    Icons.home_work_outlined,
                    size: 36,
                    color: darkBlue,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Room Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dorm.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.redAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dorm.distance,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dorm.priceAndRating,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ),

              // Saved Bookmark Button
              IconButton(
                icon: const Icon(
                  Icons.bookmark_rounded,
                  color: Color(0xFF004D7A),
                  size: 22,
                ),
                onPressed: () => _handleRemove(dorm, index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
