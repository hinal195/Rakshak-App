import 'package:flutter/material.dart';
import '../../common/widgets.Login_Signup/custom_shapes/container/TCircleAvatar.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/colors.dart';

class LiveSafeMap_Card extends StatelessWidget {
  final Function? onMapFunction;
  final Color? backgroundColor;

  const LiveSafeMap_Card({Key? key,
    this.onMapFunction,
    this.backgroundColor,
    required this.imageUrl,
    required this.name,
    required this.openurl})

      : super(key: key);
  final String imageUrl,name,openurl;
  
  Color _getServiceColor(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'police':
        return TColors.police;
      case 'hospital':
        return TColors.hospital;
      case 'bus stop':
        return TColors.busStop;
      case 'pharmacy':
        return TColors.pharmacy;
      default:
        return TColors.goldenAmber;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final serviceColor = _getServiceColor(name);
    return InkWell(
      onTap: () {
        onMapFunction!(openurl);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 120,
        width: 170,
        decoration: BoxDecoration(
          color: TColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: serviceColor.withOpacity(0.12),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -------CIRCULAR AVATAR WITH GRADIENT BACKGROUND (Cooper-style) --------
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    serviceColor.withOpacity(0.15),
                    serviceColor.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.all(12),
              child: TCircularAvatar(imageUrl: imageUrl, radius: 24),
            ),

            // ------TEXT OF IMAGE HERE --------
            SizedBox(height: TSizes.size12),
            Text(
              name, 
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: TColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

