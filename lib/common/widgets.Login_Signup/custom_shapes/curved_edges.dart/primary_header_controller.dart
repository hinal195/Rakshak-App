import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../container/circular_container.dart';
import 'curved_edges.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3F3D8F),
              Color(0xFF6F6BCF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            /// Creating the Stack Position with modern styling
            Positioned(top: -220, right: -80, child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.15))),
            Positioned(top: 50,right: -250,child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.15))),
            child
            // Add your other widgets or content here
          ],
        ),
      ),
    );
  }
}

class TCurvedEdgesWidget extends StatelessWidget {
  const TCurvedEdgesWidget({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCustomCurvesEdge(),
      child: child,
    );
  }
}
