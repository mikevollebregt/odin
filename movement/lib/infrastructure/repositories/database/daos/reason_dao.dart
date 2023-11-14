import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/reason_table.dart';

part 'reason_dao.g.dart';

@DriftAccessor(tables: [Reasons])
class ReasonDao extends DatabaseAccessor<Database> with _$ReasonDaoMixin {
  ReasonDao(Database db) : super(db);

  Future<List<Reason>> getReasons() => select(reasons).get();

  Future<int> insertReason(Reason reason) => into(reasons).insert(reason);
}
