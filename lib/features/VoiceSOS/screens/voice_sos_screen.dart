import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/voice_sos_controller.dart';
import '../widgets/trusted_contacts_list.dart';
import '../widgets/sos_logs_list.dart';
import '../widgets/add_contact_dialog.dart';

class VoiceSOSScreen extends StatelessWidget {
  const VoiceSOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VoiceSOSController controller = Get.put(VoiceSOSController());

    return Scaffold(
      backgroundColor: Color(0xFFFBE4E6),
      appBar: AppBar(
        title: const Text(
          'Voice-Activated SOS',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Color(0xFFFBE4E6),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: TSizes.size8),
            decoration: BoxDecoration(
              color: Color(0xFFD96C7C).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () => _showAddContactDialog(context, controller),
              icon: const Icon(
                Icons.contact_phone_rounded,
                color: Color(0xFFD96C7C),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voice SOS Status Card
            _buildStatusCard(context, controller),

            const SizedBox(height: TSizes.size20),

            // Manual SOS Button
            _buildManualSOSButton(context, controller),

            const SizedBox(height: TSizes.size20),

            // Trusted Contacts Section
            _buildTrustedContactsSection(context, controller),

            const SizedBox(height: TSizes.size20),

            // SOS Logs Section
            _buildSOSLogsSection(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, VoiceSOSController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.size24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFE85C6A).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Color(0xFFE85C6A),
                  size: 28,
                ),
              ),
              const SizedBox(width: TSizes.size12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice-Activated SOS',
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Obx(() => Text(
                      controller.isVoiceSOSEnabled.value
                          ? 'Active - Listening for wake words'
                          : 'Inactive - Voice monitoring disabled',
                      style: TextStyle(
                        color: controller.isVoiceSOSEnabled.value
                            ? Color(0xFFE85C6A)
                            : Color(0xFF6F6F6F),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.size16),

          // Wake Words Info
          Container(
            padding: const EdgeInsets.all(TSizes.size16),
            decoration: BoxDecoration(
              color: Color(0xFFF6A6B2).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wake Words:',
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: TSizes.size8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: ['SOS', 'Help', 'Bachao', 'Emergency', 'Danger']
                      .map((word) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFE85C6A).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFE85C6A).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              word,
                              style: TextStyle(
                                color: Color(0xFFE85C6A),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.size16),

          // Toggle Button
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.toggleVoiceSOS(),
              icon: Icon(
                controller.isVoiceSOSEnabled.value
                    ? Icons.mic_off
                    : Icons.mic,
              ),
              label: Text(
                controller.isVoiceSOSEnabled.value
                    ? 'Disable Voice SOS'
                    : 'Enable Voice SOS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.isVoiceSOSEnabled.value
                    ? Color(0xFFE85C6A)
                    : Color(0xFFD96C7C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: TSizes.size16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildManualSOSButton(BuildContext context, VoiceSOSController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.size24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE85C6A).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Manual Emergency Alert',
            style: TextStyle(
              color: Color(0xFF2B2B2B),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: TSizes.size8),
          Text(
            'Tap the button below to send an immediate SOS alert to your trusted contacts',
            style: TextStyle(
              color: Color(0xFF6F6F6F),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.size24),
          Obx(() => Container(
            width: double.infinity,
            height: 64,
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
                  color: Color(0xFFE85C6A).withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : () => _showSOSConfirmation(context, controller),
              icon: const Icon(Icons.warning_rounded, size: 28),
              label: const Text(
                'SEND SOS ALERT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: TSizes.size16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTrustedContactsSection(BuildContext context, VoiceSOSController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.size24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFD96C7C).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.contact_phone_rounded,
                  color: Color(0xFFD96C7C),
                  size: 24,
                ),
              ),
              const SizedBox(width: TSizes.size12),
              Text(
                'Trusted Contacts',
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD96C7C).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => _showAddContactDialog(context, controller),
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    color: Color(0xFFD96C7C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.size12),
          Obx(() {
            if (controller.trustedContacts.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_phone_outlined,
                      size: 48,
                      color: Color(0xFF6F6F6F).withOpacity(0.5),
                    ),
                    const SizedBox(height: TSizes.size12),
                    Text(
                      'No trusted contacts added',
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TSizes.size8),
                    Text(
                      'Add contacts to receive emergency alerts',
                      style: TextStyle(
                        color: Color(0xFF6F6F6F),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            }
            return TrustedContactsList(controller: controller);
          }),
        ],
      ),
    );
  }

  Widget _buildSOSLogsSection(BuildContext context, VoiceSOSController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.size24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF6A6B2).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Color(0xFFE85C6A),
                  size: 24,
                ),
              ),
              const SizedBox(width: TSizes.size12),
              Text(
                'SOS History',
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.size12),
          Obx(() {
            if (controller.sosLogs.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history_outlined,
                      size: 48,
                      color: Color(0xFF6F6F6F).withOpacity(0.5),
                    ),
                    const SizedBox(height: TSizes.size12),
                    Text(
                      'No SOS alerts sent yet',
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SOSLogsList(controller: controller);
          }),
        ],
      ),
    );
  }

  void _showSOSConfirmation(BuildContext context, VoiceSOSController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning,
              color: Color(0xFFE85C6A),
              size: 28,
            ),
            const SizedBox(width: TSizes.size8),
            const Text(
              'Confirm SOS Alert',
              style: TextStyle(
                color: Color(0xFF2B2B2B),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to send an emergency SOS alert to all your trusted contacts?',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6F6F6F),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.triggerManualSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE85C6A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Send SOS',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, VoiceSOSController controller) {
    showDialog(
      context: context,
      builder: (context) => const AddContactDialog(),
    );
  }
}
