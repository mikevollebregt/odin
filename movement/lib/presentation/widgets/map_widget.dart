import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../infrastructure/notifiers/responsive_ui.dart';
import '../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../providers.dart';
import '../theme/icon_mapper.dart';

LatLng? _cachedCurrentLocation;

class MapWidget extends ConsumerStatefulWidget {
  final List<StopDto> stopDtos;
  final List<MovementDto> movementDtos;
  const MapWidget(this.stopDtos, this.movementDtos);

  @override
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  final mapController = MapController();
  var markers = <Marker>[];
  var points = <LatLng>[];
  var bounds = LatLngBounds();
  var isDisposed = false;

  Marker _getMarker(LatLng latLng, String? icon) {
    return Marker(
      width: 40 * x,
      height: 40 * y,
      point: latLng,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: FaIconMapper.getFaIcon(icon),
      ),
    );
  }


  // TODO: code below needs to be refactored
  var smoothPoints = <LatLng>[];

  double medianOf3(List<double> l) {
    l.sort();
    return l[1];
  }

  List<LatLng> saveEqualize(List<LatLng> unsmooth) {
    try {
      return Path.from(unsmooth).equalize(30, smoothPath: true).coordinates;
    } catch (e) {
      return unsmooth;
    }
  }

  void smoothing() {
    final medianFilteredPoints = <LatLng>[];
    if (points.length > 7) {
      for (int i = 0; i < points.length; i++) {
        if (points.asMap().containsKey(i - 1) && points.asMap().containsKey(i + 1)) {
          final medianLatitude = medianOf3([points[i - 1].latitude, points[i].latitude, points[i + 1].latitude]);
          final medianLongitude = medianOf3([points[i - 1].longitude, points[i].longitude, points[i + 1].longitude]);
          medianFilteredPoints.add(LatLng(medianLatitude, medianLongitude));
        }
      }
      smoothPoints = saveEqualize(medianFilteredPoints);
    } else {
      smoothPoints =  saveEqualize(points);;
    }
  }
  ////////////////////////////////////////////////////////////////

  void setupMap() {
    markers = [];
    points = [];
    bounds = LatLngBounds();
    for (final stopDto in widget.stopDtos) {
      if (stopDto.centroid != null) {
        markers.add(_getMarker(stopDto.centroid!, stopDto.reason?.icon));
        bounds.extend(stopDto.centroid!);
      }
    }
    for (final movementDto in widget.movementDtos) {
      movementDto.route.forEach(points.add);
      movementDto.route.forEach(bounds.extend);
      smoothing();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bounds.isValid) {
        mapController.fitBounds(bounds);
        mapController.move(bounds.center, min(mapController.zoom, 15));
      } else {
        handleEmptyDtos();
      }
    });
  }

  Future<void> handleEmptyDtos() async {
    final currentLatLong = await ref.read(deviceServiceProvider).getCurrentLocationAsync();
    if (currentLatLong != null && currentLatLong.isNotEmpty) {
      await mapController.onReady;
      await Future.delayed(const Duration(seconds: 1), () {}); // Redrawing the map too quickly may result in showing a grey screen for a long time.
      _cachedCurrentLocation = LatLng(currentLatLong[0], currentLatLong[1]);
      if (!isDisposed) {
        bounds.extend(_cachedCurrentLocation);
        mapController.fitBounds(bounds);
        mapController.move(bounds.center, 12);
      }
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setupMap();
    isDisposed = false;
    return SizedBox(
      height: 200 * y,
      width: MediaQuery.of(context).size.width,
      child: FlutterMap(
        mapController: mapController,
        layers: [
          TileLayerOptions(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: markers),
          PolylineLayerOptions(
            polylines: [
              Polyline(
                strokeWidth: 5 * f,
                color: const Color(0xFF00589C),
                borderStrokeWidth: 2 * f,
                borderColor: const Color(0xFF073C6A),
                points: smoothPoints,
              ),
            ],
          ),
        ],
        options: MapOptions(
          center: _cachedCurrentLocation ?? LatLng(52.0660149, 4.3987896),
          zoom: _cachedCurrentLocation == null ? 5 : 12,
        ),
      ),
    );
  }
}
