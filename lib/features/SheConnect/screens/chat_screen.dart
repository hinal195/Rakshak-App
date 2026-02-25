import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_models.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final ChatGroup group;

  const ChatScreen({
    super.key,
    required this.group,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.find<ChatController>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.softSand,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name,
              style: const TextStyle(
                color: TColors.textWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${widget.group.memberCount} members',
              style: TextStyle(
                color: TColors.textWhite.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: TColors.deepIndigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: TColors.textWhite,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showGroupInfo(context),
            icon: const Icon(
              Icons.info_outline,
              color: TColors.textWhite,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Group Description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.size12),
            margin: const EdgeInsets.all(TSizes.size8),
            decoration: BoxDecoration(
              color: TColors.textWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: TColors.deepIndigo.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.group,
                  color: TColors.mintGreen,
                  size: 20,
                ),
                const SizedBox(width: TSizes.size8),
                Expanded(
                  child: Text(
                    widget.group.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: TColors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: TSizes.size16),
                      Text(
                        'No messages yet',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: TColors.grey,
                        ),
                      ),
                      const SizedBox(height: TSizes.size8),
                      Text(
                        'Be the first to start the conversation!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: TSizes.size16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return MessageBubble(
                    message: message,
                    isCurrentUser: message.senderNickname == controller.currentNickname.value,
                  );
                },
              );
            }),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(TSizes.size16),
            decoration: BoxDecoration(
              color: TColors.textWhite,
              boxShadow: [
                BoxShadow(
                  color: TColors.deepIndigo.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Location Share Button
                IconButton(
                  onPressed: () => controller.shareLocation(),
                  icon: const Icon(
                    Icons.location_on,
                    color: TColors.mintGreen,
                  ),
                ),
                
                // Message Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColors.softSand,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: TColors.borderColor),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: TSizes.size16,
                          vertical: TSizes.size12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                
                const SizedBox(width: TSizes.size8),
                
                // Send Button
                Obx(() => Container(
                  decoration: BoxDecoration(
                    color: controller.currentNickname.value.isEmpty
                        ? TColors.grey
                        : TColors.mintGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: controller.currentNickname.value.isEmpty
                        ? null
                        : () => _sendMessage(),
                    icon: const Icon(
                      Icons.send,
                      color: TColors.textWhite,
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

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      controller.sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _showGroupInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: TColors.textWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Group Info
            Padding(
              padding: const EdgeInsets.all(TSizes.size20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColors.mintGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.group,
                          color: TColors.mintGreen,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: TSizes.size16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.group.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: TColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.group.memberCount} members',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: TColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.size20),

                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: TColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.size8),
                  Text(
                    widget.group.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: TSizes.size20),

                  Text(
                    'Group Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: TColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.size12),
                  
                  _buildInfoRow(
                    context,
                    Icons.location_on,
                    'Location',
                    '${widget.group.latitude.toStringAsFixed(4)}, ${widget.group.longitude.toStringAsFixed(4)}',
                  ),
                  
                  _buildInfoRow(
                    context,
                    Icons.radio_button_unchecked,
                    'Radius',
                    '${widget.group.radius.toInt()} meters',
                  ),
                  
                  _buildInfoRow(
                    context,
                    Icons.access_time,
                    'Created',
                    _formatDate(widget.group.createdAt),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Leave Group Button
            Padding(
              padding: const EdgeInsets.all(TSizes.size20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.leaveGroup();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Leave Group'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TColors.sunsetOrange,
                    side: const BorderSide(color: TColors.sunsetOrange),
                    padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.size12),
      child: Row(
        children: [
          Icon(
            icon,
            color: TColors.mintGreen,
            size: 20,
          ),
          const SizedBox(width: TSizes.size12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
