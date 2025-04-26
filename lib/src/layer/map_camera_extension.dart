import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

extension MapCameraExtension on MapCamera {
  Offset getPixelOffset(LatLng point) =>
      projectAtZoom(point) - pixelOrigin;

  LatLngBounds paddedMapBounds(Size clusterWidgetSize) {
    final boundsPixelPadding = Offset(
      clusterWidgetSize.width / 2,
      clusterWidgetSize.height / 2,
    );
    final bounds = pixelBounds;
    return LatLngBounds(
      unprojectAtZoom(bounds.topLeft - boundsPixelPadding),
      unprojectAtZoom(bounds.bottomRight + boundsPixelPadding),
    );
  }
}
