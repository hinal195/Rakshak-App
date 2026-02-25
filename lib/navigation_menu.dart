
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'Widget_Screen/AdavancedSafety_Tool/Safety_tool.dart';
import 'Widget_Screen/ChildScreeen/Bottom_Screens/ChildHome_Screen.dart';
import 'features/News/screens/news_page.dart';
import 'features/personalization/screens/setting/setting.dart';
import 'features/SheConnect/screens/sheconnect_home_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: Color(0xFFFBE4E6),
      bottomNavigationBar: Obx(
            ()=> Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            indicatorColor: Color(0xFFE85C6A).withOpacity(0.2),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.newspaper_rounded, color: Color(0xFF6F6F6F), size: 22),
                selectedIcon: Icon(Icons.newspaper_rounded, color: Color(0xFFE85C6A), size: 22),
                label: "News",
              ),
              NavigationDestination(
                icon: Icon(Icons.health_and_safety_rounded, color: Color(0xFF6F6F6F), size: 22),
                selectedIcon: Icon(Icons.health_and_safety_rounded, color: Color(0xFFE85C6A), size: 22),
                label: "Safety Tools",
              ),
              NavigationDestination(
                icon: Icon(Icons.home_rounded, color: Color(0xFF6F6F6F), size: 22),
                selectedIcon: Icon(Icons.home_rounded, color: Color(0xFFE85C6A), size: 22),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.group_rounded, color: Color(0xFF6F6F6F), size: 22),
                selectedIcon: Icon(Icons.group_rounded, color: Color(0xFFE85C6A), size: 22),
                label: "SheConnect",
              ),
              NavigationDestination(
                icon: Icon(Iconsax.profile_add, color: Color(0xFF6F6F6F), size: 22),
                selectedIcon: Icon(Iconsax.profile_add, color: Color(0xFFE85C6A), size: 22),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value])
    );
  }
}


class NavigationController extends  GetxController{
  final Rx<int>  selectedIndex = 2.obs;

  final screens = [NewsTabView(),SafetyToolScreen(),HomeScreen(),const SheConnectHomeScreen(),const SettingScreen()];

}
