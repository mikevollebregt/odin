import 'package:desktop/infastructure/repositories/database/tables/algo_state_table.dart';
import 'package:drift/drift.dart';

import '../../database.dart';

part 'algo_state_dao.g.dart';

@DriftAccessor(tables: [AlgoStates])
class AlgoStatesDao extends DatabaseAccessor<Database>
    with _$AlgoStatesDaoMixin {
  AlgoStatesDao(Database db) : super(db);

  Future<AlgoState?> getAsync() => (select(algoStates).getSingleOrNull());

  Stream<List<AlgoState>> watchAllAlgoStates() => select(algoStates).watch();
  Future<int> insertPotentialStateAsync(AlgoState algoState) =>
      into(algoStates).insert(algoState);
  Future updatePotentialStateAsync(AlgoState algoState) =>
      update(algoStates).replace(algoState);
  Future deletePotentialStateAsync(AlgoState algoState) =>
      delete(algoStates).delete(algoState);
}
