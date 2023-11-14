// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class TrackedDay extends DataClass implements Insertable<TrackedDay> {
  final int id;
  final DateTime date;
  final bool confirmed;
  final int? choiceId;
  final String? choiceText;
  TrackedDay(
      {required this.id,
      required this.date,
      required this.confirmed,
      this.choiceId,
      this.choiceText});
  factory TrackedDay.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TrackedDay(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      confirmed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}confirmed'])!,
      choiceId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}choice_id']),
      choiceText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}choice_text']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['confirmed'] = Variable<bool>(confirmed);
    if (!nullToAbsent || choiceId != null) {
      map['choice_id'] = Variable<int?>(choiceId);
    }
    if (!nullToAbsent || choiceText != null) {
      map['choice_text'] = Variable<String?>(choiceText);
    }
    return map;
  }

  TrackedDaysCompanion toCompanion(bool nullToAbsent) {
    return TrackedDaysCompanion(
      id: Value(id),
      date: Value(date),
      confirmed: Value(confirmed),
      choiceId: choiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(choiceId),
      choiceText: choiceText == null && nullToAbsent
          ? const Value.absent()
          : Value(choiceText),
    );
  }

  factory TrackedDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedDay(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      choiceId: serializer.fromJson<int?>(json['choiceId']),
      choiceText: serializer.fromJson<String?>(json['choiceText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'confirmed': serializer.toJson<bool>(confirmed),
      'choiceId': serializer.toJson<int?>(choiceId),
      'choiceText': serializer.toJson<String?>(choiceText),
    };
  }

  TrackedDay copyWith(
          {int? id,
          DateTime? date,
          bool? confirmed,
          int? choiceId,
          String? choiceText}) =>
      TrackedDay(
        id: id ?? this.id,
        date: date ?? this.date,
        confirmed: confirmed ?? this.confirmed,
        choiceId: choiceId ?? this.choiceId,
        choiceText: choiceText ?? this.choiceText,
      );
  @override
  String toString() {
    return (StringBuffer('TrackedDay(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('confirmed: $confirmed, ')
          ..write('choiceId: $choiceId, ')
          ..write('choiceText: $choiceText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, confirmed, choiceId, choiceText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedDay &&
          other.id == this.id &&
          other.date == this.date &&
          other.confirmed == this.confirmed &&
          other.choiceId == this.choiceId &&
          other.choiceText == this.choiceText);
}

class TrackedDaysCompanion extends UpdateCompanion<TrackedDay> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<bool> confirmed;
  final Value<int?> choiceId;
  final Value<String?> choiceText;
  const TrackedDaysCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.choiceId = const Value.absent(),
    this.choiceText = const Value.absent(),
  });
  TrackedDaysCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.confirmed = const Value.absent(),
    this.choiceId = const Value.absent(),
    this.choiceText = const Value.absent(),
  }) : date = Value(date);
  static Insertable<TrackedDay> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<bool>? confirmed,
    Expression<int?>? choiceId,
    Expression<String?>? choiceText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (confirmed != null) 'confirmed': confirmed,
      if (choiceId != null) 'choice_id': choiceId,
      if (choiceText != null) 'choice_text': choiceText,
    });
  }

  TrackedDaysCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<bool>? confirmed,
      Value<int?>? choiceId,
      Value<String?>? choiceText}) {
    return TrackedDaysCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      confirmed: confirmed ?? this.confirmed,
      choiceId: choiceId ?? this.choiceId,
      choiceText: choiceText ?? this.choiceText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (choiceId.present) {
      map['choice_id'] = Variable<int?>(choiceId.value);
    }
    if (choiceText.present) {
      map['choice_text'] = Variable<String?>(choiceText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedDaysCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('confirmed: $confirmed, ')
          ..write('choiceId: $choiceId, ')
          ..write('choiceText: $choiceText')
          ..write(')'))
        .toString();
  }
}

