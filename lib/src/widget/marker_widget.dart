import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/src/layer/alignment_util.dart';
import 'package:flutter_map_supercluster/src/layer/map_camera_extension.dart';
import 'package:flutter_map_supercluster/src/splay/displaced_marker.dart';

class MarkerWidget extends StatelessWidget {
  final Marker marker;
  final Widget markerChild;
  final VoidCallback onTap;
  final Offset position;
  final double mapRotationRad;

  MarkerWidget({
    super.key,
    required MapCamera mapCamera,
    required this.marker,
    required this.markerChild,
    required this.onTap,
  })  : mapRotationRad = mapCamera.rotationRad,
        position = _getMapPointPixel(mapCamera, marker);

  MarkerWidget.displaced({
    super.key,
    required DisplacedMarker displacedMarker,
    required Offset position,
    required this.markerChild,
    required this.onTap,
    required this.mapRotationRad,
  })  : marker = displacedMarker.marker,
        position = AlignmentUtil.applyAlignment(
          position,
          displacedMarker.marker.width,
          displacedMarker.marker.height,
          DisplacedMarker.alignment,
        );

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: markerChild,
    );

    return Positioned(
      key: ObjectKey(marker),
      width: marker.width,
      height: marker.height,
      left: position.dx,
      top: position.dy,
      child: marker.rotate != true
          ? child
          : Transform.rotate(
              angle: -mapRotationRad,
              child: child,
            ),
    );
  }

  static Offset _getMapPointPixel(
    MapCamera mapCamera,
    Marker marker,
  ) {
    return AlignmentUtil.applyAlignment(
      mapCamera.getPixelOffset(marker.point),
      marker.width,
      marker.height,
      marker.alignment ?? Alignment.center,
    );
  }
}
