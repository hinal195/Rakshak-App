import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../models/unsafe_zone_model.dart';
import '../controllers/unsafe_zone_controller.dart';

class UnsafeZoneBottomSheet extends StatelessWidget {
  final UnsafeZone zone;

  const UnsafeZoneBottomSheet({
    super.key,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    final UnsafeZoneController controller = Get.find<UnsafeZoneController>();

    // Ensure latest crime reports are loaded for the selected zone
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCrimeReportsForZone(zone.id);
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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

          // Header
          Padding(
            padding: const EdgeInsets.all(TSizes.size16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.sunsetOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: TColors.sunsetOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: TSizes.size12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: TColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Severity: ${_getSeverityText(zone.severity)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getSeverityColor(zone.severity),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.size16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.size12),
              decoration: BoxDecoration(
                color: TColors.softSand,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                zone.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.textSecondary,
                ),
              ),
            ),
          ),

          const SizedBox(height: TSizes.size16),

          // Crime Reports Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.size16),
            child: Row(
              children: [
                const Icon(
                  Icons.article_outlined,
                  color: TColors.deepIndigo,
                  size: 20,
                ),
                const SizedBox(width: TSizes.size8),
                Text(
                  'Recent Crime Reports',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.size12),

          // Crime Reports List
          Expanded(
            child: Obx(() {
              if (controller.crimeReports.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: TColors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: TSizes.size12),
                      Text(
                        'No crime reports available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TColors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.size16),
                itemCount: controller.crimeReports.length,
                itemBuilder: (context, index) {
                  final report = controller.crimeReports[index];
                  return _buildCrimeReportCard(context, report);
                },
              );
            }),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(TSizes.size16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addCrimeReport(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.mintGreen,
                      foregroundColor: TColors.textWhite,
                      padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.size12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareLocation(context),
                    icon: const Icon(Icons.share_location),
                    label: const Text('Share Location'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TColors.deepIndigo,
                      side: const BorderSide(color: TColors.deepIndigo),
                      padding: const EdgeInsets.symmetric(vertical: TSizes.size12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrimeReportCard(BuildContext context, CrimeReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.size12),
      padding: const EdgeInsets.all(TSizes.size12),
      decoration: BoxDecoration(
        color: TColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: TColors.deepIndigo.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSourceColor(report.source).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report.source.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getSourceColor(report.source),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(report.reportedAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.size8),
          Text(
            report.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: TColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: TSizes.size4),
          Text(
            report.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TColors.textSecondary,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (report.url != null) ...[
            const SizedBox(height: TSizes.size8),
            GestureDetector(
              onTap: () => _openUrl(report.url!),
              child: Text(
                'Read more...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.mintGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getSeverityText(int severity) {
    switch (severity) {
      case 1:
        return 'Low';
      case 2:
        return 'Moderate';
      case 3:
        return 'Medium';
      case 4:
        return 'High';
      case 5:
        return 'Critical';
      default:
        return 'Unknown';
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

  Color _getSourceColor(String source) {
    switch (source.toLowerCase()) {
      case 'user':
        return TColors.mintGreen;
      case 'news':
        return TColors.deepIndigo;
      case 'police':
        return TColors.sunsetOrange;
      default:
        return TColors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _addCrimeReport(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final urlController = TextEditingController();
    String selectedSource = 'user';

    showDialog(
      context: context,
      builder: (dialogContext) {
        final UnsafeZoneController controller = Get.find<UnsafeZoneController>();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Crime Report'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.article_outlined),
                  ),
                ),
                const SizedBox(height: TSizes.size12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: TSizes.size12),
                DropdownButtonFormField<String>(
                  value: selectedSource,
                  items: const [
                    DropdownMenuItem(
                      value: 'user',
                      child: Text('User Report'),
                    ),
                    DropdownMenuItem(
                      value: 'news',
                      child: Text('News Source'),
                    ),
                    DropdownMenuItem(
                      value: 'police',
                      child: Text('Police'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Source',
                    prefixIcon: Icon(Icons.source),
                  ),
                  onChanged: (value) {
                    if (value != null) selectedSource = value;
                  },
                ),
                const SizedBox(height: TSizes.size12),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Reference URL (optional)',
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {
                  Get.snackbar('Error', 'Please enter a title and description');
                  return;
                }

                await controller.addCrimeReport(
                  zoneId: zone.id,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  source: selectedSource,
                  url: urlController.text.trim().isEmpty
                      ? null
                      : urlController.text.trim(),
                );

                await controller.loadCrimeReportsForZone(zone.id);
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.mintGreen,
                foregroundColor: TColors.textWhite,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      descriptionController.dispose();
      urlController.dispose();
    });
  }

  void _shareLocation(BuildContext context) {
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${zone.latitude},${zone.longitude}',
    );

    launchUrl(mapsUri, mode: LaunchMode.externalApplication).then((success) {
      if (!success) {
        Get.snackbar('Error', 'Unable to open maps for this location');
      }
    });
  }

  void _openUrl(String url) {
    final Uri uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication).then((success) {
      if (!success) {
        Get.snackbar('Error', 'Unable to open link');
      }
    });
  }
}
