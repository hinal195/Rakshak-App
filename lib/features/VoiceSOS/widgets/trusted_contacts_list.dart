import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/voice_sos_controller.dart';

class TrustedContactsList extends StatelessWidget {
  final VoiceSOSController controller;

  const TrustedContactsList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.trustedContacts.length,
      itemBuilder: (context, index) {
        final contact = controller.trustedContacts[index];
        return _buildContactCard(context, contact);
      },
    ));
  }

  Widget _buildContactCard(BuildContext context, Map<String, dynamic> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.size12),
      padding: const EdgeInsets.all(TSizes.size12),
      decoration: BoxDecoration(
        color: TColors.softSand,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.borderColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TColors.mintGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (contact['name'] as String).isNotEmpty
                    ? (contact['name'] as String)[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: TColors.mintGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(width: TSizes.size12),

          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: TColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact['phone'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            onPressed: () => _showRemoveContactDialog(context, contact),
            icon: const Icon(
              Icons.delete_outline,
              color: TColors.sunsetOrange,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveContactDialog(BuildContext context, Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Remove Contact'),
        content: Text(
          'Are you sure you want to remove ${contact['name']} from your trusted contacts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.removeTrustedContact(contact['id'] as int);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.sunsetOrange,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
