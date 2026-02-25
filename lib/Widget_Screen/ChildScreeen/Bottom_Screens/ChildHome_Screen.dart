import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../HomeScreen_Widget/LIvesafe_Screen.dart';
import '../../../features/SOS Help Screen/Google_Map/screens/GoogleMap_View.dart';
import '../../../features/WaySecure/screens/simple_unsafe_zone_screen.dart';
import '../../../features/VoiceSOS/screens/voice_sos_screen.dart';
import 'add_Contacts.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBE4E6),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Color(0xFFFBE4E6),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rakshak",
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD96C7C).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () => Get.to(() => AddContactsPage()),
                        icon: Icon(
                          Icons.contact_page_outlined,
                          color: Color(0xFFD96C7C),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Hello!",
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Make your day safe with us",
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Emergency Services",
                        style: TextStyle(
                          color: Color(0xFF2B2B2B),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16),
                      const LiveSafe(),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                Text(
                  "Safety Modules",
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildSafetyModuleCard(
                        context,
                        title: "WaySecure",
                        subtitle: "Unsafe Zone Alerts",
                        icon: Icons.warning_rounded,
                        iconColor: Color(0xFFE85C6A),
                        onTap: () => Get.to(() => const SimpleUnsafeZoneScreen()),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildSafetyModuleCard(
                        context,
                        title: "Voice SOS",
                        subtitle: "Voice-Activated Alerts",
                        icon: Icons.mic_rounded,
                        iconColor: Color(0xFFE85C6A),
                        onTap: () => Get.to(() => const VoiceSOSScreen()),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: GoogleMap_View_Screen(),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSafetyModuleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFFF6A6B2).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
