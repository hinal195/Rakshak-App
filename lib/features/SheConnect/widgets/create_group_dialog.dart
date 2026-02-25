import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/chat_controller.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({super.key});

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _radiusController = TextEditingController(text: '500');

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
                      Icons.group_add,
                      color: TColors.mintGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: TSizes.size12),
                  Expanded(
                    child: Text(
                      'Create Safety Group',
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

              // Group Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'e.g., Downtown Safety Group',
                  prefixIcon: const Icon(Icons.group, color: TColors.deepIndigo),
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
                    return 'Please enter group name';
                  }
                  if (value.length < 3) {
                    return 'Group name must be at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe the purpose of this group...',
                  prefixIcon: const Icon(Icons.description, color: TColors.deepIndigo),
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
                    return 'Please enter description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

              // Radius
              TextFormField(
                controller: _radiusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Group Radius (meters)',
                  hintText: '500',
                  prefixIcon: const Icon(Icons.radio_button_unchecked, color: TColors.deepIndigo),
                  suffixText: 'm',
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
                    return 'Please enter radius';
                  }
                  final radius = double.tryParse(value);
                  if (radius == null || radius <= 0) {
                    return 'Please enter valid radius';
                  }
                  if (radius < 100) {
                    return 'Radius must be at least 100 meters';
                  }
                  if (radius > 5000) {
                    return 'Radius cannot exceed 5000 meters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size20),

              // Info Box
              Container(
                padding: const EdgeInsets.all(TSizes.size12),
                decoration: BoxDecoration(
                  color: TColors.mintGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TColors.mintGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: TColors.mintGreen,
                      size: 20,
                    ),
                    const SizedBox(width: TSizes.size8),
                    Expanded(
                      child: Text(
                        'Your group will be visible to users within the specified radius. You can join and start chatting immediately.',
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
                      onPressed: () => _createGroup(controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.mintGreen,
                        foregroundColor: TColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Create Group'),
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

  void _createGroup(ChatController controller) {
    if (_formKey.currentState!.validate()) {
      controller.createGroup(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        radius: double.parse(_radiusController.text),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _radiusController.dispose();
    super.dispose();
  }
}