class $TrackedDaysTable extends TrackedDays
    with TableInfo<$TrackedDaysTable, TrackedDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedDaysTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _confirmedMeta = const VerificationMeta('confirmed');
  @override
  late final GeneratedColumn<bool?> confirmed = GeneratedColumn<bool?>(
      'confirmed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (confirmed IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _choiceIdMeta = const VerificationMeta('choiceId');
  @override
  late final GeneratedColumn<int?> choiceId = GeneratedColumn<int?>(
      'choice_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _choiceTextMeta = const VerificationMeta('choiceText');
  @override
  late final GeneratedColumn<String?> choiceText = GeneratedColumn<String?>(
      'choice_text', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, confirmed, choiceId, choiceText];
  @override
  String get aliasedName => _alias ?? 'tracked_days';
  @override
  String get actualTableName => 'tracked_days';
  @override
  VerificationContext validateIntegrity(Insertable<TrackedDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(_confirmedMeta,
          confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta));
    }
    if (data.containsKey('choice_id')) {
      context.handle(_choiceIdMeta,
          choiceId.isAcceptableOrUnknown(data['choice_id']!, _choiceIdMeta));
    }
    if (data.containsKey('choice_text')) {
      context.handle(
          _choiceTextMeta,
          choiceText.isAcceptableOrUnknown(
              data['choice_text']!, _choiceTextMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TrackedDay.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TrackedDaysTable createAlias(String alias) {
    return $TrackedDaysTable(attachedDatabase, alias);
  }
}

class ClassifiedPeriod extends DataClass
    implements Insertable<ClassifiedPeriod> {
  final int? id;
  final int? trackedDayId;
  final int type;
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final bool confirmed;
  final DateTime createdOn;
  final DateTime? deletedOn;
  final bool synced;
  ClassifiedPeriod(
      {this.id,
      this.trackedDayId,
      required this.type,
      required this.userId,
      required this.startDate,
      required this.endDate,
      required this.confirmed,
      required this.createdOn,
      this.deletedOn,
      required this.synced});
  factory ClassifiedPeriod.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ClassifiedPeriod(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      trackedDayId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tracked_day_id']),
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      userId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      startDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_date'])!,
      endDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}end_date'])!,
      confirmed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}confirmed'])!,
      createdOn: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_on'])!,
      deletedOn: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_on']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    if (!nullToAbsent || trackedDayId != null) {
      map['tracked_day_id'] = Variable<int?>(trackedDayId);
    }
    map['type'] = Variable<int>(type);
    map['user_id'] = Variable<int>(userId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['confirmed'] = Variable<bool>(confirmed);
    map['created_on'] = Variable<DateTime>(createdOn);
    if (!nullToAbsent || deletedOn != null) {
      map['deleted_on'] = Variable<DateTime?>(deletedOn);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ClassifiedPeriodsCompanion toCompanion(bool nullToAbsent) {
    return ClassifiedPeriodsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      trackedDayId: trackedDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(trackedDayId),
      type: Value(type),
      userId: Value(userId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      confirmed: Value(confirmed),
      createdOn: Value(createdOn),
      deletedOn: deletedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedOn),
      synced: Value(synced),
    );
  }

  factory ClassifiedPeriod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassifiedPeriod(
      id: serializer.fromJson<int?>(json['id']),
      trackedDayId: serializer.fromJson<int?>(json['trackedDayId']),
      type: serializer.fromJson<int>(json['type']),
      userId: serializer.fromJson<int>(json['userId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      createdOn: serializer.fromJson<DateTime>(json['createdOn']),
      deletedOn: serializer.fromJson<DateTime?>(json['deletedOn']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'trackedDayId': serializer.toJson<int?>(trackedDayId),
      'type': serializer.toJson<int>(type),
      'userId': serializer.toJson<int>(userId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'confirmed': serializer.toJson<bool>(confirmed),
      'createdOn': serializer.toJson<DateTime>(createdOn),
      'deletedOn': serializer.toJson<DateTime?>(deletedOn),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ClassifiedPeriod copyWith(
          {int? id,
          int? trackedDayId,
          int? type,
          int? userId,
          DateTime? startDate,
          DateTime? endDate,
          bool? confirmed,
          DateTime? createdOn,
          DateTime? deletedOn,
          bool? synced}) =>
      ClassifiedPeriod(
        id: id ?? this.id,
        trackedDayId: trackedDayId ?? this.trackedDayId,
        type: type ?? this.type,
        userId: userId ?? this.userId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        confirmed: confirmed ?? this.confirmed,
        createdOn: createdOn ?? this.createdOn,
        deletedOn: deletedOn ?? this.deletedOn,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('ClassifiedPeriod(')
          ..write('id: $id, ')
          ..write('trackedDayId: $trackedDayId, ')
          ..write('type: $type, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('confirmed: $confirmed, ')
          ..write('createdOn: $createdOn, ')
          ..write('deletedOn: $deletedOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackedDayId, type, userId, startDate,
      endDate, confirmed, createdOn, deletedOn, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassifiedPeriod &&
          other.id == this.id &&
          other.trackedDayId == this.trackedDayId &&
          other.type == this.type &&
          other.userId == this.userId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.confirmed == this.confirmed &&
          other.createdOn == this.createdOn &&
          other.deletedOn == this.deletedOn &&
          other.synced == this.synced);
}

class ClassifiedPeriodsCompanion extends UpdateCompanion<ClassifiedPeriod> {
  final Value<int?> id;
  final Value<int?> trackedDayId;
  final Value<int> type;
  final Value<int> userId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<bool> confirmed;
  final Value<DateTime> createdOn;
  final Value<DateTime?> deletedOn;
  final Value<bool> synced;
  const ClassifiedPeriodsCompanion({
    this.id = const Value.absent(),
    this.trackedDayId = const Value.absent(),
    this.type = const Value.absent(),
    this.userId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.deletedOn = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ClassifiedPeriodsCompanion.insert({
    this.id = const Value.absent(),
    this.trackedDayId = const Value.absent(),
    required int type,
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
    this.confirmed = const Value.absent(),
    required DateTime createdOn,
    this.deletedOn = const Value.absent(),
    this.synced = const Value.absent(),
  })  : type = Value(type),
        userId = Value(userId),
        startDate = Value(startDate),
        endDate = Value(endDate),
        createdOn = Value(createdOn);
  static Insertable<ClassifiedPeriod> custom({
    Expression<int?>? id,
    Expression<int?>? trackedDayId,
    Expression<int>? type,
    Expression<int>? userId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? confirmed,
    Expression<DateTime>? createdOn,
    Expression<DateTime?>? deletedOn,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackedDayId != null) 'tracked_day_id': trackedDayId,
      if (type != null) 'type': type,
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (confirmed != null) 'confirmed': confirmed,
      if (createdOn != null) 'created_on': createdOn,
      if (deletedOn != null) 'deleted_on': deletedOn,
      if (synced != null) 'synced': synced,
    });
  }

  ClassifiedPeriodsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? trackedDayId,
      Value<int>? type,
      Value<int>? userId,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<bool>? confirmed,
      Value<DateTime>? createdOn,
      Value<DateTime?>? deletedOn,
      Value<bool>? synced}) {
    return ClassifiedPeriodsCompanion(
      id: id ?? this.id,
      trackedDayId: trackedDayId ?? this.trackedDayId,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      confirmed: confirmed ?? this.confirmed,
      createdOn: createdOn ?? this.createdOn,
      deletedOn: deletedOn ?? this.deletedOn,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (trackedDayId.present) {
      map['tracked_day_id'] = Variable<int?>(trackedDayId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<DateTime>(createdOn.value);
    }
    if (deletedOn.present) {
      map['deleted_on'] = Variable<DateTime?>(deletedOn.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassifiedPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('trackedDayId: $trackedDayId, ')
          ..write('type: $type, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('confirmed: $confirmed, ')
          ..write('createdOn: $createdOn, ')
          ..write('deletedOn: $deletedOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $ClassifiedPeriodsTable extends ClassifiedPeriods
    with TableInfo<$ClassifiedPeriodsTable, ClassifiedPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassifiedPeriodsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _trackedDayIdMeta =
      const VerificationMeta('trackedDayId');
  @override
  late final GeneratedColumn<int?> trackedDayId = GeneratedColumn<int?>(
      'tracked_day_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES tracked_days (id)');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int?> userId = GeneratedColumn<int?>(
      'user_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime?> startDate = GeneratedColumn<DateTime?>(
      'start_date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime?> endDate = GeneratedColumn<DateTime?>(
      'end_date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _confirmedMeta = const VerificationMeta('confirmed');
  @override
  late final GeneratedColumn<bool?> confirmed = GeneratedColumn<bool?>(
      'confirmed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (confirmed IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _createdOnMeta = const VerificationMeta('createdOn');
  @override
  late final GeneratedColumn<DateTime?> createdOn = GeneratedColumn<DateTime?>(
      'created_on', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deletedOnMeta = const VerificationMeta('deletedOn');
  @override
  late final GeneratedColumn<DateTime?> deletedOn = GeneratedColumn<DateTime?>(
      'deleted_on', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        trackedDayId,
        type,
        userId,
        startDate,
        endDate,
        confirmed,
        createdOn,
        deletedOn,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'classified_periods';
  @override
  String get actualTableName => 'classified_periods';
  @override
  VerificationContext validateIntegrity(Insertable<ClassifiedPeriod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracked_day_id')) {
      context.handle(
          _trackedDayIdMeta,
          trackedDayId.isAcceptableOrUnknown(
              data['tracked_day_id']!, _trackedDayIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(_confirmedMeta,
          confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta));
    }
    if (data.containsKey('created_on')) {
      context.handle(_createdOnMeta,
          createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta));
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('deleted_on')) {
      context.handle(_deletedOnMeta,
          deletedOn.isAcceptableOrUnknown(data['deleted_on']!, _deletedOnMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassifiedPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ClassifiedPeriod.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ClassifiedPeriodsTable createAlias(String alias) {
    return $ClassifiedPeriodsTable(attachedDatabase, alias);
  }
}

class ManualGeolocation extends DataClass
    implements Insertable<ManualGeolocation> {
  final int? id;
  final int classifiedPeriodId;
  final double latitude;
  final double longitude;
  final DateTime createdOn;
  final DateTime? deletedOn;
  final bool synced;
  ManualGeolocation(
      {this.id,
      required this.classifiedPeriodId,
      required this.latitude,
      required this.longitude,
      required this.createdOn,
      this.deletedOn,
      required this.synced});
  factory ManualGeolocation.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ManualGeolocation(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      classifiedPeriodId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}classified_period_id'])!,
      latitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude'])!,
      longitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude'])!,
      createdOn: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_on'])!,
      deletedOn: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_on']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    map['classified_period_id'] = Variable<int>(classifiedPeriodId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['created_on'] = Variable<DateTime>(createdOn);
    if (!nullToAbsent || deletedOn != null) {
      map['deleted_on'] = Variable<DateTime?>(deletedOn);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ManualGeolocationsCompanion toCompanion(bool nullToAbsent) {
    return ManualGeolocationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      classifiedPeriodId: Value(classifiedPeriodId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      createdOn: Value(createdOn),
      deletedOn: deletedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedOn),
      synced: Value(synced),
    );
  }

  factory ManualGeolocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManualGeolocation(
      id: serializer.fromJson<int?>(json['id']),
      classifiedPeriodId: serializer.fromJson<int>(json['classifiedPeriodId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      createdOn: serializer.fromJson<DateTime>(json['createdOn']),
      deletedOn: serializer.fromJson<DateTime?>(json['deletedOn']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'classifiedPeriodId': serializer.toJson<int>(classifiedPeriodId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'createdOn': serializer.toJson<DateTime>(createdOn),
      'deletedOn': serializer.toJson<DateTime?>(deletedOn),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ManualGeolocation copyWith(
          {int? id,
          int? classifiedPeriodId,
          double? latitude,
          double? longitude,
          DateTime? createdOn,
          DateTime? deletedOn,
          bool? synced}) =>
      ManualGeolocation(
        id: id ?? this.id,
        classifiedPeriodId: classifiedPeriodId ?? this.classifiedPeriodId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        createdOn: createdOn ?? this.createdOn,
        deletedOn: deletedOn ?? this.deletedOn,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('ManualGeolocation(')
          ..write('id: $id, ')
          ..write('classifiedPeriodId: $classifiedPeriodId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdOn: $createdOn, ')
          ..write('deletedOn: $deletedOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, classifiedPeriodId, latitude, longitude,
      createdOn, deletedOn, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManualGeolocation &&
          other.id == this.id &&
          other.classifiedPeriodId == this.classifiedPeriodId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.createdOn == this.createdOn &&
          other.deletedOn == this.deletedOn &&
          other.synced == this.synced);
}

class ManualGeolocationsCompanion extends UpdateCompanion<ManualGeolocation> {
  final Value<int?> id;
  final Value<int> classifiedPeriodId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> createdOn;
  final Value<DateTime?> deletedOn;
  final Value<bool> synced;
  const ManualGeolocationsCompanion({
    this.id = const Value.absent(),
    this.classifiedPeriodId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.deletedOn = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ManualGeolocationsCompanion.insert({
    this.id = const Value.absent(),
    required int classifiedPeriodId,
    required double latitude,
    required double longitude,
    required DateTime createdOn,
    this.deletedOn = const Value.absent(),
    this.synced = const Value.absent(),
  })  : classifiedPeriodId = Value(classifiedPeriodId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        createdOn = Value(createdOn);
  static Insertable<ManualGeolocation> custom({
    Expression<int?>? id,
    Expression<int>? classifiedPeriodId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? createdOn,
    Expression<DateTime?>? deletedOn,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classifiedPeriodId != null)
        'classified_period_id': classifiedPeriodId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdOn != null) 'created_on': createdOn,
      if (deletedOn != null) 'deleted_on': deletedOn,
      if (synced != null) 'synced': synced,
    });
  }

  ManualGeolocationsCompanion copyWith(
      {Value<int?>? id,
      Value<int>? classifiedPeriodId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<DateTime>? createdOn,
      Value<DateTime?>? deletedOn,
      Value<bool>? synced}) {
    return ManualGeolocationsCompanion(
      id: id ?? this.id,
      classifiedPeriodId: classifiedPeriodId ?? this.classifiedPeriodId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdOn: createdOn ?? this.createdOn,
      deletedOn: deletedOn ?? this.deletedOn,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (classifiedPeriodId.present) {
      map['classified_period_id'] = Variable<int>(classifiedPeriodId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<DateTime>(createdOn.value);
    }
    if (deletedOn.present) {
      map['deleted_on'] = Variable<DateTime?>(deletedOn.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManualGeolocationsCompanion(')
          ..write('id: $id, ')
          ..write('classifiedPeriodId: $classifiedPeriodId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdOn: $createdOn, ')
          ..write('deletedOn: $deletedOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $ManualGeolocationsTable extends ManualGeolocations
    with TableInfo<$ManualGeolocationsTable, ManualGeolocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManualGeolocationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _classifiedPeriodIdMeta =
      const VerificationMeta('classifiedPeriodId');
  @override
  late final GeneratedColumn<int?> classifiedPeriodId = GeneratedColumn<int?>(
      'classified_period_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES classified_periods (id)');
  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double?> latitude = GeneratedColumn<double?>(
      'latitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double?> longitude = GeneratedColumn<double?>(
      'longitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _createdOnMeta = const VerificationMeta('createdOn');
  @override
  late final GeneratedColumn<DateTime?> createdOn = GeneratedColumn<DateTime?>(
      'created_on', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deletedOnMeta = const VerificationMeta('deletedOn');
  @override
  late final GeneratedColumn<DateTime?> deletedOn = GeneratedColumn<DateTime?>(
      'deleted_on', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        classifiedPeriodId,
        latitude,
        longitude,
        createdOn,
        deletedOn,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'manual_geolocations';
  @override
  String get actualTableName => 'manual_geolocations';
  @override
  VerificationContext validateIntegrity(Insertable<ManualGeolocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('classified_period_id')) {
      context.handle(
          _classifiedPeriodIdMeta,
          classifiedPeriodId.isAcceptableOrUnknown(
              data['classified_period_id']!, _classifiedPeriodIdMeta));
    } else if (isInserting) {
      context.missing(_classifiedPeriodIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('created_on')) {
      context.handle(_createdOnMeta,
          createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta));
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('deleted_on')) {
      context.handle(_deletedOnMeta,
          deletedOn.isAcceptableOrUnknown(data['deleted_on']!, _deletedOnMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManualGeolocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ManualGeolocation.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ManualGeolocationsTable createAlias(String alias) {
    return $ManualGeolocationsTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int? id;
  final String? name;
  final String? icon;
  final String? color;
  Vehicle({this.id, this.name, this.icon, this.color});
  factory Vehicle.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Vehicle(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      icon: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}icon']),
      color: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String?>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String?>(color);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int?>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'name': serializer.toJson<String?>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
    };
  }

  Vehicle copyWith({int? id, String? name, String? icon, String? color}) =>
      Vehicle(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int?> id;
  final Value<String?> name;
  final Value<String?> icon;
  final Value<String?> color;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  static Insertable<Vehicle> custom({
    Expression<int?>? id,
    Expression<String?>? name,
    Expression<String?>? icon,
    Expression<String?>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
    });
  }

  VehiclesCompanion copyWith(
      {Value<int?>? id,
      Value<String?>? name,
      Value<String?>? icon,
      Value<String?>? color}) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String?>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String?>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String?> icon = GeneratedColumn<String?>(
      'icon', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String?> color = GeneratedColumn<String?>(
      'color', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, color];
  @override
  String get aliasedName => _alias ?? 'vehicles';
  @override
  String get actualTableName => 'vehicles';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Vehicle.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Movement extends DataClass implements Insertable<Movement> {
  final int? id;
  final int classifiedPeriodId;
  final int? vehicleId;
  Movement({this.id, required this.classifiedPeriodId, this.vehicleId});
  factory Movement.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Movement(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      classifiedPeriodId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}classified_period_id'])!,
      vehicleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}vehicle_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    map['classified_period_id'] = Variable<int>(classifiedPeriodId);
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<int?>(vehicleId);
    }
    return map;
  }

  MovementsCompanion toCompanion(bool nullToAbsent) {
    return MovementsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      classifiedPeriodId: Value(classifiedPeriodId),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
    );
  }

  factory Movement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movement(
      id: serializer.fromJson<int?>(json['id']),
      classifiedPeriodId: serializer.fromJson<int>(json['classifiedPeriodId']),
      vehicleId: serializer.fromJson<int?>(json['vehicleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'classifiedPeriodId': serializer.toJson<int>(classifiedPeriodId),
      'vehicleId': serializer.toJson<int?>(vehicleId),
    };
  }

  Movement copyWith({int? id, int? classifiedPeriodId, int? vehicleId}) =>
      Movement(
        id: id ?? this.id,
        classifiedPeriodId: classifiedPeriodId ?? this.classifiedPeriodId,
        vehicleId: vehicleId ?? this.vehicleId,
      );
  @override
  String toString() {
    return (StringBuffer('Movement(')
          ..write('id: $id, ')
          ..write('classifiedPeriodId: $classifiedPeriodId, ')
          ..write('vehicleId: $vehicleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, classifiedPeriodId, vehicleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movement &&
          other.id == this.id &&
          other.classifiedPeriodId == this.classifiedPeriodId &&
          other.vehicleId == this.vehicleId);
}

class MovementsCompanion extends UpdateCompanion<Movement> {
  final Value<int?> id;
  final Value<int> classifiedPeriodId;
  final Value<int?> vehicleId;
  const MovementsCompanion({
    this.id = const Value.absent(),
    this.classifiedPeriodId = const Value.absent(),
    this.vehicleId = const Value.absent(),
  });
  MovementsCompanion.insert({
    this.id = const Value.absent(),
    required int classifiedPeriodId,
    this.vehicleId = const Value.absent(),
  }) : classifiedPeriodId = Value(classifiedPeriodId);
  static Insertable<Movement> custom({
    Expression<int?>? id,
    Expression<int>? classifiedPeriodId,
    Expression<int?>? vehicleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classifiedPeriodId != null)
        'classified_period_id': classifiedPeriodId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
    });
  }

  MovementsCompanion copyWith(
      {Value<int?>? id,
      Value<int>? classifiedPeriodId,
      Value<int?>? vehicleId}) {
    return MovementsCompanion(
      id: id ?? this.id,
      classifiedPeriodId: classifiedPeriodId ?? this.classifiedPeriodId,
      vehicleId: vehicleId ?? this.vehicleId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (classifiedPeriodId.present) {
      map['classified_period_id'] = Variable<int>(classifiedPeriodId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int?>(vehicleId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovementsCompanion(')
          ..write('id: $id, ')
          ..write('classifiedPeriodId: $classifiedPeriodId, ')
          ..write('vehicleId: $vehicleId')
          ..write(')'))
        .toString();
  }
}

class $MovementsTable extends Movements
    with TableInfo<$MovementsTable, Movement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovementsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _classifiedPeriodIdMeta =
      const VerificationMeta('classifiedPeriodId');
  @override
  late final GeneratedColumn<int?> classifiedPeriodId = GeneratedColumn<int?>(
      'classified_period_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES classified_periods (id)');
  final VerificationMeta _vehicleIdMeta = const VerificationMeta('vehicleId');
  @override
  late final GeneratedColumn<int?> vehicleId = GeneratedColumn<int?>(
      'vehicle_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES vehicles (id)');
  @override
  List<GeneratedColumn> get $columns => [id, classifiedPeriodId, vehicleId];
  @override
  String get aliasedName => _alias ?? 'movements';
  @override
  String get actualTableName => 'movements';
  @override
  VerificationContext validateIntegrity(Insertable<Movement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('classified_period_id')) {
      context.handle(
          _classifiedPeriodIdMeta,
          classifiedPeriodId.isAcceptableOrUnknown(
              data['classified_period_id']!, _classifiedPeriodIdMeta));
    } else if (isInserting) {
      context.missing(_classifiedPeriodIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(_vehicleIdMeta,
          vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movement map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Movement.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MovementsTable createAlias(String alias) {
    return $MovementsTable(attachedDatabase, alias);
  }
}

class Reason extends DataClass implements Insertable<Reason> {
  final int? id;
  final String? name;
  final String? icon;
  final String? color;
  Reason({this.id, this.name, this.icon, this.color});
  factory Reason.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Reason(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      icon: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}icon']),
      color: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String?>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String?>(color);
    }
    return map;
  }

  ReasonsCompanion toCompanion(bool nullToAbsent) {
    return ReasonsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Reason.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reason(
      id: serializer.fromJson<int?>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'name': serializer.toJson<String?>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
    };
  }

  Reason copyWith({int? id, String? name, String? icon, String? color}) =>
      Reason(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('Reason(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reason &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color);
}

class ReasonsCompanion extends UpdateCompanion<Reason> {
  final Value<int?> id;
  final Value<String?> name;
  final Value<String?> icon;
  final Value<String?> color;
  const ReasonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  ReasonsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  static Insertable<Reason> custom({
    Expression<int?>? id,
    Expression<String?>? name,
    Expression<String?>? icon,
    Expression<String?>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
    });
  }

  ReasonsCompanion copyWith(
      {Value<int?>? id,
      Value<String?>? name,
      Value<String?>? icon,
      Value<String?>? color}) {
    return ReasonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String?>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String?>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReasonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $ReasonsTable extends Reasons with TableInfo<$ReasonsTable, Reason> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReasonsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String?> icon = GeneratedColumn<String?>(
      'icon', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String?> color = GeneratedColumn<String?>(
      'color', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, color];
  @override
  String get aliasedName => _alias ?? 'reasons';
  @override
  String get actualTableName => 'reasons';
  @override
  VerificationContext validateIntegrity(Insertable<Reason> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reason map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Reason.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ReasonsTable createAlias(String alias) {
    return $ReasonsTable(attachedDatabase, alias);
  }
}

class SensorGeolocation extends DataClass
    implements Insertable<SensorGeolocation> {
  final int? id;
  final double latitude;
  final double longitude;
  final double altitude;
  final double bearing;
  final double accuracy;
  final double speed;
  final String sensorType;
  final String provider;
  final bool isNoise;
  final DateTime createdOn;
  final DateTime? deletedOn;
  final bool synced;
  SensorGeolocation(
      {this.id,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.bearing,
      required this.accuracy,
      required this.speed,
      required this.sensorType,
      required this.provider,
      required this.isNoise,
      required this.createdOn,
      this.deletedOn,
      required this.synced});
  factory SensorGeolocation.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return SensorGeolocation(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      latitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude'])!,
      longitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude'])!,
      altitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}altitude'])!,
      bearing: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bearing'])!,
      accuracy: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}accuracy'])!,
      speed: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}speed'])!,
      sensorType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sensor_type'])!,
      provider: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}provider'])!,
      isNoise: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_noise'])!,
      createdOn: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_on'])!,
      deletedOn: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_on']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['altitude'] = Variable<double>(altitude);
    map['bearing'] = Variable<double>(bearing);
    map['accuracy'] = Variable<double>(accuracy);
    map['speed'] = Variable<double>(speed);
    map['sensor_type'] = Variable<String>(sensorType);
    map['provider'] = Variable<String>(provider);
    map['is_noise'] = Variable<bool>(isNoise);
    map['created_on'] = Variable<DateTime>(createdOn);
    if (!nullToAbsent || deletedOn != null) {
      map['deleted_on'] = Variable<DateTime?>(deletedOn);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SensorGeolocationsCompanion toCompanion(bool nullToAbsent) {
    return SensorGeolocationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitude: Value(altitude),
      bearing: Value(bearing),
      accuracy: Value(accuracy),
      speed: Value(speed),
      sensorType: Value(sensorType),
      provider: Value(provider),
      isNoise: Value(isNoise),
      createdOn: Value(createdOn),
      deletedOn: deletedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedOn),
      synced: Value(synced),
    );
  }

  factory SensorGeolocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SensorGeolocation(
      id: serializer.fromJson<int?>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitude: serializer.fromJson<double>(json['altitude']),
      bearing: serializer.fromJson<double>(json['bearing']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      speed: serializer.fromJson<double>(json['speed']),
      sensorType: serializer.fromJson<String>(json['sensorType']),
      provider: serializer.fromJson<String>(json['provider']),
      isNoise: serializer.fromJson<bool>(json['isNoise']),
      createdOn: serializer.fromJson<DateTime>(json['createdOn']),
      deletedOn: serializer.fromJson<DateTime?>(json['deletedOn']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitude': serializer.toJson<double>(altitude),
      'bearing': serializer.toJson<double>(bearing),
      'accuracy': serializer.toJson<double>(accuracy),
      'speed': serializer.toJson<double>(speed),
      'sensorType': serializer.toJson<String>(sensorType),
      'provider': serializer.toJson<String>(provider),
      'isNoise': serializer.toJson<bool>(isNoise),
      'createdOn': serializer.toJson<DateTime>(createdOn),
      'deletedOn': serializer.toJson<DateTime?>(deletedOn),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SensorGeolocation copyWith(
          {int? id,
          double? latitude,
          double? longitude,
          double? altitude,
          double? bearing,
          double? accuracy,
          double? speed,
          String? sensorType,
          String? provider,
          bool? isNoise,
          DateTime? createdOn,
          DateTime? deletedOn,
          bool? synced}) =>
      SensorGeolocation(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        altitude: altitude ?? this.altitude,
        bearing: bearing ?? this.bearing,
        accuracy: accuracy ?? this.accuracy,
        speed: speed ?? this.speed,
        sensorType: sensorType ?? this.sensorType,
        provider: provider ?? this.provider,
        isNoise: isNoise ?? this.isNoise,
        createdOn: createdOn ?? this.createdOn,
        deletedOn: deletedOn ?? this.deletedOn,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('SensorGeolocation(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('bearing: $bearing, ')
          ..write('accuracy: $accuracy, ')
          ..write('speed: $speed, ')
          ..write('sensorType: $sensorType, ')
          ..write('provider: $provider, ')
          ..write('isNoise: $isNoise, ')
          ..write('createdOn: $createdOn, ')
          ..write('deletedOn: $deletedOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      latitude,
      longitude,
      altitude,
      bearing,
      accuracy,
      speed,
      sensorType,
      provider,
      isNoise,
      createdOn,
      deletedOn,
      synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SensorGeolocation &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitude == this.altitude &&
          other.bearing == this.bearing &&
          other.accuracy == this.accuracy &&
          other.speed == this.speed &&
          other.sensorType == this.sensorType &&
          other.provider == this.provider &&
          other.isNoise == this.isNoise &&
          other.createdOn == this.createdOn &&
          other.deletedOn == this.deletedOn &&
          other.synced == this.synced);
}

class SensorGeolocationsCompanion extends UpdateCompanion<SensorGeolocation> {
  final Value<int?> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> altitude;
  final Value<double> bearing;
  final Value<double> accuracy;
  final Value<double> speed;
  final Value<String> sensorType;
  final Value<String> provider;
  final Value<bool> isNoise;
  final Value<DateTime> createdOn;
  final Value<DateTime?> deletedOn;
  final Value<bool> synced;
  const SensorGeolocationsCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.bearing = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.speed = const Value.absent(),
    this.sensorType = const Value.absent(),
    this.provider = const Value.absent(),
    this.isNoise = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.deletedOn = const Value.absent(),
    this.synced = const Value.absent(),
  });
  SensorGeolocationsCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    required double altitude,
    required double bearing,
    required double accuracy,
    required double speed,
    required String sensorType,
    required String provider,
    required bool isNoise,
    required DateTime createdOn,
    this.deletedOn = const Value.absent(),
    this.synced = const Value.absent(),
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        altitude = Value(altitude),
        bearing = Value(bearing),
        accuracy = Value(accuracy),
        speed = Value(speed),
        sensorType = Value(sensorType),
        provider = Value(provider),
        isNoise = Value(isNoise),
        createdOn = Value(createdOn);
  static Insertable<SensorGeolocation> custom({
    Expression<int?>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitude,
    Expression<double>? bearing,
    Expression<double>? accuracy,
    Expression<double>? speed,
    Expression<String>? sensorType,
    Expression<String>? provider,
    Expression<bool>? isNoise,
    Expression<DateTime>? createdOn,
    Expression<DateTime?>? deletedOn,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitude != null) 'altitude': altitude,
      if (bearing != null) 'bearing': bearing,
      if (accuracy != null) 'accuracy': accuracy,
      if (speed != null) 'speed': speed,
      if (sensorType != null) 'sensor_type': sensorType,
      if (provider != null) 'provider': provider,
      if (isNoise != null) 'is_noise': isNoise,
      if (createdOn != null) 'created_on': createdOn,
      if (deletedOn != null) 'deleted_on': deletedOn,
      if (synced != null) 'synced': synced,
    });
  }

  SensorGeolocationsCompanion copyWith(
      {Value<int?>? id,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? altitude,
      Value<double>? bearing,
      Value<double>? accuracy,
      Value<double>? speed,
      Value<String>? sensorType,
      Value<String>? provider,
      Value<bool>? isNoise,
      Value<DateTime>? createdOn,
      Value<DateTime?>? deletedOn,
      Value<bool>? synced}) {
    return SensorGeolocationsCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      bearing: bearing ?? this.bearing,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      sensorType: sensorType ?? this.sensorType,
      provider: provider ?? this.provider,
      isNoise: isNoise ?? this.isNoise,
      createdOn: createdOn ?? this.createdOn,
      deletedOn: deletedOn ?? this.deletedOn,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (bearing.present) {
      map['bearing'] = Variable<double>(bearing.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (sensorType.present) {
      map['sensor_type'] = Variable<String>(sensorType.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (isNoise.present) {
      map['is_noise'] = Variable<bool>(isNoise.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<DateTime>(createdOn.value);
    }
    if (deletedOn.present) {
      map['deleted_on'] = Variable<DateTime?>(deletedOn.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SensorGeolocationsCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('bearing: $bearing, ')
          ..write('accuracy: $accuracy, ')
          ..write('speed: $speed, ')
          ..write('sensorType: $sensorType, ')
          ..write('provider: $provider, ')
          ..write('isNoise: $isNoise, ')
          ..write('createdOn: $createdOn, ')
          ..write('deletedOn: $deletedOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $SensorGeolocationsTable extends SensorGeolocations
    with TableInfo<$SensorGeolocationsTable, SensorGeolocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SensorGeolocationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double?> latitude = GeneratedColumn<double?>(
      'latitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double?> longitude = GeneratedColumn<double?>(
      'longitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _altitudeMeta = const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double?> altitude = GeneratedColumn<double?>(
      'altitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _bearingMeta = const VerificationMeta('bearing');
  @override
  late final GeneratedColumn<double?> bearing = GeneratedColumn<double?>(
      'bearing', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _accuracyMeta = const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double?> accuracy = GeneratedColumn<double?>(
      'accuracy', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double?> speed = GeneratedColumn<double?>(
      'speed', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _sensorTypeMeta = const VerificationMeta('sensorType');
  @override
  late final GeneratedColumn<String?> sensorType = GeneratedColumn<String?>(
      'sensor_type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _providerMeta = const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String?> provider = GeneratedColumn<String?>(
      'provider', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isNoiseMeta = const VerificationMeta('isNoise');
  @override
  late final GeneratedColumn<bool?> isNoise = GeneratedColumn<bool?>(
      'is_noise', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_noise IN (0, 1))');
  final VerificationMeta _createdOnMeta = const VerificationMeta('createdOn');
  @override
  late final GeneratedColumn<DateTime?> createdOn = GeneratedColumn<DateTime?>(
      'created_on', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deletedOnMeta = const VerificationMeta('deletedOn');
  @override
  late final GeneratedColumn<DateTime?> deletedOn = GeneratedColumn<DateTime?>(
      'deleted_on', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        latitude,
        longitude,
        altitude,
        bearing,
        accuracy,
        speed,
        sensorType,
        provider,
        isNoise,
        createdOn,
        deletedOn,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'sensor_geolocations';
  @override
  String get actualTableName => 'sensor_geolocations';
  @override
  VerificationContext validateIntegrity(Insertable<SensorGeolocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    } else if (isInserting) {
      context.missing(_altitudeMeta);
    }
    if (data.containsKey('bearing')) {
      context.handle(_bearingMeta,
          bearing.isAcceptableOrUnknown(data['bearing']!, _bearingMeta));
    } else if (isInserting) {
      context.missing(_bearingMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
          _speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('sensor_type')) {
      context.handle(
          _sensorTypeMeta,
          sensorType.isAcceptableOrUnknown(
              data['sensor_type']!, _sensorTypeMeta));
    } else if (isInserting) {
      context.missing(_sensorTypeMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('is_noise')) {
      context.handle(_isNoiseMeta,
          isNoise.isAcceptableOrUnknown(data['is_noise']!, _isNoiseMeta));
    } else if (isInserting) {
      context.missing(_isNoiseMeta);
    }
    if (data.containsKey('created_on')) {
      context.handle(_createdOnMeta,
          createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta));
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('deleted_on')) {
      context.handle(_deletedOnMeta,
          deletedOn.isAcceptableOrUnknown(data['deleted_on']!, _deletedOnMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SensorGeolocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    return SensorGeolocation.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SensorGeolocationsTable createAlias(String alias) {
    return $SensorGeolocationsTable(attachedDatabase, alias);
  }
}

class GoogleMapsData extends DataClass implements Insertable<GoogleMapsData> {
  final int? id;
  final String? googleId;
  final String? address;
  final String? city;
  final String? postcode;
  final String? country;
  final String? name;
  GoogleMapsData(
      {this.id,
      this.googleId,
      this.address,
      this.city,
      this.postcode,
      this.country,
      this.name});
  factory GoogleMapsData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return GoogleMapsData(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      googleId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}google_id']),
      address: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}address']),
      city: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}city']),
      postcode: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}postcode']),
      country: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}country']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    if (!nullToAbsent || googleId != null) {
      map['google_id'] = Variable<String?>(googleId);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String?>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String?>(city);
    }
    if (!nullToAbsent || postcode != null) {
      map['postcode'] = Variable<String?>(postcode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String?>(country);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    return map;
  }

  GoogleMapsDatasCompanion toCompanion(bool nullToAbsent) {
    return GoogleMapsDatasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      googleId: googleId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleId),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      postcode: postcode == null && nullToAbsent
          ? const Value.absent()
          : Value(postcode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory GoogleMapsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoogleMapsData(
      id: serializer.fromJson<int?>(json['id']),
      googleId: serializer.fromJson<String?>(json['googleId']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      postcode: serializer.fromJson<String?>(json['postcode']),
      country: serializer.fromJson<String?>(json['country']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'googleId': serializer.toJson<String?>(googleId),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'postcode': serializer.toJson<String?>(postcode),
      'country': serializer.toJson<String?>(country),
      'name': serializer.toJson<String?>(name),
    };
  }

  GoogleMapsData copyWith(
          {int? id,
          String? googleId,
          String? address,
          String? city,
          String? postcode,
          String? country,
          String? name}) =>
      GoogleMapsData(
        id: id ?? this.id,
        googleId: googleId ?? this.googleId,
        address: address ?? this.address,
        city: city ?? this.city,
        postcode: postcode ?? this.postcode,
        country: country ?? this.country,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('GoogleMapsData(')
          ..write('id: $id, ')
          ..write('googleId: $googleId, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('postcode: $postcode, ')
          ..write('country: $country, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, googleId, address, city, postcode, country, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoogleMapsData &&
          other.id == this.id &&
          other.googleId == this.googleId &&
          other.address == this.address &&
          other.city == this.city &&
          other.postcode == this.postcode &&
          other.country == this.country &&
          other.name == this.name);
}

class GoogleMapsDatasCompanion extends UpdateCompanion<GoogleMapsData> {
  final Value<int?> id;
  final Value<String?> googleId;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> postcode;
  final Value<String?> country;
  final Value<String?> name;
  const GoogleMapsDatasCompanion({
    this.id = const Value.absent(),
    this.googleId = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.postcode = const Value.absent(),
    this.country = const Value.absent(),
    this.name = const Value.absent(),
  });
  GoogleMapsDatasCompanion.insert({
    this.id = const Value.absent(),
    this.googleId = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.postcode = const Value.absent(),
    this.country = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<GoogleMapsData> custom({
    Expression<int?>? id,
    Expression<String?>? googleId,
    Expression<String?>? address,
    Expression<String?>? city,
    Expression<String?>? postcode,
    Expression<String?>? country,
    Expression<String?>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (googleId != null) 'google_id': googleId,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (postcode != null) 'postcode': postcode,
      if (country != null) 'country': country,
      if (name != null) 'name': name,
    });
  }

  GoogleMapsDatasCompanion copyWith(
      {Value<int?>? id,
      Value<String?>? googleId,
      Value<String?>? address,
      Value<String?>? city,
      Value<String?>? postcode,
      Value<String?>? country,
      Value<String?>? name}) {
    return GoogleMapsDatasCompanion(
      id: id ?? this.id,
      googleId: googleId ?? this.googleId,
      address: address ?? this.address,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (googleId.present) {
      map['google_id'] = Variable<String?>(googleId.value);
    }
    if (address.present) {
      map['address'] = Variable<String?>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String?>(city.value);
    }
    if (postcode.present) {
      map['postcode'] = Variable<String?>(postcode.value);
    }
    if (country.present) {
      map['country'] = Variable<String?>(country.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoogleMapsDatasCompanion(')
          ..write('id: $id, ')
          ..write('googleId: $googleId, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('postcode: $postcode, ')
          ..write('country: $country, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $GoogleMapsDatasTable extends GoogleMapsDatas
    with TableInfo<$GoogleMapsDatasTable, GoogleMapsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoogleMapsDatasTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _googleIdMeta = const VerificationMeta('googleId');
  @override
  late final GeneratedColumn<String?> googleId = GeneratedColumn<String?>(
      'google_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _addressMeta = const VerificationMeta('address');
  @override
  late final GeneratedColumn<String?> address = GeneratedColumn<String?>(
      'address', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String?> city = GeneratedColumn<String?>(
      'city', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _postcodeMeta = const VerificationMeta('postcode');
  @override
  late final GeneratedColumn<String?> postcode = GeneratedColumn<String?>(
      'postcode', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _countryMeta = const VerificationMeta('country');
  @override
  late final GeneratedColumn<String?> country = GeneratedColumn<String?>(
      'country', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, googleId, address, city, postcode, country, name];
  @override
  String get aliasedName => _alias ?? 'google_maps_datas';
  @override
  String get actualTableName => 'google_maps_datas';
  @override
  VerificationContext validateIntegrity(Insertable<GoogleMapsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('google_id')) {
      context.handle(_googleIdMeta,
          googleId.isAcceptableOrUnknown(data['google_id']!, _googleIdMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('postcode')) {
      context.handle(_postcodeMeta,
          postcode.isAcceptableOrUnknown(data['postcode']!, _postcodeMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoogleMapsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return GoogleMapsData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GoogleMapsDatasTable createAlias(String alias) {
    return $GoogleMapsDatasTable(attachedDatabase, alias);
  }
}

class Stop extends DataClass implements Insertable<Stop> {
  final int? id;
  final int classifiedPeriodId;
  final int? reasonId;
  final int? googleMapsDataId;
  Stop(
      {this.id,
      required this.classifiedPeriodId,
      this.reasonId,
      this.googleMapsDataId});
  factory Stop.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Stop(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      classifiedPeriodId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}classified_period_id'])!,
      reasonId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reason_id']),
      googleMapsDataId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}google_maps_data_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    map['classified_period_id'] = Variable<int>(classifiedPeriodId);
    if (!nullToAbsent || reasonId != null) {
      map['reason_id'] = Variable<int?>(reasonId);
    }
    if (!nullToAbsent || googleMapsDataId != null) {
      map['google_maps_data_id'] = Variable<int?>(googleMapsDataId);
    }
    return map;
  }

  StopsCompanion toCompanion(bool nullToAbsent) {
    return StopsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      classifiedPeriodId: Value(classifiedPeriodId),
      reasonId: reasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonId),
      googleMapsDataId: googleMapsDataId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleMapsDataId),
    );
  }

  factory Stop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stop(
      id: serializer.fromJson<int?>(json['id']),
      classifiedPeriodId: serializer.fromJson<int>(json['classifiedPeriodId']),
      reasonId: serializer.fromJson<int?>(json['reasonId']),
      googleMapsDataId: serializer.fromJson<int?>(json['googleMapsDataId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'classifiedPeriodId': serializer.toJson<int>(classifiedPeriodId),
      'reasonId': serializer.toJson<int?>(reasonId),
      'googleMapsDataId': serializer.toJson<int?>(googleMapsDataId),
    };
  }

  Stop copyWith(
          {int? id,
          int? classifiedPeriodId,
          int? reasonId,
          int? googleMapsDataId}) =>
      Stop(
        id: id ?? this.id,
        classifiedPeriodId: classifiedPeriodId ?? this.classifiedPeriodId,
        reasonId: reasonId ?? this.reasonId,
        googleMapsDataId: googleMapsDataId ?? this.googleMapsDataId,
      );
  @override
  String toString() {
    return (StringBuffer('Stop(')
          ..write('id: $id, ')
          ..write('classifiedPeriodId: $classifiedPeriodId, ')
          ..write('reasonId: $reasonId, ')
          ..write('googleMapsDataId: $googleMapsDataId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, classifiedPeriodId, reasonId, googleMapsDataId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stop &&
          other.id == this.id &&
          other.classifiedPeriodId == this.classifiedPeriodId &&
          other.reasonId == this.reasonId &&
          other.googleMapsDataId == this.googleMapsDataId);
}

class StopsCompanion extends UpdateCompanion<Stop> {
  final Value<int?> id;
  final Value<int> classifiedPeriodId;
  final Value<int?> reasonId;
  final Value<int?> googleMapsDataId;
  const StopsCompanion({
    this.id = const Value.absent(),
    this.classifiedPeriodId = const Value.absent(),
    this.reasonId = const Value.absent(),
    this.googleMapsDataId = const Value.absent(),
  });
  StopsCompanion.insert({
    this.id = const Value.absent(),
    required int classifiedPeriodId,
    this.reasonId = const Value.absent(),
    this.googleMapsDataId = const Value.absent(),
  }) : classifiedPeriodId = Value(classifiedPeriodId);
  static Insertable<Stop> custom({
    Expression<int?>? id,
    Expression<int>? classifiedPeriodId,
    Expression<int?>? reasonId,
    Expression<int?>? googleMapsDataId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classifiedPeriodId != null)
        'classified_period_id': classifiedPeriodId,
      if (reasonId != null) 'reason_id': reasonId,
      if (googleMapsDataId != null) 'google_maps_data_id': googleMapsDataId,
    });
  }

  StopsCompanion copyWith(
      {Value<int?>? id,
      Value<int>? classifiedPeriodId,
      Value<int?>? reasonId,
      Value<int?>? googleMapsDataId}) {
    return StopsCompanion(
      id: id ?? this.id,
      classifiedPeriodId: classifiedPeriodId ?? this.classifiedPeriodId,
      reasonId: reasonId ?? this.reasonId,
      googleMapsDataId: googleMapsDataId ?? this.googleMapsDataId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (classifiedPeriodId.present) {
      map['classified_period_id'] = Variable<int>(classifiedPeriodId.value);
    }
    if (reasonId.present) {
      map['reason_id'] = Variable<int?>(reasonId.value);
    }
    if (googleMapsDataId.present) {
      map['google_maps_data_id'] = Variable<int?>(googleMapsDataId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopsCompanion(')
          ..write('id: $id, ')
          ..write('classifiedPeriodId: $classifiedPeriodId, ')
          ..write('reasonId: $reasonId, ')
          ..write('googleMapsDataId: $googleMapsDataId')
          ..write(')'))
        .toString();
  }
}

class $StopsTable extends Stops with TableInfo<$StopsTable, Stop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StopsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _classifiedPeriodIdMeta =
      const VerificationMeta('classifiedPeriodId');
  @override
  late final GeneratedColumn<int?> classifiedPeriodId = GeneratedColumn<int?>(
      'classified_period_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES classified_periods (id)');
  final VerificationMeta _reasonIdMeta = const VerificationMeta('reasonId');
  @override
  late final GeneratedColumn<int?> reasonId = GeneratedColumn<int?>(
      'reason_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES reasons (id)');
  final VerificationMeta _googleMapsDataIdMeta =
      const VerificationMeta('googleMapsDataId');
  @override
  late final GeneratedColumn<int?> googleMapsDataId = GeneratedColumn<int?>(
      'google_maps_data_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES google_maps_datas (id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, classifiedPeriodId, reasonId, googleMapsDataId];
  @override
  String get aliasedName => _alias ?? 'stops';
  @override
  String get actualTableName => 'stops';
  @override
  VerificationContext validateIntegrity(Insertable<Stop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('classified_period_id')) {
      context.handle(
          _classifiedPeriodIdMeta,
          classifiedPeriodId.isAcceptableOrUnknown(
              data['classified_period_id']!, _classifiedPeriodIdMeta));
    } else if (isInserting) {
      context.missing(_classifiedPeriodIdMeta);
    }
    if (data.containsKey('reason_id')) {
      context.handle(_reasonIdMeta,
          reasonId.isAcceptableOrUnknown(data['reason_id']!, _reasonIdMeta));
    }
    if (data.containsKey('google_maps_data_id')) {
      context.handle(
          _googleMapsDataIdMeta,
          googleMapsDataId.isAcceptableOrUnknown(
              data['google_maps_data_id']!, _googleMapsDataIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stop map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Stop.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $StopsTable createAlias(String alias) {
    return $StopsTable(attachedDatabase, alias);
  }
}

class TrackedLocation extends DataClass implements Insertable<TrackedLocation> {
  final int id;
  final String? name;
  final int? reasonId;
  final int trackedDayId;
  final DateTime startTime;
  final DateTime endTime;
  final bool confirmed;
  final double lat;
  final double lon;
  final String uuid;
  final DateTime? created;
  final DateTime? updated;
  final DateTime? deleted;
  TrackedLocation(
      {required this.id,
      this.name,
      this.reasonId,
      required this.trackedDayId,
      required this.startTime,
      required this.endTime,
      required this.confirmed,
      required this.lat,
      required this.lon,
      required this.uuid,
      this.created,
      this.updated,
      this.deleted});
  factory TrackedLocation.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TrackedLocation(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      reasonId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reason_id']),
      trackedDayId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tracked_day_id'])!,
      startTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_time'])!,
      endTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}end_time'])!,
      confirmed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}confirmed'])!,
      lat: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lat'])!,
      lon: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lon'])!,
      uuid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uuid'])!,
      created: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
      updated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated']),
      deleted: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || reasonId != null) {
      map['reason_id'] = Variable<int?>(reasonId);
    }
    map['tracked_day_id'] = Variable<int>(trackedDayId);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['confirmed'] = Variable<bool>(confirmed);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || created != null) {
      map['created'] = Variable<DateTime?>(created);
    }
    if (!nullToAbsent || updated != null) {
      map['updated'] = Variable<DateTime?>(updated);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<DateTime?>(deleted);
    }
    return map;
  }

  TrackedLocationsCompanion toCompanion(bool nullToAbsent) {
    return TrackedLocationsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      reasonId: reasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonId),
      trackedDayId: Value(trackedDayId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      confirmed: Value(confirmed),
      lat: Value(lat),
      lon: Value(lon),
      uuid: Value(uuid),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      updated: updated == null && nullToAbsent
          ? const Value.absent()
          : Value(updated),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
    );
  }

  factory TrackedLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      reasonId: serializer.fromJson<int?>(json['reasonId']),
      trackedDayId: serializer.fromJson<int>(json['trackedDayId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      uuid: serializer.fromJson<String>(json['uuid']),
      created: serializer.fromJson<DateTime?>(json['created']),
      updated: serializer.fromJson<DateTime?>(json['updated']),
      deleted: serializer.fromJson<DateTime?>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'reasonId': serializer.toJson<int?>(reasonId),
      'trackedDayId': serializer.toJson<int>(trackedDayId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'confirmed': serializer.toJson<bool>(confirmed),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'uuid': serializer.toJson<String>(uuid),
      'created': serializer.toJson<DateTime?>(created),
      'updated': serializer.toJson<DateTime?>(updated),
      'deleted': serializer.toJson<DateTime?>(deleted),
    };
  }

  TrackedLocation copyWith(
          {int? id,
          String? name,
          int? reasonId,
          int? trackedDayId,
          DateTime? startTime,
          DateTime? endTime,
          bool? confirmed,
          double? lat,
          double? lon,
          String? uuid,
          DateTime? created,
          DateTime? updated,
          DateTime? deleted}) =>
      TrackedLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        reasonId: reasonId ?? this.reasonId,
        trackedDayId: trackedDayId ?? this.trackedDayId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        confirmed: confirmed ?? this.confirmed,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        uuid: uuid ?? this.uuid,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        deleted: deleted ?? this.deleted,
      );
  @override
  String toString() {
    return (StringBuffer('TrackedLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('reasonId: $reasonId, ')
          ..write('trackedDayId: $trackedDayId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('confirmed: $confirmed, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('uuid: $uuid, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, reasonId, trackedDayId, startTime,
      endTime, confirmed, lat, lon, uuid, created, updated, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.reasonId == this.reasonId &&
          other.trackedDayId == this.trackedDayId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.confirmed == this.confirmed &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.uuid == this.uuid &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.deleted == this.deleted);
}

class TrackedLocationsCompanion extends UpdateCompanion<TrackedLocation> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int?> reasonId;
  final Value<int> trackedDayId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<bool> confirmed;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String> uuid;
  final Value<DateTime?> created;
  final Value<DateTime?> updated;
  final Value<DateTime?> deleted;
  const TrackedLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.reasonId = const Value.absent(),
    this.trackedDayId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.uuid = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  TrackedLocationsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.reasonId = const Value.absent(),
    required int trackedDayId,
    required DateTime startTime,
    required DateTime endTime,
    this.confirmed = const Value.absent(),
    required double lat,
    required double lon,
    required String uuid,
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.deleted = const Value.absent(),
  })  : trackedDayId = Value(trackedDayId),
        startTime = Value(startTime),
        endTime = Value(endTime),
        lat = Value(lat),
        lon = Value(lon),
        uuid = Value(uuid);
  static Insertable<TrackedLocation> custom({
    Expression<int>? id,
    Expression<String?>? name,
    Expression<int?>? reasonId,
    Expression<int>? trackedDayId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? confirmed,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? uuid,
    Expression<DateTime?>? created,
    Expression<DateTime?>? updated,
    Expression<DateTime?>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (reasonId != null) 'reason_id': reasonId,
      if (trackedDayId != null) 'tracked_day_id': trackedDayId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (confirmed != null) 'confirmed': confirmed,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (uuid != null) 'uuid': uuid,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (deleted != null) 'deleted': deleted,
    });
  }

  TrackedLocationsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<int?>? reasonId,
      Value<int>? trackedDayId,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<bool>? confirmed,
      Value<double>? lat,
      Value<double>? lon,
      Value<String>? uuid,
      Value<DateTime?>? created,
      Value<DateTime?>? updated,
      Value<DateTime?>? deleted}) {
    return TrackedLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      reasonId: reasonId ?? this.reasonId,
      trackedDayId: trackedDayId ?? this.trackedDayId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      confirmed: confirmed ?? this.confirmed,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      uuid: uuid ?? this.uuid,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (reasonId.present) {
      map['reason_id'] = Variable<int?>(reasonId.value);
    }
    if (trackedDayId.present) {
      map['tracked_day_id'] = Variable<int>(trackedDayId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime?>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<DateTime?>(updated.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<DateTime?>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('reasonId: $reasonId, ')
          ..write('trackedDayId: $trackedDayId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('confirmed: $confirmed, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('uuid: $uuid, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $TrackedLocationsTable extends TrackedLocations
    with TableInfo<$TrackedLocationsTable, TrackedLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedLocationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _reasonIdMeta = const VerificationMeta('reasonId');
  @override
  late final GeneratedColumn<int?> reasonId = GeneratedColumn<int?>(
      'reason_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _trackedDayIdMeta =
      const VerificationMeta('trackedDayId');
  @override
  late final GeneratedColumn<int?> trackedDayId = GeneratedColumn<int?>(
      'tracked_day_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _startTimeMeta = const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime?> startTime = GeneratedColumn<DateTime?>(
      'start_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _endTimeMeta = const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime?> endTime = GeneratedColumn<DateTime?>(
      'end_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _confirmedMeta = const VerificationMeta('confirmed');
  @override
  late final GeneratedColumn<bool?> confirmed = GeneratedColumn<bool?>(
      'confirmed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (confirmed IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double?> lat = GeneratedColumn<double?>(
      'lat', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double?> lon = GeneratedColumn<double?>(
      'lon', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String?> uuid = GeneratedColumn<String?>(
      'uuid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _createdMeta = const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime?> created = GeneratedColumn<DateTime?>(
      'created', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _updatedMeta = const VerificationMeta('updated');
  @override
  late final GeneratedColumn<DateTime?> updated = GeneratedColumn<DateTime?>(
      'updated', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<DateTime?> deleted = GeneratedColumn<DateTime?>(
      'deleted', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        reasonId,
        trackedDayId,
        startTime,
        endTime,
        confirmed,
        lat,
        lon,
        uuid,
        created,
        updated,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? 'tracked_locations';
  @override
  String get actualTableName => 'tracked_locations';
  @override
  VerificationContext validateIntegrity(Insertable<TrackedLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('reason_id')) {
      context.handle(_reasonIdMeta,
          reasonId.isAcceptableOrUnknown(data['reason_id']!, _reasonIdMeta));
    }
    if (data.containsKey('tracked_day_id')) {
      context.handle(
          _trackedDayIdMeta,
          trackedDayId.isAcceptableOrUnknown(
              data['tracked_day_id']!, _trackedDayIdMeta));
    } else if (isInserting) {
      context.missing(_trackedDayIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(_confirmedMeta,
          confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta));
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
          _lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TrackedLocation.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TrackedLocationsTable createAlias(String alias) {
    return $TrackedLocationsTable(attachedDatabase, alias);
  }
}

class TrackedMovement extends DataClass implements Insertable<TrackedMovement> {
  final int id;
  final int trackedLocationId;
  final int? movementCategoryId;
  final DateTime startTime;
  final DateTime endTime;
  final bool confirmed;
  final String uuid;
  final DateTime? created;
  final DateTime? updated;
  final DateTime? deleted;
  TrackedMovement(
      {required this.id,
      required this.trackedLocationId,
      this.movementCategoryId,
      required this.startTime,
      required this.endTime,
      required this.confirmed,
      required this.uuid,
      this.created,
      this.updated,
      this.deleted});
  factory TrackedMovement.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TrackedMovement(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      trackedLocationId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}tracked_location_id'])!,
      movementCategoryId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}movement_category_id']),
      startTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_time'])!,
      endTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}end_time'])!,
      confirmed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}confirmed'])!,
      uuid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uuid'])!,
      created: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
      updated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated']),
      deleted: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tracked_location_id'] = Variable<int>(trackedLocationId);
    if (!nullToAbsent || movementCategoryId != null) {
      map['movement_category_id'] = Variable<int?>(movementCategoryId);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['confirmed'] = Variable<bool>(confirmed);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || created != null) {
      map['created'] = Variable<DateTime?>(created);
    }
    if (!nullToAbsent || updated != null) {
      map['updated'] = Variable<DateTime?>(updated);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<DateTime?>(deleted);
    }
    return map;
  }

  TrackedMovementsCompanion toCompanion(bool nullToAbsent) {
    return TrackedMovementsCompanion(
      id: Value(id),
      trackedLocationId: Value(trackedLocationId),
      movementCategoryId: movementCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(movementCategoryId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      confirmed: Value(confirmed),
      uuid: Value(uuid),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      updated: updated == null && nullToAbsent
          ? const Value.absent()
          : Value(updated),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
    );
  }

  factory TrackedMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedMovement(
      id: serializer.fromJson<int>(json['id']),
      trackedLocationId: serializer.fromJson<int>(json['trackedLocationId']),
      movementCategoryId: serializer.fromJson<int?>(json['movementCategoryId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      uuid: serializer.fromJson<String>(json['uuid']),
      created: serializer.fromJson<DateTime?>(json['created']),
      updated: serializer.fromJson<DateTime?>(json['updated']),
      deleted: serializer.fromJson<DateTime?>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackedLocationId': serializer.toJson<int>(trackedLocationId),
      'movementCategoryId': serializer.toJson<int?>(movementCategoryId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'confirmed': serializer.toJson<bool>(confirmed),
      'uuid': serializer.toJson<String>(uuid),
      'created': serializer.toJson<DateTime?>(created),
      'updated': serializer.toJson<DateTime?>(updated),
      'deleted': serializer.toJson<DateTime?>(deleted),
    };
  }

  TrackedMovement copyWith(
          {int? id,
          int? trackedLocationId,
          int? movementCategoryId,
          DateTime? startTime,
          DateTime? endTime,
          bool? confirmed,
          String? uuid,
          DateTime? created,
          DateTime? updated,
          DateTime? deleted}) =>
      TrackedMovement(
        id: id ?? this.id,
        trackedLocationId: trackedLocationId ?? this.trackedLocationId,
        movementCategoryId: movementCategoryId ?? this.movementCategoryId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        confirmed: confirmed ?? this.confirmed,
        uuid: uuid ?? this.uuid,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        deleted: deleted ?? this.deleted,
      );
  @override
  String toString() {
    return (StringBuffer('TrackedMovement(')
          ..write('id: $id, ')
          ..write('trackedLocationId: $trackedLocationId, ')
          ..write('movementCategoryId: $movementCategoryId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('confirmed: $confirmed, ')
          ..write('uuid: $uuid, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackedLocationId, movementCategoryId,
      startTime, endTime, confirmed, uuid, created, updated, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedMovement &&
          other.id == this.id &&
          other.trackedLocationId == this.trackedLocationId &&
          other.movementCategoryId == this.movementCategoryId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.confirmed == this.confirmed &&
          other.uuid == this.uuid &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.deleted == this.deleted);
}

class TrackedMovementsCompanion extends UpdateCompanion<TrackedMovement> {
  final Value<int> id;
  final Value<int> trackedLocationId;
  final Value<int?> movementCategoryId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<bool> confirmed;
  final Value<String> uuid;
  final Value<DateTime?> created;
  final Value<DateTime?> updated;
  final Value<DateTime?> deleted;
  const TrackedMovementsCompanion({
    this.id = const Value.absent(),
    this.trackedLocationId = const Value.absent(),
    this.movementCategoryId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.uuid = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  TrackedMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int trackedLocationId,
    this.movementCategoryId = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    this.confirmed = const Value.absent(),
    required String uuid,
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.deleted = const Value.absent(),
  })  : trackedLocationId = Value(trackedLocationId),
        startTime = Value(startTime),
        endTime = Value(endTime),
        uuid = Value(uuid);
  static Insertable<TrackedMovement> custom({
    Expression<int>? id,
    Expression<int>? trackedLocationId,
    Expression<int?>? movementCategoryId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? confirmed,
    Expression<String>? uuid,
    Expression<DateTime?>? created,
    Expression<DateTime?>? updated,
    Expression<DateTime?>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackedLocationId != null) 'tracked_location_id': trackedLocationId,
      if (movementCategoryId != null)
        'movement_category_id': movementCategoryId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (confirmed != null) 'confirmed': confirmed,
      if (uuid != null) 'uuid': uuid,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (deleted != null) 'deleted': deleted,
    });
  }

  TrackedMovementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? trackedLocationId,
      Value<int?>? movementCategoryId,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<bool>? confirmed,
      Value<String>? uuid,
      Value<DateTime?>? created,
      Value<DateTime?>? updated,
      Value<DateTime?>? deleted}) {
    return TrackedMovementsCompanion(
      id: id ?? this.id,
      trackedLocationId: trackedLocationId ?? this.trackedLocationId,
      movementCategoryId: movementCategoryId ?? this.movementCategoryId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      confirmed: confirmed ?? this.confirmed,
      uuid: uuid ?? this.uuid,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackedLocationId.present) {
      map['tracked_location_id'] = Variable<int>(trackedLocationId.value);
    }
    if (movementCategoryId.present) {
      map['movement_category_id'] = Variable<int?>(movementCategoryId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime?>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<DateTime?>(updated.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<DateTime?>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedMovementsCompanion(')
          ..write('id: $id, ')
          ..write('trackedLocationId: $trackedLocationId, ')
          ..write('movementCategoryId: $movementCategoryId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('confirmed: $confirmed, ')
          ..write('uuid: $uuid, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $TrackedMovementsTable extends TrackedMovements
    with TableInfo<$TrackedMovementsTable, TrackedMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedMovementsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _trackedLocationIdMeta =
      const VerificationMeta('trackedLocationId');
  @override
  late final GeneratedColumn<int?> trackedLocationId = GeneratedColumn<int?>(
      'tracked_location_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _movementCategoryIdMeta =
      const VerificationMeta('movementCategoryId');
  @override
  late final GeneratedColumn<int?> movementCategoryId = GeneratedColumn<int?>(
      'movement_category_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _startTimeMeta = const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime?> startTime = GeneratedColumn<DateTime?>(
      'start_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _endTimeMeta = const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime?> endTime = GeneratedColumn<DateTime?>(
      'end_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _confirmedMeta = const VerificationMeta('confirmed');
  @override
  late final GeneratedColumn<bool?> confirmed = GeneratedColumn<bool?>(
      'confirmed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (confirmed IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String?> uuid = GeneratedColumn<String?>(
      'uuid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _createdMeta = const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime?> created = GeneratedColumn<DateTime?>(
      'created', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _updatedMeta = const VerificationMeta('updated');
  @override
  late final GeneratedColumn<DateTime?> updated = GeneratedColumn<DateTime?>(
      'updated', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<DateTime?> deleted = GeneratedColumn<DateTime?>(
      'deleted', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        trackedLocationId,
        movementCategoryId,
        startTime,
        endTime,
        confirmed,
        uuid,
        created,
        updated,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? 'tracked_movements';
  @override
  String get actualTableName => 'tracked_movements';
  @override
  VerificationContext validateIntegrity(Insertable<TrackedMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracked_location_id')) {
      context.handle(
          _trackedLocationIdMeta,
          trackedLocationId.isAcceptableOrUnknown(
              data['tracked_location_id']!, _trackedLocationIdMeta));
    } else if (isInserting) {
      context.missing(_trackedLocationIdMeta);
    }
    if (data.containsKey('movement_category_id')) {
      context.handle(
          _movementCategoryIdMeta,
          movementCategoryId.isAcceptableOrUnknown(
              data['movement_category_id']!, _movementCategoryIdMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(_confirmedMeta,
          confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TrackedMovement.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TrackedMovementsTable createAlias(String alias) {
    return $TrackedMovementsTable(attachedDatabase, alias);
  }
}

class TrackedMovementLatLng extends DataClass
    implements Insertable<TrackedMovementLatLng> {
  final int id;
  final int movementId;
  final double lat;
  final double lon;
  final double altitude;
  final String uuid;
  final DateTime mappedDate;
  final DateTime? created;
  final DateTime? updated;
  final DateTime? deleted;
  TrackedMovementLatLng(
      {required this.id,
      required this.movementId,
      required this.lat,
      required this.lon,
      required this.altitude,
      required this.uuid,
      required this.mappedDate,
      this.created,
      this.updated,
      this.deleted});
  factory TrackedMovementLatLng.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TrackedMovementLatLng(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      movementId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_id'])!,
      lat: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lat'])!,
      lon: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lon'])!,
      altitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}altitude'])!,
      uuid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uuid'])!,
      mappedDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mapped_date'])!,
      created: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
      updated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated']),
      deleted: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['movement_id'] = Variable<int>(movementId);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['altitude'] = Variable<double>(altitude);
    map['uuid'] = Variable<String>(uuid);
    map['mapped_date'] = Variable<DateTime>(mappedDate);
    if (!nullToAbsent || created != null) {
      map['created'] = Variable<DateTime?>(created);
    }
    if (!nullToAbsent || updated != null) {
      map['updated'] = Variable<DateTime?>(updated);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<DateTime?>(deleted);
    }
    return map;
  }

  TrackedMovementLatLngsCompanion toCompanion(bool nullToAbsent) {
    return TrackedMovementLatLngsCompanion(
      id: Value(id),
      movementId: Value(movementId),
      lat: Value(lat),
      lon: Value(lon),
      altitude: Value(altitude),
      uuid: Value(uuid),
      mappedDate: Value(mappedDate),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      updated: updated == null && nullToAbsent
          ? const Value.absent()
          : Value(updated),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
    );
  }

  factory TrackedMovementLatLng.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedMovementLatLng(
      id: serializer.fromJson<int>(json['id']),
      movementId: serializer.fromJson<int>(json['movementId']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      altitude: serializer.fromJson<double>(json['altitude']),
      uuid: serializer.fromJson<String>(json['uuid']),
      mappedDate: serializer.fromJson<DateTime>(json['mappedDate']),
      created: serializer.fromJson<DateTime?>(json['created']),
      updated: serializer.fromJson<DateTime?>(json['updated']),
      deleted: serializer.fromJson<DateTime?>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movementId': serializer.toJson<int>(movementId),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'altitude': serializer.toJson<double>(altitude),
      'uuid': serializer.toJson<String>(uuid),
      'mappedDate': serializer.toJson<DateTime>(mappedDate),
      'created': serializer.toJson<DateTime?>(created),
      'updated': serializer.toJson<DateTime?>(updated),
      'deleted': serializer.toJson<DateTime?>(deleted),
    };
  }

  TrackedMovementLatLng copyWith(
          {int? id,
          int? movementId,
          double? lat,
          double? lon,
          double? altitude,
          String? uuid,
          DateTime? mappedDate,
          DateTime? created,
          DateTime? updated,
          DateTime? deleted}) =>
      TrackedMovementLatLng(
        id: id ?? this.id,
        movementId: movementId ?? this.movementId,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        altitude: altitude ?? this.altitude,
        uuid: uuid ?? this.uuid,
        mappedDate: mappedDate ?? this.mappedDate,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        deleted: deleted ?? this.deleted,
      );
  @override
  String toString() {
    return (StringBuffer('TrackedMovementLatLng(')
          ..write('id: $id, ')
          ..write('movementId: $movementId, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('altitude: $altitude, ')
          ..write('uuid: $uuid, ')
          ..write('mappedDate: $mappedDate, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, movementId, lat, lon, altitude, uuid,
      mappedDate, created, updated, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedMovementLatLng &&
          other.id == this.id &&
          other.movementId == this.movementId &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.altitude == this.altitude &&
          other.uuid == this.uuid &&
          other.mappedDate == this.mappedDate &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.deleted == this.deleted);
}

class TrackedMovementLatLngsCompanion
    extends UpdateCompanion<TrackedMovementLatLng> {
  final Value<int> id;
  final Value<int> movementId;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double> altitude;
  final Value<String> uuid;
  final Value<DateTime> mappedDate;
  final Value<DateTime?> created;
  final Value<DateTime?> updated;
  final Value<DateTime?> deleted;
  const TrackedMovementLatLngsCompanion({
    this.id = const Value.absent(),
    this.movementId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.altitude = const Value.absent(),
    this.uuid = const Value.absent(),
    this.mappedDate = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  TrackedMovementLatLngsCompanion.insert({
    this.id = const Value.absent(),
    required int movementId,
    required double lat,
    required double lon,
    required double altitude,
    required String uuid,
    required DateTime mappedDate,
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.deleted = const Value.absent(),
  })  : movementId = Value(movementId),
        lat = Value(lat),
        lon = Value(lon),
        altitude = Value(altitude),
        uuid = Value(uuid),
        mappedDate = Value(mappedDate);
  static Insertable<TrackedMovementLatLng> custom({
    Expression<int>? id,
    Expression<int>? movementId,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? altitude,
    Expression<String>? uuid,
    Expression<DateTime>? mappedDate,
    Expression<DateTime?>? created,
    Expression<DateTime?>? updated,
    Expression<DateTime?>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movementId != null) 'movement_id': movementId,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (altitude != null) 'altitude': altitude,
      if (uuid != null) 'uuid': uuid,
      if (mappedDate != null) 'mapped_date': mappedDate,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (deleted != null) 'deleted': deleted,
    });
  }

  TrackedMovementLatLngsCompanion copyWith(
      {Value<int>? id,
      Value<int>? movementId,
      Value<double>? lat,
      Value<double>? lon,
      Value<double>? altitude,
      Value<String>? uuid,
      Value<DateTime>? mappedDate,
      Value<DateTime?>? created,
      Value<DateTime?>? updated,
      Value<DateTime?>? deleted}) {
    return TrackedMovementLatLngsCompanion(
      id: id ?? this.id,
      movementId: movementId ?? this.movementId,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      altitude: altitude ?? this.altitude,
      uuid: uuid ?? this.uuid,
      mappedDate: mappedDate ?? this.mappedDate,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (movementId.present) {
      map['movement_id'] = Variable<int>(movementId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (mappedDate.present) {
      map['mapped_date'] = Variable<DateTime>(mappedDate.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime?>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<DateTime?>(updated.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<DateTime?>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedMovementLatLngsCompanion(')
          ..write('id: $id, ')
          ..write('movementId: $movementId, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('altitude: $altitude, ')
          ..write('uuid: $uuid, ')
          ..write('mappedDate: $mappedDate, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $TrackedMovementLatLngsTable extends TrackedMovementLatLngs
    with TableInfo<$TrackedMovementLatLngsTable, TrackedMovementLatLng> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedMovementLatLngsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _movementIdMeta = const VerificationMeta('movementId');
  @override
  late final GeneratedColumn<int?> movementId = GeneratedColumn<int?>(
      'movement_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double?> lat = GeneratedColumn<double?>(
      'lat', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double?> lon = GeneratedColumn<double?>(
      'lon', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _altitudeMeta = const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double?> altitude = GeneratedColumn<double?>(
      'altitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String?> uuid = GeneratedColumn<String?>(
      'uuid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _mappedDateMeta = const VerificationMeta('mappedDate');
  @override
  late final GeneratedColumn<DateTime?> mappedDate = GeneratedColumn<DateTime?>(
      'mapped_date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _createdMeta = const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime?> created = GeneratedColumn<DateTime?>(
      'created', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _updatedMeta = const VerificationMeta('updated');
  @override
  late final GeneratedColumn<DateTime?> updated = GeneratedColumn<DateTime?>(
      'updated', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<DateTime?> deleted = GeneratedColumn<DateTime?>(
      'deleted', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        movementId,
        lat,
        lon,
        altitude,
        uuid,
        mappedDate,
        created,
        updated,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? 'tracked_movement_lat_lngs';
  @override
  String get actualTableName => 'tracked_movement_lat_lngs';
  @override
  VerificationContext validateIntegrity(
      Insertable<TrackedMovementLatLng> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('movement_id')) {
      context.handle(
          _movementIdMeta,
          movementId.isAcceptableOrUnknown(
              data['movement_id']!, _movementIdMeta));
    } else if (isInserting) {
      context.missing(_movementIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
          _lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    } else if (isInserting) {
      context.missing(_altitudeMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('mapped_date')) {
      context.handle(
          _mappedDateMeta,
          mappedDate.isAcceptableOrUnknown(
              data['mapped_date']!, _mappedDateMeta));
    } else if (isInserting) {
      context.missing(_mappedDateMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedMovementLatLng map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TrackedMovementLatLng.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TrackedMovementLatLngsTable createAlias(String alias) {
    return $TrackedMovementLatLngsTable(attachedDatabase, alias);
  }
}

class AlgoState extends DataClass implements Insertable<AlgoState> {
  final int id;
  final bool isMoving;
  final int lastLocationIndex;
  final int lastMovingIndex;
  final int timeNotMoving;
  AlgoState(
      {required this.id,
      required this.isMoving,
      required this.lastLocationIndex,
      required this.lastMovingIndex,
      required this.timeNotMoving});
  factory AlgoState.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AlgoState(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      isMoving: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_moving'])!,
      lastLocationIndex: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}last_location_index'])!,
      lastMovingIndex: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}last_moving_index'])!,
      timeNotMoving: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time_not_moving'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_moving'] = Variable<bool>(isMoving);
    map['last_location_index'] = Variable<int>(lastLocationIndex);
    map['last_moving_index'] = Variable<int>(lastMovingIndex);
    map['time_not_moving'] = Variable<int>(timeNotMoving);
    return map;
  }

  AlgoStatesCompanion toCompanion(bool nullToAbsent) {
    return AlgoStatesCompanion(
      id: Value(id),
      isMoving: Value(isMoving),
      lastLocationIndex: Value(lastLocationIndex),
      lastMovingIndex: Value(lastMovingIndex),
      timeNotMoving: Value(timeNotMoving),
    );
  }

  factory AlgoState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlgoState(
      id: serializer.fromJson<int>(json['id']),
      isMoving: serializer.fromJson<bool>(json['isMoving']),
      lastLocationIndex: serializer.fromJson<int>(json['lastLocationIndex']),
      lastMovingIndex: serializer.fromJson<int>(json['lastMovingIndex']),
      timeNotMoving: serializer.fromJson<int>(json['timeNotMoving']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isMoving': serializer.toJson<bool>(isMoving),
      'lastLocationIndex': serializer.toJson<int>(lastLocationIndex),
      'lastMovingIndex': serializer.toJson<int>(lastMovingIndex),
      'timeNotMoving': serializer.toJson<int>(timeNotMoving),
    };
  }

  AlgoState copyWith(
          {int? id,
          bool? isMoving,
          int? lastLocationIndex,
          int? lastMovingIndex,
          int? timeNotMoving}) =>
      AlgoState(
        id: id ?? this.id,
        isMoving: isMoving ?? this.isMoving,
        lastLocationIndex: lastLocationIndex ?? this.lastLocationIndex,
        lastMovingIndex: lastMovingIndex ?? this.lastMovingIndex,
        timeNotMoving: timeNotMoving ?? this.timeNotMoving,
      );
  @override
  String toString() {
    return (StringBuffer('AlgoState(')
          ..write('id: $id, ')
          ..write('isMoving: $isMoving, ')
          ..write('lastLocationIndex: $lastLocationIndex, ')
          ..write('lastMovingIndex: $lastMovingIndex, ')
          ..write('timeNotMoving: $timeNotMoving')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, isMoving, lastLocationIndex, lastMovingIndex, timeNotMoving);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlgoState &&
          other.id == this.id &&
          other.isMoving == this.isMoving &&
          other.lastLocationIndex == this.lastLocationIndex &&
          other.lastMovingIndex == this.lastMovingIndex &&
          other.timeNotMoving == this.timeNotMoving);
}

class AlgoStatesCompanion extends UpdateCompanion<AlgoState> {
  final Value<int> id;
  final Value<bool> isMoving;
  final Value<int> lastLocationIndex;
  final Value<int> lastMovingIndex;
  final Value<int> timeNotMoving;
  const AlgoStatesCompanion({
    this.id = const Value.absent(),
    this.isMoving = const Value.absent(),
    this.lastLocationIndex = const Value.absent(),
    this.lastMovingIndex = const Value.absent(),
    this.timeNotMoving = const Value.absent(),
  });
  AlgoStatesCompanion.insert({
    this.id = const Value.absent(),
    required bool isMoving,
    required int lastLocationIndex,
    required int lastMovingIndex,
    required int timeNotMoving,
  })  : isMoving = Value(isMoving),
        lastLocationIndex = Value(lastLocationIndex),
        lastMovingIndex = Value(lastMovingIndex),
        timeNotMoving = Value(timeNotMoving);
  static Insertable<AlgoState> custom({
    Expression<int>? id,
    Expression<bool>? isMoving,
    Expression<int>? lastLocationIndex,
    Expression<int>? lastMovingIndex,
    Expression<int>? timeNotMoving,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isMoving != null) 'is_moving': isMoving,
      if (lastLocationIndex != null) 'last_location_index': lastLocationIndex,
      if (lastMovingIndex != null) 'last_moving_index': lastMovingIndex,
      if (timeNotMoving != null) 'time_not_moving': timeNotMoving,
    });
  }

  AlgoStatesCompanion copyWith(
      {Value<int>? id,
      Value<bool>? isMoving,
      Value<int>? lastLocationIndex,
      Value<int>? lastMovingIndex,
      Value<int>? timeNotMoving}) {
    return AlgoStatesCompanion(
      id: id ?? this.id,
      isMoving: isMoving ?? this.isMoving,
      lastLocationIndex: lastLocationIndex ?? this.lastLocationIndex,
      lastMovingIndex: lastMovingIndex ?? this.lastMovingIndex,
      timeNotMoving: timeNotMoving ?? this.timeNotMoving,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isMoving.present) {
      map['is_moving'] = Variable<bool>(isMoving.value);
    }
    if (lastLocationIndex.present) {
      map['last_location_index'] = Variable<int>(lastLocationIndex.value);
    }
    if (lastMovingIndex.present) {
      map['last_moving_index'] = Variable<int>(lastMovingIndex.value);
    }
    if (timeNotMoving.present) {
      map['time_not_moving'] = Variable<int>(timeNotMoving.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlgoStatesCompanion(')
          ..write('id: $id, ')
          ..write('isMoving: $isMoving, ')
          ..write('lastLocationIndex: $lastLocationIndex, ')
          ..write('lastMovingIndex: $lastMovingIndex, ')
          ..write('timeNotMoving: $timeNotMoving')
          ..write(')'))
        .toString();
  }
}

class $AlgoStatesTable extends AlgoStates
    with TableInfo<$AlgoStatesTable, AlgoState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlgoStatesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _isMovingMeta = const VerificationMeta('isMoving');
  @override
  late final GeneratedColumn<bool?> isMoving = GeneratedColumn<bool?>(
      'is_moving', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_moving IN (0, 1))');
  final VerificationMeta _lastLocationIndexMeta =
      const VerificationMeta('lastLocationIndex');
  @override
  late final GeneratedColumn<int?> lastLocationIndex = GeneratedColumn<int?>(
      'last_location_index', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastMovingIndexMeta =
      const VerificationMeta('lastMovingIndex');
  @override
  late final GeneratedColumn<int?> lastMovingIndex = GeneratedColumn<int?>(
      'last_moving_index', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _timeNotMovingMeta =
      const VerificationMeta('timeNotMoving');
  @override
  late final GeneratedColumn<int?> timeNotMoving = GeneratedColumn<int?>(
      'time_not_moving', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, isMoving, lastLocationIndex, lastMovingIndex, timeNotMoving];
  @override
  String get aliasedName => _alias ?? 'algo_states';
  @override
  String get actualTableName => 'algo_states';
  @override
  VerificationContext validateIntegrity(Insertable<AlgoState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_moving')) {
      context.handle(_isMovingMeta,
          isMoving.isAcceptableOrUnknown(data['is_moving']!, _isMovingMeta));
    } else if (isInserting) {
      context.missing(_isMovingMeta);
    }
    if (data.containsKey('last_location_index')) {
      context.handle(
          _lastLocationIndexMeta,
          lastLocationIndex.isAcceptableOrUnknown(
              data['last_location_index']!, _lastLocationIndexMeta));
    } else if (isInserting) {
      context.missing(_lastLocationIndexMeta);
    }
    if (data.containsKey('last_moving_index')) {
      context.handle(
          _lastMovingIndexMeta,
          lastMovingIndex.isAcceptableOrUnknown(
              data['last_moving_index']!, _lastMovingIndexMeta));
    } else if (isInserting) {
      context.missing(_lastMovingIndexMeta);
    }
    if (data.containsKey('time_not_moving')) {
      context.handle(
          _timeNotMovingMeta,
          timeNotMoving.isAcceptableOrUnknown(
              data['time_not_moving']!, _timeNotMovingMeta));
    } else if (isInserting) {
      context.missing(_timeNotMovingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlgoState map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AlgoState.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AlgoStatesTable createAlias(String alias) {
    return $AlgoStatesTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final int id;
  final int? trackedLocationId;
  final int? trackedMovementId;
  final double lon;
  final double lat;
  final double altitude;
  final String sensorType;
  final String uuid;
  final int date;
  final bool? isMoving;
  final bool synced;
  Location(
      {required this.id,
      this.trackedLocationId,
      this.trackedMovementId,
      required this.lon,
      required this.lat,
      required this.altitude,
      required this.sensorType,
      required this.uuid,
      required this.date,
      this.isMoving,
      required this.synced});
  factory Location.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Location(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      trackedLocationId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}tracked_location_id']),
      trackedMovementId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}tracked_movement_id']),
      lon: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lon'])!,
      lat: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lat'])!,
      altitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}altitude'])!,
      sensorType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sensor_type'])!,
      uuid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uuid'])!,
      date: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      isMoving: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_moving']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || trackedLocationId != null) {
      map['tracked_location_id'] = Variable<int?>(trackedLocationId);
    }
    if (!nullToAbsent || trackedMovementId != null) {
      map['tracked_movement_id'] = Variable<int?>(trackedMovementId);
    }
    map['lon'] = Variable<double>(lon);
    map['lat'] = Variable<double>(lat);
    map['altitude'] = Variable<double>(altitude);
    map['sensor_type'] = Variable<String>(sensorType);
    map['uuid'] = Variable<String>(uuid);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || isMoving != null) {
      map['is_moving'] = Variable<bool?>(isMoving);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      trackedLocationId: trackedLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(trackedLocationId),
      trackedMovementId: trackedMovementId == null && nullToAbsent
          ? const Value.absent()
          : Value(trackedMovementId),
      lon: Value(lon),
      lat: Value(lat),
      altitude: Value(altitude),
      sensorType: Value(sensorType),
      uuid: Value(uuid),
      date: Value(date),
      isMoving: isMoving == null && nullToAbsent
          ? const Value.absent()
          : Value(isMoving),
      synced: Value(synced),
    );
  }

  factory Location.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<int>(json['id']),
      trackedLocationId: serializer.fromJson<int?>(json['trackedLocationId']),
      trackedMovementId: serializer.fromJson<int?>(json['trackedMovementId']),
      lon: serializer.fromJson<double>(json['lon']),
      lat: serializer.fromJson<double>(json['lat']),
      altitude: serializer.fromJson<double>(json['altitude']),
      sensorType: serializer.fromJson<String>(json['sensorType']),
      uuid: serializer.fromJson<String>(json['uuid']),
      date: serializer.fromJson<int>(json['date']),
      isMoving: serializer.fromJson<bool?>(json['isMoving']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackedLocationId': serializer.toJson<int?>(trackedLocationId),
      'trackedMovementId': serializer.toJson<int?>(trackedMovementId),
      'lon': serializer.toJson<double>(lon),
      'lat': serializer.toJson<double>(lat),
      'altitude': serializer.toJson<double>(altitude),
      'sensorType': serializer.toJson<String>(sensorType),
      'uuid': serializer.toJson<String>(uuid),
      'date': serializer.toJson<int>(date),
      'isMoving': serializer.toJson<bool?>(isMoving),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Location copyWith(
          {int? id,
          int? trackedLocationId,
          int? trackedMovementId,
          double? lon,
          double? lat,
          double? altitude,
          String? sensorType,
          String? uuid,
          int? date,
          bool? isMoving,
          bool? synced}) =>
      Location(
        id: id ?? this.id,
        trackedLocationId: trackedLocationId ?? this.trackedLocationId,
        trackedMovementId: trackedMovementId ?? this.trackedMovementId,
        lon: lon ?? this.lon,
        lat: lat ?? this.lat,
        altitude: altitude ?? this.altitude,
        sensorType: sensorType ?? this.sensorType,
        uuid: uuid ?? this.uuid,
        date: date ?? this.date,
        isMoving: isMoving ?? this.isMoving,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('trackedLocationId: $trackedLocationId, ')
          ..write('trackedMovementId: $trackedMovementId, ')
          ..write('lon: $lon, ')
          ..write('lat: $lat, ')
          ..write('altitude: $altitude, ')
          ..write('sensorType: $sensorType, ')
          ..write('uuid: $uuid, ')
          ..write('date: $date, ')
          ..write('isMoving: $isMoving, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackedLocationId, trackedMovementId, lon,
      lat, altitude, sensorType, uuid, date, isMoving, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.trackedLocationId == this.trackedLocationId &&
          other.trackedMovementId == this.trackedMovementId &&
          other.lon == this.lon &&
          other.lat == this.lat &&
          other.altitude == this.altitude &&
          other.sensorType == this.sensorType &&
          other.uuid == this.uuid &&
          other.date == this.date &&
          other.isMoving == this.isMoving &&
          other.synced == this.synced);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int> id;
  final Value<int?> trackedLocationId;
  final Value<int?> trackedMovementId;
  final Value<double> lon;
  final Value<double> lat;
  final Value<double> altitude;
  final Value<String> sensorType;
  final Value<String> uuid;
  final Value<int> date;
  final Value<bool?> isMoving;
  final Value<bool> synced;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.trackedLocationId = const Value.absent(),
    this.trackedMovementId = const Value.absent(),
    this.lon = const Value.absent(),
    this.lat = const Value.absent(),
    this.altitude = const Value.absent(),
    this.sensorType = const Value.absent(),
    this.uuid = const Value.absent(),
    this.date = const Value.absent(),
    this.isMoving = const Value.absent(),
    this.synced = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    this.trackedLocationId = const Value.absent(),
    this.trackedMovementId = const Value.absent(),
    required double lon,
    required double lat,
    required double altitude,
    required String sensorType,
    required String uuid,
    required int date,
    this.isMoving = const Value.absent(),
    this.synced = const Value.absent(),
  })  : lon = Value(lon),
        lat = Value(lat),
        altitude = Value(altitude),
        sensorType = Value(sensorType),
        uuid = Value(uuid),
        date = Value(date);
  static Insertable<Location> custom({
    Expression<int>? id,
    Expression<int?>? trackedLocationId,
    Expression<int?>? trackedMovementId,
    Expression<double>? lon,
    Expression<double>? lat,
    Expression<double>? altitude,
    Expression<String>? sensorType,
    Expression<String>? uuid,
    Expression<int>? date,
    Expression<bool?>? isMoving,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackedLocationId != null) 'tracked_location_id': trackedLocationId,
      if (trackedMovementId != null) 'tracked_movement_id': trackedMovementId,
      if (lon != null) 'lon': lon,
      if (lat != null) 'lat': lat,
      if (altitude != null) 'altitude': altitude,
      if (sensorType != null) 'sensor_type': sensorType,
      if (uuid != null) 'uuid': uuid,
      if (date != null) 'date': date,
      if (isMoving != null) 'is_moving': isMoving,
      if (synced != null) 'synced': synced,
    });
  }

  LocationsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? trackedLocationId,
      Value<int?>? trackedMovementId,
      Value<double>? lon,
      Value<double>? lat,
      Value<double>? altitude,
      Value<String>? sensorType,
      Value<String>? uuid,
      Value<int>? date,
      Value<bool?>? isMoving,
      Value<bool>? synced}) {
    return LocationsCompanion(
      id: id ?? this.id,
      trackedLocationId: trackedLocationId ?? this.trackedLocationId,
      trackedMovementId: trackedMovementId ?? this.trackedMovementId,
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
      altitude: altitude ?? this.altitude,
      sensorType: sensorType ?? this.sensorType,
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      isMoving: isMoving ?? this.isMoving,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackedLocationId.present) {
      map['tracked_location_id'] = Variable<int?>(trackedLocationId.value);
    }
    if (trackedMovementId.present) {
      map['tracked_movement_id'] = Variable<int?>(trackedMovementId.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (sensorType.present) {
      map['sensor_type'] = Variable<String>(sensorType.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (isMoving.present) {
      map['is_moving'] = Variable<bool?>(isMoving.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('trackedLocationId: $trackedLocationId, ')
          ..write('trackedMovementId: $trackedMovementId, ')
          ..write('lon: $lon, ')
          ..write('lat: $lat, ')
          ..write('altitude: $altitude, ')
          ..write('sensorType: $sensorType, ')
          ..write('uuid: $uuid, ')
          ..write('date: $date, ')
          ..write('isMoving: $isMoving, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _trackedLocationIdMeta =
      const VerificationMeta('trackedLocationId');
  @override
  late final GeneratedColumn<int?> trackedLocationId = GeneratedColumn<int?>(
      'tracked_location_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _trackedMovementIdMeta =
      const VerificationMeta('trackedMovementId');
  @override
  late final GeneratedColumn<int?> trackedMovementId = GeneratedColumn<int?>(
      'tracked_movement_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double?> lon = GeneratedColumn<double?>(
      'lon', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double?> lat = GeneratedColumn<double?>(
      'lat', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _altitudeMeta = const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double?> altitude = GeneratedColumn<double?>(
      'altitude', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _sensorTypeMeta = const VerificationMeta('sensorType');
  @override
  late final GeneratedColumn<String?> sensorType = GeneratedColumn<String?>(
      'sensor_type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String?> uuid = GeneratedColumn<String?>(
      'uuid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int?> date = GeneratedColumn<int?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _isMovingMeta = const VerificationMeta('isMoving');
  @override
  late final GeneratedColumn<bool?> isMoving = GeneratedColumn<bool?>(
      'is_moving', aliasedName, true,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_moving IN (0, 1))');
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        trackedLocationId,
        trackedMovementId,
        lon,
        lat,
        altitude,
        sensorType,
        uuid,
        date,
        isMoving,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'locations';
  @override
  String get actualTableName => 'locations';
  @override
  VerificationContext validateIntegrity(Insertable<Location> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracked_location_id')) {
      context.handle(
          _trackedLocationIdMeta,
          trackedLocationId.isAcceptableOrUnknown(
              data['tracked_location_id']!, _trackedLocationIdMeta));
    }
    if (data.containsKey('tracked_movement_id')) {
      context.handle(
          _trackedMovementIdMeta,
          trackedMovementId.isAcceptableOrUnknown(
              data['tracked_movement_id']!, _trackedMovementIdMeta));
    }
    if (data.containsKey('lon')) {
      context.handle(
          _lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    } else if (isInserting) {
      context.missing(_altitudeMeta);
    }
    if (data.containsKey('sensor_type')) {
      context.handle(
          _sensorTypeMeta,
          sensorType.isAcceptableOrUnknown(
              data['sensor_type']!, _sensorTypeMeta));
    } else if (isInserting) {
      context.missing(_sensorTypeMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_moving')) {
      context.handle(_isMovingMeta,
          isMoving.isAcceptableOrUnknown(data['is_moving']!, _isMovingMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Location.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Token extends DataClass implements Insertable<Token> {
  final int? id;
  final String authToken;
  Token({this.id, required this.authToken});
  factory Token.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Token(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      authToken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}auth_token'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    map['auth_token'] = Variable<String>(authToken);
    return map;
  }

  TokensCompanion toCompanion(bool nullToAbsent) {
    return TokensCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      authToken: Value(authToken),
    );
  }

  factory Token.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Token(
      id: serializer.fromJson<int?>(json['id']),
      authToken: serializer.fromJson<String>(json['authToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'authToken': serializer.toJson<String>(authToken),
    };
  }

  Token copyWith({int? id, String? authToken}) => Token(
        id: id ?? this.id,
        authToken: authToken ?? this.authToken,
      );
  @override
  String toString() {
    return (StringBuffer('Token(')
          ..write('id: $id, ')
          ..write('authToken: $authToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, authToken);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Token &&
          other.id == this.id &&
          other.authToken == this.authToken);
}

class TokensCompanion extends UpdateCompanion<Token> {
  final Value<int?> id;
  final Value<String> authToken;
  const TokensCompanion({
    this.id = const Value.absent(),
    this.authToken = const Value.absent(),
  });
  TokensCompanion.insert({
    this.id = const Value.absent(),
    required String authToken,
  }) : authToken = Value(authToken);
  static Insertable<Token> custom({
    Expression<int?>? id,
    Expression<String>? authToken,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authToken != null) 'auth_token': authToken,
    });
  }

  TokensCompanion copyWith({Value<int?>? id, Value<String>? authToken}) {
    return TokensCompanion(
      id: id ?? this.id,
      authToken: authToken ?? this.authToken,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (authToken.present) {
      map['auth_token'] = Variable<String>(authToken.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokensCompanion(')
          ..write('id: $id, ')
          ..write('authToken: $authToken')
          ..write(')'))
        .toString();
  }
}

class $TokensTable extends Tokens with TableInfo<$TokensTable, Token> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TokensTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _authTokenMeta = const VerificationMeta('authToken');
  @override
  late final GeneratedColumn<String?> authToken = GeneratedColumn<String?>(
      'auth_token', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, authToken];
  @override
  String get aliasedName => _alias ?? 'tokens';
  @override
  String get actualTableName => 'tokens';
  @override
  VerificationContext validateIntegrity(Insertable<Token> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('auth_token')) {
      context.handle(_authTokenMeta,
          authToken.isAcceptableOrUnknown(data['auth_token']!, _authTokenMeta));
    } else if (isInserting) {
      context.missing(_authTokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Token map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Token.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TokensTable createAlias(String alias) {
    return $TokensTable(attachedDatabase, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TrackedDaysTable trackedDays = $TrackedDaysTable(this);
  late final $ClassifiedPeriodsTable classifiedPeriods =
      $ClassifiedPeriodsTable(this);
  late final $ManualGeolocationsTable manualGeolocations =
      $ManualGeolocationsTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $MovementsTable movements = $MovementsTable(this);
  late final $ReasonsTable reasons = $ReasonsTable(this);
  late final $SensorGeolocationsTable sensorGeolocations =
      $SensorGeolocationsTable(this);
  late final $GoogleMapsDatasTable googleMapsDatas =
      $GoogleMapsDatasTable(this);
  late final $StopsTable stops = $StopsTable(this);
  late final $TrackedLocationsTable trackedLocations =
      $TrackedLocationsTable(this);
  late final $TrackedMovementsTable trackedMovements =
      $TrackedMovementsTable(this);
  late final $TrackedMovementLatLngsTable trackedMovementLatLngs =
      $TrackedMovementLatLngsTable(this);
  late final $AlgoStatesTable algoStates = $AlgoStatesTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $TokensTable tokens = $TokensTable(this);
  late final TrackedDaysDao trackedDaysDao = TrackedDaysDao(this as Database);
  late final TrackedLocationsDao trackedLocationsDao =
      TrackedLocationsDao(this as Database);
  late final TrackedMovementsDao trackedMovementsDao =
      TrackedMovementsDao(this as Database);
  late final TrackedMovementLatLngsDao trackedMovementLatLngsDao =
      TrackedMovementLatLngsDao(this as Database);
  late final AlgoStatesDao algoStatesDao = AlgoStatesDao(this as Database);
  late final LocationsDao locationsDao = LocationsDao(this as Database);
  late final TokensDao tokensDao = TokensDao(this as Database);
  late final SensorGeolocationDao sensorGeolocationDao =
      SensorGeolocationDao(this as Database);
  late final ManualGeolocationDao manualGeolocationDao =
      ManualGeolocationDao(this as Database);
  late final ClassifiedPeriodDao classifiedPeriodDao =
      ClassifiedPeriodDao(this as Database);
  late final TrackedDayDao trackedDayDao = TrackedDayDao(this as Database);
  late final UserUpdateDao userUpdateDao = UserUpdateDao(this as Database);
  late final ClassifiedPeriodDtoDao classifiedPeriodDtoDao =
      ClassifiedPeriodDtoDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        trackedDays,
        classifiedPeriods,
        manualGeolocations,
        vehicles,
        movements,
        reasons,
        sensorGeolocations,
        googleMapsDatas,
        stops,
        trackedLocations,
        trackedMovements,
        trackedMovementLatLngs,
        algoStates,
        locations,
        tokens
      ];
}
