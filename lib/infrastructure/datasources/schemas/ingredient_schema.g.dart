// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_schema.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIngredientCollectionCollection on Isar {
  IsarCollection<IngredientCollection> get ingredientCollections =>
      this.collection();
}

const IngredientCollectionSchema = CollectionSchema(
  name: r'IngredientCollection',
  id: 8061128794646135436,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'consumedAt': PropertySchema(
      id: 2,
      name: r'consumedAt',
      type: IsarType.dateTime,
    ),
    r'expiryDate': PropertySchema(
      id: 3,
      name: r'expiryDate',
      type: IsarType.dateTime,
    ),
    r'isEssential': PropertySchema(
      id: 4,
      name: r'isEssential',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'originalId': PropertySchema(
      id: 6,
      name: r'originalId',
      type: IsarType.string,
    ),
    r'purchaseDate': PropertySchema(
      id: 7,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'standardName': PropertySchema(
      id: 8,
      name: r'standardName',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _IngredientCollectionstatusEnumValueMap,
    ),
    r'storageType': PropertySchema(
      id: 10,
      name: r'storageType',
      type: IsarType.byte,
      enumMap: _IngredientCollectionstorageTypeEnumValueMap,
    ),
    r'unit': PropertySchema(
      id: 11,
      name: r'unit',
      type: IsarType.string,
    )
  },
  estimateSize: _ingredientCollectionEstimateSize,
  serialize: _ingredientCollectionSerialize,
  deserialize: _ingredientCollectionDeserialize,
  deserializeProp: _ingredientCollectionDeserializeProp,
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
  getId: _ingredientCollectionGetId,
  getLinks: _ingredientCollectionGetLinks,
  attach: _ingredientCollectionAttach,
  version: '3.1.0+1',
);

int _ingredientCollectionEstimateSize(
  IngredientCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.originalId.length * 3;
  bytesCount += 3 + object.standardName.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _ingredientCollectionSerialize(
  IngredientCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.category);
  writer.writeDateTime(offsets[2], object.consumedAt);
  writer.writeDateTime(offsets[3], object.expiryDate);
  writer.writeBool(offsets[4], object.isEssential);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.originalId);
  writer.writeDateTime(offsets[7], object.purchaseDate);
  writer.writeString(offsets[8], object.standardName);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeByte(offsets[10], object.storageType.index);
  writer.writeString(offsets[11], object.unit);
}

