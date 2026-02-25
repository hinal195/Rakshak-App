import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/widgets.Login_Signup/list_Tile/user_profile.dart';
import '../../../../common/widgets.Login_Signup/texts/section_heading.dart';
import '../../../../data/repositories/authentication/authentication-repository.dart';
import '../../controllers/user_controller.dart';
import '../profile/profile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    userController.fetchUserRecord();

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
                  "Account",
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 20),
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
                  child: TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 8),
              const TSectionHeading(
                  title: "App Settings", showActionButton: false),
              const SizedBox(height: 16),

              _buildModernSettingTile(
                context,
                onTap: () async {
                  final uri = Uri.parse('https://nirajchalke.github.io/NirajChalke.github.io-PrivacyPolicy/');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: Icons.policy,
                title: "Privacy Policy",
                subtitle: "About the Shield App",
                iconColor: Color(0xFFF6A6B2),
              ),

              _buildModernSettingTile(
                context,
                onTap: () async {
                  final uri = Uri.parse('mailto:hinalapatel195@gmail.com');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                icon: Icons.headset_mic,
                title: "Help Center",
                subtitle: "hinalapatel195@gmail.com",
                iconColor: Color(0xFFD96C7C),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AuthenticationRepository.instance.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE85C6A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }

  Widget _buildModernSettingTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (iconColor ?? Color(0xFFD96C7C)).withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Color(0xFFD96C7C),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Color(0xFF6F6F6F),
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF6F6F6F),
          size: 14,
        ),
      ),
    );
  }
}
