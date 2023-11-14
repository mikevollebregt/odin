import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/google_maps_table.dart';

part 'google_maps_data_dao.g.dart';

@DriftAccessor(tables: [GoogleMapsDatas])
class GoogleMapsDataDao extends DatabaseAccessor<Database> with _$GoogleMapsDataDaoMixin {
  GoogleMapsDataDao(Database db) : super(db);

  Future<List<GoogleMapsData>> getUnsycnedGoogleMapsDatas() async => (select(googleMapsDatas)..where((c) => c.synced.equals(false))).get();

  Future<void> setSynced(GoogleMapsData googleMapsData) async => await update(googleMapsDatas).replace(googleMapsData.copyWith(synced: Value(true)));
}
