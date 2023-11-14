import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/movement_table.dart';
import '../tables/stop_table.dart';

part 'classified_period_dao.g.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Movements, Stops])
class ClassifiedPeriodDao extends DatabaseAccessor<Database> with _$ClassifiedPeriodDaoMixin {
  ClassifiedPeriodDao(Database db) : super(db);

  Future<List<ClassifiedPeriod>> getClassifiedPeriods() async {
    return (select(classifiedPeriods)
          ..where((c) => c.deletedOn.isNull())
          ..orderBy([
            (c) => OrderingTerm(expression: c.startDate),
          ]))
        .get();
  }

  Future<ClassifiedPeriod?> getLastClassifiedPeriod() async {
    final classifiedPeriods = await getClassifiedPeriods();
    return classifiedPeriods.isEmpty ? null : classifiedPeriods.last;
  }

  Future<bool> isStop(ClassifiedPeriod classifiedPeriod) async {
    return (await (select(classifiedPeriods).join([
          innerJoin(stops, stops.classifiedPeriodId.equalsExp(classifiedPeriods.id)),
        ])
              ..where(classifiedPeriods.id.equals(classifiedPeriod.id)))
            .map((row) => true)
            .getSingleOrNull()) ??
        false;
  }

  Future<void> addStop(int? trackedDayId, SensorGeolocation sensorGeolocation) async {
    final classifiedPeriodId = await _addClassifiedPeriod(trackedDayId, sensorGeolocation);
    await into(stops).insert(StopsCompanion.insert(classifiedPeriodId: classifiedPeriodId));
  }

  Future<void> addMovement(int? trackedDayId, SensorGeolocation sensorGeolocation) async {
    final classifiedPeriodId = await _addClassifiedPeriod(trackedDayId, sensorGeolocation);
    await into(movements).insert(MovementsCompanion.insert(classifiedPeriodId: classifiedPeriodId));
  }

  Future<int> _addClassifiedPeriod(int? trackedDayId, SensorGeolocation sensorGeolocation) async {
    return into(classifiedPeriods).insert(
      ClassifiedPeriodsCompanion.insert(
          trackedDayId: Value(trackedDayId),
          startDate: sensorGeolocation.createdOn,
          endDate: sensorGeolocation.createdOn,
          createdOn: DateTime.now(),
          type: 0,
          userId: 0),
    );
  }

  Future<void> replaceClassifiedPeriod(ClassifiedPeriod classifiedPeriod) async {
    await update(classifiedPeriods).replace(classifiedPeriod);
  }

  Future<List<ClassifiedPeriod>> getClassifiedPeriodsOnDay(DateTime dateTime) async {
    return (select(classifiedPeriods)
          ..where((c) => c.deletedOn.isNull())
          ..where((c) => c.startDate.year.equals(dateTime.year))
          ..where((c) => c.startDate.month.equals(dateTime.month))
          ..where((c) => c.startDate.day.equals(dateTime.day))
          ..where((c) => c.deletedOn.isNull()))
        .get();
  }
}
