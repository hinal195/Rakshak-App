import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rakshak/Widget_Screen/AdavancedSafety_Tool/widget/single_video.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Chat_Module/ChatBot.dart';
import '../../common/widgets.Login_Signup/custom_shapes/container/TCircleAvatar.dart';
import '../../features/Advanced_Safety_Tool/Report_Incident/widgets/ReportForm_bottomsheet.dart';
import '../HomeScreen_Widget/Emergency_Helpline/Emergency_Screen.dart';

class SafetyToolScreen extends StatelessWidget {
  const SafetyToolScreen({super.key});

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
                Text(
                  "Safety Tools",
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Safety first, avoid the worst",
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
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Resources',
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModernToolCard(
                      context,
                      image: "assets/images/images/img_1.png",
                      text: "Safety Tips",
                      color: Color(0xFFD96C7C),
                      onTap: () => _launchURL("https://www.desotosheriff.com/community/tips_for_women_on_staying_safe!.php"),
                    ),
                    _buildModernToolCard(
                      context,
                      image: "assets/images/images/img_2.png",
                      text: "Self Defence",
                      color: Color(0xFFD96C7C),
                      onTap: () => Get.to(() => SingleVideo()),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModernToolCard(
                      context,
                      image: "assets/images/images/pepper_spray.png",
                      text: "Defence Tools",
                      color: Color(0xFFF6A6B2),
                      onTap: () => _launchURL("https://www.defenderring.com/blogs/news/10-best-self-defense-weapons-for-women-in-2023"),
                    ),
                    _buildModernToolCard(
                      context,
                      image: "assets/images/images/img_4.png",
                      text: "AI ChatBot",
                      color: Color(0xFFD96C7C),
                      onTap: () => Get.to(() => ChatBotScreen()),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),

                _buildEmergencyCard(
                  context,
                  onPressed: () => Get.to(() => ReportCrimeIncidentScreen()),
                  image: 'assets/images/images/CrimeReport.png',
                  title: 'Report Crime Incident',
                  subtitle: 'Stay Alert, Report Fast.',
                  color: Color(0xFFE85C6A),
                ),
                SizedBox(height: 16),

                _buildEmergencyCard(
                  context,
                  onPressed: () => Get.to(() => EmergencyScreen()),
                  image: 'assets/images/images/img.png',
                  title: 'Emergency Helpline',
                  subtitle: 'Quick Access to Emergency Contacts for Assistance',
                  color: Color(0xFFE85C6A),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildModernToolCard(BuildContext context, {
    required String image,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 140,
        width: 160,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(12),
              child: TCircularAvatar(imageUrl: image, radius: 24),
            ),
            SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                color: Color(0xFF2B2B2B),
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context, {
    required VoidCallback onPressed,
    required String image,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: TCircularAvatar(imageUrl: image, radius: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
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
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }
}
