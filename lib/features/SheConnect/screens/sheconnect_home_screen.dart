import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_models.dart';
import '../widgets/group_card.dart';
import '../widgets/create_group_dialog.dart';
import '../widgets/join_group_dialog.dart';

class SheConnectHomeScreen extends StatelessWidget {
  const SheConnectHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: Color(0xFFFBE4E6),
      appBar: AppBar(
        title: const Text(
          'SheConnect',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFFFBE4E6),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Color(0xFFD96C7C).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () => _showCreateGroupDialog(context, controller),
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: Color(0xFFD96C7C),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Safety Groups Near You',
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Connect anonymously with women in your area for safety and support',
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFBE4E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFE85C6A),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Search Radius: ',
                            style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                          Obx(() => Text(
                            '${controller.searchRadius.value.toInt()} km',
                            style: TextStyle(
                              color: Color(0xFFE85C6A),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          )),
                        ],
                      ),
                      SizedBox(height: 12),
                      Obx(() => Slider(
                        value: controller.searchRadius.value,
                        min: 1.0,
                        max: 20.0,
                        divisions: 19,
                        activeColor: Color(0xFFE85C6A),
                        inactiveColor: Color(0xFF6F6F6F).withOpacity(0.2),
                        onChanged: (value) {
                          controller.updateSearchRadius(value);
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE85C6A),
                  ),
                );
              }

              if (controller.nearbyGroups.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFE85C6A).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.group_outlined,
                            size: 48,
                            color: Color(0xFFE85C6A),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No groups found nearby',
                          style: TextStyle(
                            color: Color(0xFF2B2B2B),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try increasing your search radius or create a new group to connect with others in your area',
                          style: TextStyle(
                            color: Color(0xFF6F6F6F),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFE85C6A),
                                Color(0xFFF6A6B2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFE85C6A).withOpacity(0.3),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _showCreateGroupDialog(context, controller),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              'Create Group',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.nearbyGroups.length,
                itemBuilder: (context, index) {
                  final group = controller.nearbyGroups[index];
                  return GroupCard(
                    group: group,
                    onJoin: () => _showJoinGroupDialog(context, controller, group),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, ChatController controller) {
    showDialog(
      context: context,
      builder: (context) => const CreateGroupDialog(),
    );
  }

  void _showJoinGroupDialog(BuildContext context, ChatController controller, ChatGroup group) {
    showDialog(
      context: context,
      builder: (context) => JoinGroupDialog(group: group),
    );
  }
}
