import 'package:drift/drift.dart';
import '../../database.dart';
import '../../tables/token_table.dart';

part 'token_dao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Tokens])
class TokensDao extends DatabaseAccessor<Database> with _$TokensDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  TokensDao(Database db) : super(db);

  Future<Token?> getTokenAsync() => (select(tokens)..limit(1)).getSingleOrNull();
  Future<List<Token>> getTokensAsync() => select(tokens).get();
  Stream<List<Token>> watchAllTokensAsync() => select(tokens).watch();
  Future insertTokenAsync(Token token) => into(tokens).insert(token);
  Future updateTokenAsync(Token token) => update(tokens).replace(token);
  Future deleteTokenAsync(Token token) => delete(tokens).delete(token);
  Future clean() => delete(tokens).go();
}
