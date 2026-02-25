import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/voice_sos_controller.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final VoiceSOSController controller = Get.find<VoiceSOSController>();

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
                      Icons.contact_phone,
                      color: TColors.mintGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: TSizes.size12),
                  Expanded(
                    child: Text(
                      'Add Trusted Contact',
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

              // Contact Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Contact Name',
                  hintText: 'e.g., Mom, Dad, Friend',
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
                    return 'Please enter contact name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+1234567890',
                  prefixIcon: const Icon(Icons.phone, color: TColors.deepIndigo),
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
                    return 'Please enter phone number';
                  }
                  // Basic phone number validation
                  final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
                  if (!phoneRegex.hasMatch(value.replaceAll(' ', '').replaceAll('-', ''))) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

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
                        'This contact will receive SMS alerts when you trigger an SOS emergency.',
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
                      onPressed: () => _addContact(controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.mintGreen,
                        foregroundColor: TColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Contact'),
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

  void _addContact(VoiceSOSController controller) {
    if (_formKey.currentState!.validate()) {
      controller.addTrustedContact(
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
