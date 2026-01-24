// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_schema.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecipeCollectionCollection on Isar {
  IsarCollection<RecipeCollection> get recipeCollections => this.collection();
}

const RecipeCollectionSchema = CollectionSchema(
  name: r'RecipeCollection',
  id: 1422789349022057918,
  properties: {
    r'cookedCount': PropertySchema(
      id: 0,
      name: r'cookedCount',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'defaultServings': PropertySchema(
      id: 2,
      name: r'defaultServings',
      type: IsarType.long,
    ),
    r'isDeleted': PropertySchema(
      id: 3,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'lastCookedAt': PropertySchema(
      id: 4,
      name: r'lastCookedAt',
      type: IsarType.dateTime,
    ),
    r'memo': PropertySchema(
      id: 5,
      name: r'memo',
      type: IsarType.string,
    ),
    r'ogpImageUrl': PropertySchema(
      id: 6,
      name: r'ogpImageUrl',
      type: IsarType.string,
    ),
    r'originalId': PropertySchema(
      id: 7,
      name: r'originalId',
      type: IsarType.string,
    ),
    r'pageUrl': PropertySchema(
      id: 8,
      name: r'pageUrl',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 9,
      name: r'rating',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 10,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _recipeCollectionEstimateSize,
  serialize: _recipeCollectionSerialize,
  deserialize: _recipeCollectionDeserialize,
  deserializeProp: _recipeCollectionDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recipeCollectionGetId,
  getLinks: _recipeCollectionGetLinks,
  attach: _recipeCollectionAttach,
  version: '3.1.0+1',
);

int _recipeCollectionEstimateSize(
  RecipeCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.memo.length * 3;
  bytesCount += 3 + object.ogpImageUrl.length * 3;
  bytesCount += 3 + object.originalId.length * 3;
  bytesCount += 3 + object.pageUrl.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _recipeCollectionSerialize(
  RecipeCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cookedCount);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.defaultServings);
  writer.writeBool(offsets[3], object.isDeleted);
  writer.writeDateTime(offsets[4], object.lastCookedAt);
  writer.writeString(offsets[5], object.memo);
  writer.writeString(offsets[6], object.ogpImageUrl);
  writer.writeString(offsets[7], object.originalId);
  writer.writeString(offsets[8], object.pageUrl);
  writer.writeLong(offsets[9], object.rating);
  writer.writeString(offsets[10], object.title);
}

RecipeCollection _recipeCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecipeCollection();
  object.cookedCount = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.defaultServings = reader.readLong(offsets[2]);
  object.id = id;
  object.isDeleted = reader.readBool(offsets[3]);
  object.lastCookedAt = reader.readDateTimeOrNull(offsets[4]);
  object.memo = reader.readString(offsets[5]);
  object.ogpImageUrl = reader.readString(offsets[6]);
  object.originalId = reader.readString(offsets[7]);
  object.pageUrl = reader.readString(offsets[8]);
  object.rating = reader.readLong(offsets[9]);
  object.title = reader.readString(offsets[10]);
  return object;
}

P _recipeCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recipeCollectionGetId(RecipeCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recipeCollectionGetLinks(RecipeCollection object) {
  return [];
}

void _recipeCollectionAttach(
    IsarCollection<dynamic> col, Id id, RecipeCollection object) {
  object.id = id;
}

extension RecipeCollectionQueryWhereSort
    on QueryBuilder<RecipeCollection, RecipeCollection, QWhere> {
  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecipeCollectionQueryWhere
    on QueryBuilder<RecipeCollection, RecipeCollection, QWhereClause> {
  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause>
      originalIdEqualTo(String originalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'originalId',
        value: [originalId],
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterWhereClause>
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
}

extension RecipeCollectionQueryFilter
    on QueryBuilder<RecipeCollection, RecipeCollection, QFilterCondition> {
  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      cookedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cookedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      cookedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cookedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      cookedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cookedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      cookedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cookedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      defaultServingsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultServings',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      defaultServingsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultServings',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      defaultServingsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultServings',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      defaultServingsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultServings',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      lastCookedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCookedAt',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      lastCookedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCookedAt',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      lastCookedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCookedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      lastCookedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCookedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      lastCookedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCookedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      lastCookedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCookedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'memo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      memoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ogpImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ogpImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ogpImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ogpImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ogpImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ogpImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ogpImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ogpImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ogpImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ogpImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ogpImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
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

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      originalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      originalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      originalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalId',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      originalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalId',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      pageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ratingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ratingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ratingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      ratingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension RecipeCollectionQueryObject
    on QueryBuilder<RecipeCollection, RecipeCollection, QFilterCondition> {}

extension RecipeCollectionQueryLinks
    on QueryBuilder<RecipeCollection, RecipeCollection, QFilterCondition> {}

extension RecipeCollectionQuerySortBy
    on QueryBuilder<RecipeCollection, RecipeCollection, QSortBy> {
  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByCookedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookedCount', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByCookedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookedCount', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByDefaultServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultServings', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByDefaultServingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultServings', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByLastCookedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCookedAt', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByLastCookedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCookedAt', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy> sortByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByOgpImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ogpImageUrl', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByOgpImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ogpImageUrl', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByOriginalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByOriginalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByPageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageUrl', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByPageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageUrl', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension RecipeCollectionQuerySortThenBy
    on QueryBuilder<RecipeCollection, RecipeCollection, QSortThenBy> {
  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByCookedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookedCount', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByCookedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookedCount', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByDefaultServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultServings', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByDefaultServingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultServings', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByLastCookedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCookedAt', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByLastCookedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCookedAt', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy> thenByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByOgpImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ogpImageUrl', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByOgpImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ogpImageUrl', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByOriginalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByOriginalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByPageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageUrl', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByPageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageUrl', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension RecipeCollectionQueryWhereDistinct
    on QueryBuilder<RecipeCollection, RecipeCollection, QDistinct> {
  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByCookedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cookedCount');
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByDefaultServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultServings');
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByLastCookedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCookedAt');
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct> distinctByMemo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByOgpImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ogpImageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByOriginalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct> distinctByPageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct>
      distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<RecipeCollection, RecipeCollection, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension RecipeCollectionQueryProperty
    on QueryBuilder<RecipeCollection, RecipeCollection, QQueryProperty> {
  QueryBuilder<RecipeCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecipeCollection, int, QQueryOperations> cookedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cookedCount');
    });
  }

  QueryBuilder<RecipeCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RecipeCollection, int, QQueryOperations>
      defaultServingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultServings');
    });
  }

  QueryBuilder<RecipeCollection, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<RecipeCollection, DateTime?, QQueryOperations>
      lastCookedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCookedAt');
    });
  }

  QueryBuilder<RecipeCollection, String, QQueryOperations> memoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memo');
    });
  }

  QueryBuilder<RecipeCollection, String, QQueryOperations>
      ogpImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ogpImageUrl');
    });
  }

  QueryBuilder<RecipeCollection, String, QQueryOperations>
      originalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalId');
    });
  }

  QueryBuilder<RecipeCollection, String, QQueryOperations> pageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageUrl');
    });
  }

  QueryBuilder<RecipeCollection, int, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<RecipeCollection, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