IngredientCollection _ingredientCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IngredientCollection();
  object.amount = reader.readDouble(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.consumedAt = reader.readDateTimeOrNull(offsets[2]);
  object.expiryDate = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  object.isEssential = reader.readBool(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.originalId = reader.readString(offsets[6]);
  object.purchaseDate = reader.readDateTimeOrNull(offsets[7]);
  object.standardName = reader.readString(offsets[8]);
  object.status = _IngredientCollectionstatusValueEnumMap[
          reader.readByteOrNull(offsets[9])] ??
      IngredientStatusSchema.toBuy;
  object.storageType = _IngredientCollectionstorageTypeValueEnumMap[
          reader.readByteOrNull(offsets[10])] ??
      StorageTypeSchema.fridge;
  object.unit = reader.readString(offsets[11]);
  return object;
}

P _ingredientCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (_IngredientCollectionstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          IngredientStatusSchema.toBuy) as P;
    case 10:
      return (_IngredientCollectionstorageTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          StorageTypeSchema.fridge) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _IngredientCollectionstatusEnumValueMap = {
  'toBuy': 0,
  'inCart': 1,
  'stock': 2,
};
const _IngredientCollectionstatusValueEnumMap = {
  0: IngredientStatusSchema.toBuy,
  1: IngredientStatusSchema.inCart,
  2: IngredientStatusSchema.stock,
};
const _IngredientCollectionstorageTypeEnumValueMap = {
  'fridge': 0,
  'freezer': 1,
  'room': 2,
  'unknown': 3,
};
const _IngredientCollectionstorageTypeValueEnumMap = {
  0: StorageTypeSchema.fridge,
  1: StorageTypeSchema.freezer,
  2: StorageTypeSchema.room,
  3: StorageTypeSchema.unknown,
};

Id _ingredientCollectionGetId(IngredientCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ingredientCollectionGetLinks(
    IngredientCollection object) {
  return [];
}

void _ingredientCollectionAttach(
    IsarCollection<dynamic> col, Id id, IngredientCollection object) {
  object.id = id;
}

extension IngredientCollectionQueryWhereSort
    on QueryBuilder<IngredientCollection, IngredientCollection, QWhere> {
  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IngredientCollectionQueryWhere
    on QueryBuilder<IngredientCollection, IngredientCollection, QWhereClause> {
  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
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

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
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

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
      originalIdEqualTo(String originalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'originalId',
        value: [originalId],
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterWhereClause>
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

extension IngredientCollectionQueryFilter on QueryBuilder<IngredientCollection,
    IngredientCollection, QFilterCondition> {
  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> consumedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'consumedAt',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> consumedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'consumedAt',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> consumedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consumedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> consumedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consumedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> consumedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consumedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> consumedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consumedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> expiryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiryDate',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> expiryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiryDate',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> expiryDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> expiryDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> expiryDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> expiryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiryDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> isEssentialEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEssential',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdEqualTo(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdGreaterThan(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdLessThan(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdBetween(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdStartsWith(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdEndsWith(
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

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      originalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      originalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalId',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> originalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalId',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> purchaseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaseDate',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> purchaseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaseDate',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> purchaseDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> purchaseDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> purchaseDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> purchaseDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'standardName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'standardName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'standardName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'standardName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'standardName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'standardName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      standardNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'standardName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      standardNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'standardName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'standardName',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> standardNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'standardName',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> statusEqualTo(IngredientStatusSchema value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> statusGreaterThan(
    IngredientStatusSchema value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> statusLessThan(
    IngredientStatusSchema value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> statusBetween(
    IngredientStatusSchema lower,
    IngredientStatusSchema upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> storageTypeEqualTo(StorageTypeSchema value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storageType',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> storageTypeGreaterThan(
    StorageTypeSchema value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'storageType',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> storageTypeLessThan(
    StorageTypeSchema value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'storageType',
        value: value,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> storageTypeBetween(
    StorageTypeSchema lower,
    StorageTypeSchema upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'storageType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
          QAfterFilterCondition>
      unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection,
      QAfterFilterCondition> unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }
}

extension IngredientCollectionQueryObject on QueryBuilder<IngredientCollection,
    IngredientCollection, QFilterCondition> {}

extension IngredientCollectionQueryLinks on QueryBuilder<IngredientCollection,
    IngredientCollection, QFilterCondition> {}

extension IngredientCollectionQuerySortBy
    on QueryBuilder<IngredientCollection, IngredientCollection, QSortBy> {
  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByConsumedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedAt', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByConsumedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedAt', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByIsEssential() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByIsEssentialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByOriginalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByOriginalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByStandardName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardName', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByStandardNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardName', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByStorageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storageType', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByStorageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storageType', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension IngredientCollectionQuerySortThenBy
    on QueryBuilder<IngredientCollection, IngredientCollection, QSortThenBy> {
  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByConsumedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedAt', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByConsumedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedAt', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByIsEssential() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByIsEssentialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByOriginalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByOriginalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalId', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByStandardName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardName', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByStandardNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardName', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByStorageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storageType', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByStorageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storageType', Sort.desc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QAfterSortBy>
      thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension IngredientCollectionQueryWhereDistinct
    on QueryBuilder<IngredientCollection, IngredientCollection, QDistinct> {
  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByConsumedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consumedAt');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiryDate');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByIsEssential() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEssential');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByOriginalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByStandardName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'standardName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByStorageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storageType');
    });
  }

  QueryBuilder<IngredientCollection, IngredientCollection, QDistinct>
      distinctByUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }
}

extension IngredientCollectionQueryProperty on QueryBuilder<
    IngredientCollection, IngredientCollection, QQueryProperty> {
  QueryBuilder<IngredientCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IngredientCollection, double, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<IngredientCollection, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<IngredientCollection, DateTime?, QQueryOperations>
      consumedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consumedAt');
    });
  }

  QueryBuilder<IngredientCollection, DateTime?, QQueryOperations>
      expiryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiryDate');
    });
  }

  QueryBuilder<IngredientCollection, bool, QQueryOperations>
      isEssentialProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEssential');
    });
  }

  QueryBuilder<IngredientCollection, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IngredientCollection, String, QQueryOperations>
      originalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalId');
    });
  }

  QueryBuilder<IngredientCollection, DateTime?, QQueryOperations>
      purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<IngredientCollection, String, QQueryOperations>
      standardNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'standardName');
    });
  }

  QueryBuilder<IngredientCollection, IngredientStatusSchema, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<IngredientCollection, StorageTypeSchema, QQueryOperations>
      storageTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storageType');
    });
  }

  QueryBuilder<IngredientCollection, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
