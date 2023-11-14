import 'dart:math';

import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/location_dto.dart';

class IsMovingClassifier {
  LocationDTO classifyIfLocationIsMoving(
      List<Location> locations, LocationDTO locationDTO) {
    var minDistance = 0.1;
    var minTime = 5 * 60 * 1000;

    if (locations.isEmpty) {
      locationDTO.isMoving = false;
      return locationDTO;
    }

    //previous records weren't moving
    if (!locations.last.isMoving!) {
      //get the median of the not moved locations and get check distance with that one
      var distanceList = <double>[];
      for (var i = 0; i < locations.length; i++) {
        var distance = _calculateDistance(locations[i].lat, locations[i].lon,
            locationDTO.lat, locationDTO.lon);
        distanceList.add(distance);
      }

      var mediumDistance = getMedian(distanceList);
      if (mediumDistance < 0.1) {
        locationDTO.isMoving = true;
      } else {
        locationDTO.isMoving = false;
      }
    }

    //previous records were moving
    if (locations.last.isMoving!) {
      //var minTime = 5 * 60 * 1000;
      var distanceList = <double>[];

      if (locations.length <= 4) {
        locationDTO.isMoving = true;
        return locationDTO;
      }

      for (var i = locations.length - 4; i < locations.length; i++) {
        var distance = _calculateDistance(locations[i].lat, locations[i].lon,
            locationDTO.lat, locationDTO.lon);
        distanceList.add(distance);

        var mediumDistance = getMedian(distanceList);

        if (mediumDistance < 0.1) {
          locationDTO.isMoving = true;
        } else {
          locationDTO.isMoving = false;
        }
      }
    }

    return locationDTO;
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }

  double getMedian(List<double> list) {
    list.sort((a, b) => a.compareTo(b));

    double median;

    int middle = list.length ~/ 2;
    if (list.length % 2 == 1) {
      median = list[middle];
    } else {
      median = ((list[middle - 1]) + (list[middle]) / 2);
    }

    return median;
  }
}
