import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/unsafe_zone_controller.dart';

class ReportUnsafeZoneDialog extends StatefulWidget {
  const ReportUnsafeZoneDialog({super.key});

  @override
  State<ReportUnsafeZoneDialog> createState() => _ReportUnsafeZoneDialogState();
}

class _ReportUnsafeZoneDialogState extends State<ReportUnsafeZoneDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _radiusController = TextEditingController(text: '100');
  int _selectedSeverity = 3;

  @override
  Widget build(BuildContext context) {
    final UnsafeZoneController controller = Get.find<UnsafeZoneController>();

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
                      color: TColors.sunsetOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.report_problem,
                      color: TColors.sunsetOrange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: TSizes.size12),
                  Expanded(
                    child: Text(
                      'Report Unsafe Zone',
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

              // Zone Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Zone Name',
                  hintText: 'e.g., Downtown Alley, Park Area',
                  prefixIcon: const Icon(Icons.location_on, color: TColors.deepIndigo),
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
                    return 'Please enter zone name';
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
                  hintText: 'Describe why this area is unsafe...',
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
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

              // Radius
              TextFormField(
                controller: _radiusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Alert Radius (meters)',
                  hintText: '100',
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
                  return null;
                },
              ),

              const SizedBox(height: TSizes.size16),

              // Severity Level
              Text(
                'Severity Level',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TSizes.size8),
              Row(
                children: List.generate(5, (index) {
                  final severity = index + 1;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSeverity = severity),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedSeverity == severity
                              ? _getSeverityColor(severity)
                              : _getSeverityColor(severity).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getSeverityColor(severity),
                            width: _selectedSeverity == severity ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              severity.toString(),
                              style: TextStyle(
                                color: _selectedSeverity == severity
                                    ? TColors.textWhite
                                    : _getSeverityColor(severity),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getSeverityText(severity),
                              style: TextStyle(
                                color: _selectedSeverity == severity
                                    ? TColors.textWhite
                                    : _getSeverityColor(severity),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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
                      onPressed: () => _submitReport(controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.sunsetOrange,
                        foregroundColor: TColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Report Zone'),
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

  String _getSeverityText(int severity) {
    switch (severity) {
      case 1:
        return 'Low';
      case 2:
        return 'Mod';
      case 3:
        return 'Med';
      case 4:
        return 'High';
      case 5:
        return 'Crit';
      default:
        return '?';
    }
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 1:
        return TColors.mintGreen;
      case 2:
        return TColors.goldenAmber;
      case 3:
        return TColors.sunsetOrange;
      case 4:
        return TColors.sunsetOrange;
      case 5:
        return TColors.sosRed;
      default:
        return TColors.grey;
    }
  }

  void _submitReport(UnsafeZoneController controller) {
    if (_formKey.currentState!.validate()) {
      final currentPosition = controller.currentPosition.value;
      if (currentPosition == null) {
        Get.snackbar('Error', 'Unable to get current location');
        return;
      }

      controller.addUnsafeZone(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        radius: double.parse(_radiusController.text),
        reportedBy: 'User', // TODO: Get actual user ID
        severity: _selectedSeverity,
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
