import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:flutter_map_supercluster_example/drawer.dart';
import 'package:flutter_map_supercluster_example/main.dart';
import 'package:latlong2/latlong.dart';

class NormalAndClusteredMarkersWithPopupsPage extends StatefulWidget {
  static const String route = 'normalAndClusteredMarkersWithPopupsPage';

  const NormalAndClusteredMarkersWithPopupsPage({super.key});

  @override
  State<NormalAndClusteredMarkersWithPopupsPage> createState() =>
      _NormalAndClusteredMarkersWithPopupsPageState();
}

class _NormalAndClusteredMarkersWithPopupsPageState
    extends State<NormalAndClusteredMarkersWithPopupsPage> {
  late final SuperclusterImmutableController _superclusterController;
  late final PopupController _popupController;

  static const points = [
    LatLng(51.5, 0),
    LatLng(51.0, 0.5),
  ];
  late List<Marker> markersA;
  late List<Marker> markersB;

  @override
  void initState() {
    super.initState();

    _superclusterController = SuperclusterImmutableController();
    _popupController = PopupController();
    markersA =
        points.map((point) => _createMarker(point, Colors.green)).toList();
    markersB = points
        .map((e) => LatLng(e.latitude - 2, e.longitude + 2))
        .map((point) => _createMarker(point, Colors.blue))
        .toList();
  }

  Marker _createMarker(LatLng point, Color color) => Marker(
        alignment: Alignment.topCenter,
        height: 30,
        width: 30,
        point: point,
        rotate: true,
        child: Icon(Icons.pin_drop, color: color),
      );

  @override
  void dispose() {
    _superclusterController.dispose();
    _popupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Normal and Clustered Markers With Popups')),
      drawer:
          buildDrawer(context, NormalAndClusteredMarkersWithPopupsPage.route),
      body: PopupScope(
        popupController: _popupController,
        onPopupEvent: (event, selectedMarkers) => debugPrint(
          '$event: selected: $selectedMarkers',
        ),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: points[0],
            initialZoom: 5,
            maxZoom: 15,
            onTap: (_, __) {
              _popupController.hideAllPopups();
            },
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: tileLayerPackageName,
            ),
            SuperclusterLayer.immutable(
              initialMarkers: markersA,
              indexBuilder: IndexBuilders.rootIsolate,
              controller: _superclusterController,
              clusterWidgetSize: const Size(40, 40),
              clusterAlignment: Alignment.center,
              popupOptions: PopupOptions(
                selectedMarkerBuilder: (context, marker) => Icon(
                  Icons.pin_drop,
                  color: Colors.green.shade900,
                ),
              ),
              calculateAggregatedClusterData: true,
              builder: (context, position, markerCount, extraClusterData) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      markerCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            PopupMarkerLayer(
              options: PopupMarkerLayerOptions(
                markers: markersB,
                selectedMarkerBuilder: (context, marker) => Icon(
                  Icons.pin_drop,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            PopupLayer(
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) => Container(
                  color: Colors.white,
                  child: Text(
                    marker.point.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
