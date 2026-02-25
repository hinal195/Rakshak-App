import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_models.dart';
import '../screens/chat_screen.dart';

class JoinGroupDialog extends StatefulWidget {
  final ChatGroup group;

  const JoinGroupDialog({
    super.key,
    required this.group,
  });

  @override
  State<JoinGroupDialog> createState() => _JoinGroupDialogState();
}

class _JoinGroupDialogState extends State<JoinGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(TSizes.size20),
        decoration: BoxDecoration(
          color: TColors.textWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TColors.mintGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.group,
                      color: TColors.mintGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: TSizes.size12),
                  Expanded(
                    child: Text(
                      'Join Group',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: TColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: TColors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.size20),

              // Group Info
              Container(
                padding: const EdgeInsets.all(TSizes.size12),
                decoration: BoxDecoration(
                  color: TColors.softSand,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.group.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: TColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.size4),
                    Text(
                      widget.group.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: TSizes.size8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: TColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.group.memberCount} members',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: TSizes.size16),
                        Icon(
                          Icons.radio_button_unchecked,
                          size: 16,
                          color: TColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.group.radius.toInt()}m radius',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.size20),

              // Nickname Input
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Your Nickname',
                  hintText: 'Choose a nickname for this group',
                  prefixIcon: const Icon(Icons.person, color: TColors.deepIndigo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: TColors.mintGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nickname';
                  }
                  if (value.length < 2) {
                    return 'Nickname must be at least 2 characters';
                  }
                  if (value.length > 20) {
                    return 'Nickname cannot exceed 20 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

              // Privacy Info
              Container(
                padding: const EdgeInsets.all(TSizes.size12),
                decoration: BoxDecoration(
                  color: TColors.goldenAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TColors.goldenAmber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.privacy_tip_outlined,
                      color: TColors.goldenAmber,
                      size: 20,
                    ),
                    const SizedBox(width: TSizes.size8),
                    Expanded(
                      child: Text(
                        'Your identity is completely anonymous. Only your nickname will be visible to other members.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.size24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TColors.grey,
                        side: const BorderSide(color: TColors.grey),
                        padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: TSizes.size12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _joinGroup(controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.mintGreen,
                        foregroundColor: TColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Join Group'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinGroup(ChatController controller) {
    if (_formKey.currentState!.validate()) {
      controller.joinGroup(
        widget.group.id,
        _nicknameController.text.trim(),
      );
      
      Navigator.pop(context);
      
      // Navigate to chat screen
      Get.to(() => ChatScreen(group: widget.group));
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
}
