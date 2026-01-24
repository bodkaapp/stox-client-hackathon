// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_schema.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealPlanCollectionCollection on Isar {
  IsarCollection<MealPlanCollection> get mealPlanCollections =>
      this.collection();
}

const MealPlanCollectionSchema = CollectionSchema(
  name: r'MealPlanCollection',
  id: -1506918564815626909,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'isDone': PropertySchema(
      id: 1,
      name: r'isDone',
      type: IsarType.bool,
    ),
    r'mealType': PropertySchema(
      id: 2,
      name: r'mealType',
      type: IsarType.byte,
      enumMap: _MealPlanCollectionmealTypeEnumValueMap,
    ),
    r'originalId': PropertySchema(
      id: 3,
      name: r'originalId',
      type: IsarType.string,
    ),
    r'recipeId': PropertySchema(
      id: 4,
      name: r'recipeId',
      type: IsarType.string,
    )
  },
  estimateSize: _mealPlanCollectionEstimateSize,
  serialize: _mealPlanCollectionSerialize,
  deserialize: _mealPlanCollectionDeserialize,
  deserializeProp: _mealPlanCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'originalId': IndexSchema(
      id: -8365773424467627071,
      name: r'originalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'originalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'recipeId': IndexSchema(
      id: 7223263824597846537,
      name: r'recipeId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'recipeId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mealPlanCollectionGetId,
  getLinks: _mealPlanCollectionGetLinks,
  attach: _mealPlanCollectionAttach,
  version: '3.1.0+1',
);

int _mealPlanCollectionEstimateSize(
  MealPlanCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.originalId.length * 3;
  bytesCount += 3 + object.recipeId.length * 3;
  return bytesCount;
}

void _mealPlanCollectionSerialize(
  MealPlanCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeBool(offsets[1], object.isDone);
  writer.writeByte(offsets[2], object.mealType.index);
  writer.writeString(offsets[3], object.originalId);
  writer.writeString(offsets[4], object.recipeId);
}

MealPlanCollection _mealPlanCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealPlanCollection();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isDone = reader.readBool(offsets[1]);
  object.mealType = _MealPlanCollectionmealTypeValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      MealTypeSchema.breakfast;
  object.originalId = reader.readString(offsets[3]);
  object.recipeId = reader.readString(offsets[4]);
  return object;
}

P _mealPlanCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (_MealPlanCollectionmealTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MealTypeSchema.breakfast) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MealPlanCollectionmealTypeEnumValueMap = {
  'breakfast': 0,
  'lunch': 1,
  'dinner': 2,
  'snack': 3,
  'preMade': 4,
  'other': 5,
};
const _MealPlanCollectionmealTypeValueEnumMap = {
  0: MealTypeSchema.breakfast,
  1: MealTypeSchema.lunch,
  2: MealTypeSchema.dinner,
  3: MealTypeSchema.snack,
  4: MealTypeSchema.preMade,
  5: MealTypeSchema.other,
};

Id _mealPlanCollectionGetId(MealPlanCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealPlanCollectionGetLinks(
    MealPlanCollection object) {
  return [];
}

void _mealPlanCollectionAttach(
    IsarCollection<dynamic> col, Id id, MealPlanCollection object) {
  object.id = id;
}

extension MealPlanCollectionQueryWhereSort
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QWhere> {
  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealPlanCollectionQueryWhere
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QWhereClause> {
  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      originalIdEqualTo(String originalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'originalId',
        value: [originalId],
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      originalIdNotEqualTo(String originalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalId',
              lower: [],
              upper: [originalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalId',
              lower: [originalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalId',
              lower: [originalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalId',
              lower: [],
              upper: [originalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      recipeIdEqualTo(String recipeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'recipeId',
        value: [recipeId],
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterWhereClause>
      recipeIdNotEqualTo(String recipeId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recipeId',
              lower: [],
              upper: [recipeId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recipeId',
              lower: [recipeId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recipeId',
              lower: [recipeId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recipeId',
              lower: [],
              upper: [recipeId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MealPlanCollectionQueryFilter
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QFilterCondition> {
  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      isDoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDone',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      mealTypeEqualTo(MealTypeSchema value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      mealTypeGreaterThan(
    MealTypeSchema value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      mealTypeLessThan(
    MealTypeSchema value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      mealTypeBetween(
    MealTypeSchema lower,
    MealTypeSchema upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      originalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipeId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterFilterCondition>
      recipeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipeId',
        value: '',
      ));
    });
  }
}

extension MealPlanCollectionQueryObject
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QFilterCondition> {}

extension MealPlanCollectionQueryLinks
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QFilterCondition> {}

extension MealPlanCollectionQuerySortBy
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QSortBy> {
  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByIsDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByOriginalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByOriginalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByRecipeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      sortByRecipeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeId', Sort.desc);
    });
  }
}

extension MealPlanCollectionQuerySortThenBy
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QSortThenBy> {
  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByIsDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByOriginalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByOriginalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByRecipeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QAfterSortBy>
      thenByRecipeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeId', Sort.desc);
    });
  }
}

extension MealPlanCollectionQueryWhereDistinct
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QDistinct> {
  QueryBuilder<MealPlanCollection, MealPlanCollection, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QDistinct>
      distinctByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDone');
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QDistinct>
      distinctByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealType');
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QDistinct>
      distinctByOriginalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCollection, MealPlanCollection, QDistinct>
      distinctByRecipeId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipeId', caseSensitive: caseSensitive);
    });
  }
}

extension MealPlanCollectionQueryProperty
    on QueryBuilder<MealPlanCollection, MealPlanCollection, QQueryProperty> {
  QueryBuilder<MealPlanCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealPlanCollection, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MealPlanCollection, bool, QQueryOperations> isDoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDone');
    });
  }

  QueryBuilder<MealPlanCollection, MealTypeSchema, QQueryOperations>
      mealTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealType');
    });
  }

  QueryBuilder<MealPlanCollection, String, QQueryOperations>
      originalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalId');
    });
  }

  QueryBuilder<MealPlanCollection, String, QQueryOperations>
      recipeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipeId');
    });
  }
}
