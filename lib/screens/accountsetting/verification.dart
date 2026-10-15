import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final Color darkBlue = const Color(0xFF004D7A);

  // Status tracking: 'Unverified', 'Pending', or 'Verified'
  String verificationStatus = 'Unverified';
  bool isFileSelected = false;

  Color _getStatusColor() {
    switch (verificationStatus) {
      case 'Pending':
        return Colors.orange;
      case 'Verified':
        return Colors.green;
      case 'Unverified':
      default:
        return Colors.red.shade600;
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
          'Student Verification',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Main Container Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 28.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verification Status Badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Status: $verificationStatus',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Upload Student ID or COR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Please submit a clear photo of your valid Student ID or Certificate of Registration (COR) to verify your account.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Upload Area
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFileSelected = !isFileSelected;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: isFileSelected ? Colors.green.shade50 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isFileSelected ? Colors.green : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFileSelected
                                ? Icons.check_circle_outline_rounded
                                : Icons.cloud_upload_outlined,
                            size: 42,
                            color: isFileSelected ? Colors.green : darkBlue,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isFileSelected
                                ? 'Document Selected'
                                : 'Tap to Upload Document',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isFileSelected
                                  ? Colors.green.shade700
                                  : const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isFileSelected
                                ? 'Tap again to change file'
                                : 'Supports JPG, PNG, or PDF',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFileSelected ? darkBlue : Colors.grey.shade200,
                        foregroundColor: isFileSelected ? Colors.white : Colors.grey.shade500,
                        elevation: isFileSelected ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isFileSelected
                          ? () {
                              setState(() {
                                verificationStatus = 'Pending';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Verification submitted successfully!',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        'Submit Verification',
                        style: TextStyle(
                          fontSize: 16,
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
    );
  }
}