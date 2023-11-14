import 'package:drift/drift.dart';
import 'package:movement/presentation/widgets/date_picker_widget/util/date_extensions.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/movement_table.dart';
import '../tables/stop_table.dart';

part 'classified_period_dao.g.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Movements, Stops])
class ClassifiedPeriodDao extends DatabaseAccessor<Database> with _$ClassifiedPeriodDaoMixin {
  ClassifiedPeriodDao(Database db) : super(db);

  Future<List<ClassifiedPeriod>> getUnsyncedClassifiedPeriods() async => (select(classifiedPeriods)..where((c) => c.synced.equals(false))).get();

  Future<List<ClassifiedPeriod>> getClassifiedPeriods() async {
    return (select(classifiedPeriods)
          ..where((c) => c.deletedOn.isNull())
          ..orderBy([
            (c) => OrderingTerm(expression: c.startDate),
          ]))
        .get();
  }

  Future<ClassifiedPeriod?> getLastClassifiedPeriod() async {
    return (select(classifiedPeriods)
          ..where((c) => c.deletedOn.isNull())
          ..orderBy([
            (c) => OrderingTerm(expression: c.startDate, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<bool> isStop(ClassifiedPeriod classifiedPeriod) async {
    return (await (select(classifiedPeriods).join([
          innerJoin(stops, stops.classifiedPeriodUuid.equalsExp(classifiedPeriods.uuid)),
        ])
              ..where(classifiedPeriods.uuid.equals(classifiedPeriod.uuid)))
            .map((row) => true)
            .getSingleOrNull()) ??
        false;
  }

  Future<void> removeClassifiedPeriods(List<ClassifiedPeriod> classifiedPeriodList) async {
    final deletedOn = DateTime.now();
    await batch((batch) {
      batch.replaceAll(
        classifiedPeriods,
        classifiedPeriodList.map(
          (c) => c.copyWith(deletedOn: Value(deletedOn), synced: Value(false)),
        ),
      );
    });
  }

  Future<List<ClassifiedPeriod>> getClassifiedPeriodsByIds(List<String> classifiedPeriodIdsList) async {
    final periods = <ClassifiedPeriod>[];

    for (var id in classifiedPeriodIdsList) {
      var period = await (select(classifiedPeriods)..where((s) => s.uuid.equals(id))).getSingle();
      periods.add(period);
    }

    return periods;
  }

  Future<void> addStop(String? trackedDayUuid, SensorGeolocation sensorGeolocation) async {
    final classifiedPeriodUuid = await _addClassifiedPeriod(trackedDayUuid, sensorGeolocation);
    await into(stops).insert(StopsCompanion.insert(classifiedPeriodUuid: classifiedPeriodUuid));
  }

  Future<void> addMovement(String? trackedDayUuid, SensorGeolocation sensorGeolocation) async {
    final classifiedPeriodUuid = await _addClassifiedPeriod(trackedDayUuid, sensorGeolocation);
    await into(movements).insert(MovementsCompanion.insert(classifiedPeriodUuid: classifiedPeriodUuid));
  }

  Future<String> _addClassifiedPeriod(String? trackedDayUuid, SensorGeolocation sensorGeolocation) async {
    return (await into(classifiedPeriods).insertReturning(
      ClassifiedPeriodsCompanion.insert(
        uuid: Value(Uuid().v4()),
        origin: Value('classifier_insert'),
        trackedDayUuid: Value(trackedDayUuid),
        startDate: sensorGeolocation.createdOn,
        endDate: sensorGeolocation.createdOn,
        createdOn: DateTime.now(),
        synced: Value(false),
      ),
    ))
        .uuid;
  }

  Future<void> replaceClassifiedPeriod(ClassifiedPeriod classifiedPeriod) async => await update(classifiedPeriods).replace(classifiedPeriod);

  Future<List<ClassifiedPeriod>> getClassifiedPeriodsOnDay(DateTime dateTime) async {
    return (select(classifiedPeriods)
          ..where((c) =>
              (c.startDate.isBiggerOrEqual(Variable(dateTime.startOfDay())) & c.startDate.isSmallerOrEqual(Variable(dateTime.endOfDay()))) |
              (c.endDate.isBiggerOrEqual(Variable(dateTime.startOfDay())) & c.endDate.isSmallerOrEqual(Variable(dateTime.endOfDay()))) |
              (c.startDate.isSmallerThan(Variable(dateTime.startOfDay())) & c.endDate.isBiggerThan(Variable(dateTime.endOfDay()))))
          ..where((c) => c.deletedOn.isNull()))
        .get();
  }

  Stream<List<ClassifiedPeriod>> streamClassifiedPeriodsOnDay(DateTime dateTime) async* {
    yield* (select(classifiedPeriods)
          ..where((c) =>
              (c.startDate.isBiggerOrEqual(Variable(dateTime.startOfDay())) & c.startDate.isSmallerOrEqual(Variable(dateTime.endOfDay()))) |
              (c.endDate.isBiggerOrEqual(Variable(dateTime.startOfDay())) & c.endDate.isSmallerOrEqual(Variable(dateTime.endOfDay()))) |
              (c.startDate.isSmallerThan(Variable(dateTime.startOfDay())) & c.endDate.isBiggerThan(Variable(dateTime.endOfDay()))))
          ..where((c) => c.deletedOn.isNull()))
        .watch();
  }
}
