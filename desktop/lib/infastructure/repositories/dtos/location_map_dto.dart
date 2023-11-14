import 'package:flutter_map/flutter_map.dart';

class LocationMapDTO {
  List<Marker> markers;
  late List<Polyline> polylines;

  LocationMapDTO(this.markers, this.polylines);
}
