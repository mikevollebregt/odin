import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';

import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/manual_geolocation_table.dart';

part 'manual_geolocation_dao.g.dart';

@DriftAccessor(tables: [ManualGeolocations, ClassifiedPeriods])
class ManualGeolocationDao extends DatabaseAccessor<Database> with _$ManualGeolocationDaoMixin {
  ManualGeolocationDao(Database db) : super(db);

  Future<int> insertManualGeolocation(ManualGeolocation manualGeolocation) async => into(manualGeolocations).insert(manualGeolocation);

  Future<LatLng?> getReferenceLatLng(DateTime referenceDateMin, DateTime referenceDateMax) async {
    //TODO: should we convert referenceDateMin and referenceDateMax to utc?
    return (select(manualGeolocations).join([
      innerJoin(classifiedPeriods, classifiedPeriods.id.equalsExp(manualGeolocations.classifiedPeriodId)),
    ])
          ..where(manualGeolocations.deletedOn.isNull())
          ..where(classifiedPeriods.endDate.isSmallerOrEqual(Variable.withDateTime(referenceDateMin)))
          ..where(classifiedPeriods.startDate.isBiggerOrEqual(Variable.withDateTime(referenceDateMax)))
          ..orderBy([OrderingTerm(expression: manualGeolocations.id, mode: OrderingMode.desc)])
          ..limit(1))
        .map((row) => LatLng(
              row.readTable(manualGeolocations).latitude,
              row.readTable(manualGeolocations).longitude,
            ))
        .getSingleOrNull();
  }
}
