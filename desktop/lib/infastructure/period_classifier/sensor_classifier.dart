import '../repositories/dtos/sensor_geolocation_dto.dart';

class SensorClassifier {
  SensorClassifier();

  List<SensorGeolocationDTO> getBestSensor(List<List<SensorGeolocationDTO>> list) {
    var firstDateInList = DateTime.fromMillisecondsSinceEpoch(list[0][0].createdOn);
    var days = List<List<int>>.empty(growable: true);
    var actualCounters = List<int>.empty(growable: true);
    var highest = 0;
    var index = 0;

    for (var i = 0; i < list.length; i++) {
      var date = DateTime(firstDateInList.year, firstDateInList.month, firstDateInList.day, 0);
      var counter = List<int>.empty(growable: true);
      var actualCount = 0;

      for (var h = 1; h <= 24; h++) {
        var itemsInHour = list[i]
            .where((element) => element.createdOn >= date.millisecondsSinceEpoch && element.createdOn <= date.millisecondsSinceEpoch + (3600 * 1000))
            .toList();

        counter.add(itemsInHour.length);
        date = date.add(const Duration(hours: 1));

        if (itemsInHour.length > 40) {
          actualCount++;
        }
      }

      actualCounters.add(actualCount);

      if (actualCount > highest) {
        highest = actualCount;
        index = i;
      }

      days.add(counter);
    }

    return list[index];
  }
}
