import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/voice_sos_controller.dart';

class SOSLogsList extends StatelessWidget {
  final VoiceSOSController controller;

  const SOSLogsList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.sosLogs.length,
      itemBuilder: (context, index) {
        final log = controller.sosLogs[index];
        return _buildLogCard(context, log);
      },
    ));
  }

  Widget _buildLogCard(BuildContext context, Map<String, dynamic> log) {
    final triggerType = log['triggerType'] as String;
    final timestamp = DateTime.parse(log['timestamp'] as String);
    final status = log['status'] as String;
    final location = log['location'] as String?;
    final contactsNotified = log['contactsNotified'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.size12),
      padding: const EdgeInsets.all(TSizes.size12),
      decoration: BoxDecoration(
        color: TColors.softSand,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getTriggerTypeColor(triggerType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getTriggerTypeIcon(triggerType),
                  color: _getTriggerTypeColor(triggerType),
                  size: 16,
                ),
              ),
              const SizedBox(width: TSizes.size8),
              Expanded(
                child: Text(
                  _getTriggerTypeText(triggerType),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: TColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.size8),

          // Timestamp
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: TColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatTimestamp(timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.textSecondary,
                ),
              ),
            ],
          ),

          // Location (if available)
          if (location != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: TColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Location: $location',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Contacts Notified (if available)
          if (contactsNotified != null && contactsNotified.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  size: 14,
                  color: TColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Notified: $contactsNotified',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getTriggerTypeText(String triggerType) {
    switch (triggerType) {
      case 'voice_triggered':
        return 'Voice Activated';
      case 'manual':
        return 'Manual Trigger';
      default:
        return 'Unknown';
    }
  }

  IconData _getTriggerTypeIcon(String triggerType) {
    switch (triggerType) {
      case 'voice_triggered':
        return Icons.mic;
      case 'manual':
        return Icons.touch_app;
      default:
        return Icons.help_outline;
    }
  }

  Color _getTriggerTypeColor(String triggerType) {
    switch (triggerType) {
      case 'voice_triggered':
        return TColors.mintGreen;
      case 'manual':
        return TColors.sosRed;
      default:
        return TColors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return TColors.mintGreen;
      case 'failed':
        return TColors.sunsetOrange;
      case 'pending':
        return TColors.goldenAmber;
      default:
        return TColors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
