import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/unsafe_zone_controller.dart';
// Removed unused imports
import '../widgets/report_unsafe_zone_dialog.dart';

class SimpleUnsafeZoneScreen extends StatelessWidget {
  const SimpleUnsafeZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UnsafeZoneController controller = Get.put(UnsafeZoneController());

    return Scaffold(
      backgroundColor: Color(0xFFFBE4E6),
      appBar: AppBar(
        title: const Text(
          'WaySecure - Unsafe Zones',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Color(0xFFFBE4E6),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
        actions: [
          IconButton(
            onPressed: () => _showReportDialog(context),
            icon: const Icon(
              Icons.report_problem,
              color: Color(0xFFE85C6A),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.size20),
            margin: const EdgeInsets.all(TSizes.size16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFE85C6A).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.warning,
                        color: Color(0xFFE85C6A),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: TSizes.size12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WaySecure Safety',
                            style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Unsafe Zone Alerts & Monitoring',
                            style: TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.size16),
                Text(
                  'This feature helps you stay aware of unsafe areas and receive alerts when you enter flagged zones. You can report new unsafe areas and view recent crime reports.',
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Features List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.size16),
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.location_on,
                  title: 'Location Monitoring',
                  description: 'Real-time monitoring of your location for unsafe zone alerts',
                  color: Color(0xFFD96C7C),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.warning,
                  title: 'Unsafe Zone Alerts',
                  description: 'Get notified when entering flagged dangerous areas',
                  color: Color(0xFFE85C6A),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.report_problem,
                  title: 'Report Unsafe Areas',
                  description: 'Help the community by reporting dangerous locations',
                  color: Color(0xFFF6A6B2),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.article,
                  title: 'Crime Reports',
                  description: 'View recent crime reports for specific areas',
                  color: Color(0xFFD96C7C),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.notifications,
                  title: 'Emergency Alerts',
                  description: 'Automatic SMS alerts to trusted contacts',
                  color: Color(0xFFE85C6A),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(TSizes.size16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showReportDialog(context),
                    icon: const Icon(Icons.add_location),
                    label: const Text(
                      'Report Unsafe Zone',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE85C6A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.size12),
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLocationMonitoring.value
                        ? () => controller.stopLocationMonitoring()
                        : () => controller.startLocationMonitoring(),
                    icon: Icon(
                      controller.isLocationMonitoring.value
                          ? Icons.location_off
                          : Icons.location_on,
                    ),
                    label: Text(
                      controller.isLocationMonitoring.value
                          ? 'Stop Monitoring'
                          : 'Start Monitoring',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isLocationMonitoring.value
                          ? Color(0xFFE85C6A)
                          : Color(0xFFD96C7C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.size12),
      padding: const EdgeInsets.all(TSizes.size16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: TSizes.size12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ReportUnsafeZoneDialog(),
    );
  }
}
