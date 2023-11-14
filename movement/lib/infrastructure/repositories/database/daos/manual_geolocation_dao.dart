import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:movement/infrastructure/repositories/dtos/reference_latlng_dto.dart';

import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/manual_geolocation_table.dart';

part 'manual_geolocation_dao.g.dart';

@DriftAccessor(tables: [ManualGeolocations, ClassifiedPeriods])
class ManualGeolocationDao extends DatabaseAccessor<Database> with _$ManualGeolocationDaoMixin {
  ManualGeolocationDao(Database db) : super(db);

  Future<int> insertManualGeolocation(ManualGeolocation manualGeolocation) async => into(manualGeolocations).insert(manualGeolocation);

  Future<ReferenceLatLngDto?> getReferenceLatLng(DateTime referenceDateMin, DateTime referenceDateMax) async {
    return (select(manualGeolocations).join([
      innerJoin(classifiedPeriods, classifiedPeriods.uuid.equalsExp(manualGeolocations.classifiedPeriodUuid)),
    ])
          ..where(manualGeolocations.deletedOn.isNull())
          ..where(classifiedPeriods.endDate.isSmallerOrEqual(Variable.withDateTime(referenceDateMin)))
          ..where(classifiedPeriods.startDate.isBiggerOrEqual(Variable.withDateTime(referenceDateMax)))
          ..orderBy([OrderingTerm(expression: manualGeolocations.uuid, mode: OrderingMode.desc)])
          ..limit(1))
        .map((row) => ReferenceLatLngDto(
              LatLng(
                row.readTable(manualGeolocations).latitude,
                row.readTable(manualGeolocations).longitude,
              ),
              row.readTable(manualGeolocations).createdOn,
            ))
        .getSingleOrNull();
  }

  Future<List<ManualGeolocation>> getUnsycnedManualGeolocations() async => (select(manualGeolocations)..where((c) => c.synced.equals(false))).get();

  Future<void> setSynced(ManualGeolocation manualGeolocation) async => await update(manualGeolocations).replace(manualGeolocation.copyWith(synced: Value(true)));
}
