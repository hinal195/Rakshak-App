import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../models/chat_models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.size12),
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            // Avatar for other users
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TColors.mintGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message.senderNickname.isNotEmpty
                      ? message.senderNickname[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: TColors.mintGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TSizes.size8),
          ],

          // Message Content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(TSizes.size12),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? TColors.mintGreen
                    : TColors.textWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                  bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: TColors.deepIndigo.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender name (for other users)
                  if (!isCurrentUser) ...[
                    Text(
                      message.senderNickname,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TColors.mintGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Message content
                  if (message.type == MessageType.location) ...[
                    _buildLocationMessage(context),
                  ] else if (message.type == MessageType.system) ...[
                    _buildSystemMessage(context),
                  ] else ...[
                    Text(
                      message.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isCurrentUser
                            ? TColors.textWhite
                            : TColors.textPrimary,
                      ),
                    ),
                  ],

                  const SizedBox(height: 4),

                  // Timestamp
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isCurrentUser
                              ? TColors.textWhite.withOpacity(0.8)
                              : TColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 12,
                          color: TColors.textWhite.withOpacity(0.8),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isCurrentUser) ...[
            const SizedBox(width: TSizes.size8),
            // Avatar for current user
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TColors.deepIndigo.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: TColors.deepIndigo,
                  size: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.size8),
      decoration: BoxDecoration(
        color: TColors.mintGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: TColors.mintGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: TColors.mintGreen,
            size: 20,
          ),
          const SizedBox(width: TSizes.size8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.locationName ?? 'Shared Location',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isCurrentUser
                        ? TColors.textWhite
                        : TColors.mintGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (message.latitude != null && message.longitude != null)
                  Text(
                    '${message.latitude!.toStringAsFixed(4)}, ${message.longitude!.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isCurrentUser
                          ? TColors.textWhite.withOpacity(0.8)
                          : TColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.size8,
        vertical: TSizes.size4,
      ),
      decoration: BoxDecoration(
        color: TColors.goldenAmber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            color: TColors.goldenAmber,
            size: 16,
          ),
          const SizedBox(width: TSizes.size4),
          Text(
            message.message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TColors.goldenAmber,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
