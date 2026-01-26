// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes
    with TableInfo<$RecipesTable, RecipeEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalIdMeta =
      const VerificationMeta('originalId');
  @override
  late final GeneratedColumn<String> originalId = GeneratedColumn<String>(
      'original_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageUrlMeta =
      const VerificationMeta('pageUrl');
  @override
  late final GeneratedColumn<String> pageUrl = GeneratedColumn<String>(
      'page_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ogpImageUrlMeta =
      const VerificationMeta('ogpImageUrl');
  @override
  late final GeneratedColumn<String> ogpImageUrl = GeneratedColumn<String>(
      'ogp_image_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _cookedCountMeta =
      const VerificationMeta('cookedCount');
  @override
  late final GeneratedColumn<int> cookedCount = GeneratedColumn<int>(
      'cooked_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _defaultServingsMeta =
      const VerificationMeta('defaultServings');
  @override
  late final GeneratedColumn<int> defaultServings = GeneratedColumn<int>(
      'default_servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastCookedAtMeta =
      const VerificationMeta('lastCookedAt');
  @override
  late final GeneratedColumn<DateTime> lastCookedAt = GeneratedColumn<DateTime>(
      'last_cooked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalId,
        title,
        pageUrl,
        ogpImageUrl,
        createdAt,
        cookedCount,
        defaultServings,
        rating,
        lastCookedAt,
        isDeleted,
        memo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_id')) {
      context.handle(
          _originalIdMeta,
          originalId.isAcceptableOrUnknown(
              data['original_id']!, _originalIdMeta));
    } else if (isInserting) {
      context.missing(_originalIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('page_url')) {
      context.handle(_pageUrlMeta,
          pageUrl.isAcceptableOrUnknown(data['page_url']!, _pageUrlMeta));
    } else if (isInserting) {
      context.missing(_pageUrlMeta);
    }
    if (data.containsKey('ogp_image_url')) {
      context.handle(
          _ogpImageUrlMeta,
          ogpImageUrl.isAcceptableOrUnknown(
              data['ogp_image_url']!, _ogpImageUrlMeta));
    } else if (isInserting) {
      context.missing(_ogpImageUrlMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('cooked_count')) {
      context.handle(
          _cookedCountMeta,
          cookedCount.isAcceptableOrUnknown(
              data['cooked_count']!, _cookedCountMeta));
    }
    if (data.containsKey('default_servings')) {
      context.handle(
          _defaultServingsMeta,
          defaultServings.isAcceptableOrUnknown(
              data['default_servings']!, _defaultServingsMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('last_cooked_at')) {
      context.handle(
          _lastCookedAtMeta,
          lastCookedAt.isAcceptableOrUnknown(
              data['last_cooked_at']!, _lastCookedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      pageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_url'])!,
      ogpImageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ogp_image_url'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      cookedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cooked_count'])!,
      defaultServings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_servings'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      lastCookedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_cooked_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class RecipeEntity extends DataClass implements Insertable<RecipeEntity> {
  final int id;
  final String originalId;
  final String title;
  final String pageUrl;
  final String ogpImageUrl;
  final DateTime createdAt;
  final int cookedCount;
  final int defaultServings;
  final int rating;
  final DateTime? lastCookedAt;
  final bool isDeleted;
  final String memo;
  const RecipeEntity(
      {required this.id,
      required this.originalId,
      required this.title,
      required this.pageUrl,
      required this.ogpImageUrl,
      required this.createdAt,
      required this.cookedCount,
      required this.defaultServings,
      required this.rating,
      this.lastCookedAt,
      required this.isDeleted,
      required this.memo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_id'] = Variable<String>(originalId);
    map['title'] = Variable<String>(title);
    map['page_url'] = Variable<String>(pageUrl);
    map['ogp_image_url'] = Variable<String>(ogpImageUrl);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cooked_count'] = Variable<int>(cookedCount);
    map['default_servings'] = Variable<int>(defaultServings);
    map['rating'] = Variable<int>(rating);
    if (!nullToAbsent || lastCookedAt != null) {
      map['last_cooked_at'] = Variable<DateTime>(lastCookedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['memo'] = Variable<String>(memo);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      originalId: Value(originalId),
      title: Value(title),
      pageUrl: Value(pageUrl),
      ogpImageUrl: Value(ogpImageUrl),
      createdAt: Value(createdAt),
      cookedCount: Value(cookedCount),
      defaultServings: Value(defaultServings),
      rating: Value(rating),
      lastCookedAt: lastCookedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCookedAt),
      isDeleted: Value(isDeleted),
      memo: Value(memo),
    );
  }

  factory RecipeEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeEntity(
      id: serializer.fromJson<int>(json['id']),
      originalId: serializer.fromJson<String>(json['originalId']),
      title: serializer.fromJson<String>(json['title']),
      pageUrl: serializer.fromJson<String>(json['pageUrl']),
      ogpImageUrl: serializer.fromJson<String>(json['ogpImageUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cookedCount: serializer.fromJson<int>(json['cookedCount']),
      defaultServings: serializer.fromJson<int>(json['defaultServings']),
      rating: serializer.fromJson<int>(json['rating']),
      lastCookedAt: serializer.fromJson<DateTime?>(json['lastCookedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      memo: serializer.fromJson<String>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalId': serializer.toJson<String>(originalId),
      'title': serializer.toJson<String>(title),
      'pageUrl': serializer.toJson<String>(pageUrl),
      'ogpImageUrl': serializer.toJson<String>(ogpImageUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cookedCount': serializer.toJson<int>(cookedCount),
      'defaultServings': serializer.toJson<int>(defaultServings),
      'rating': serializer.toJson<int>(rating),
      'lastCookedAt': serializer.toJson<DateTime?>(lastCookedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'memo': serializer.toJson<String>(memo),
    };
  }

  RecipeEntity copyWith(
          {int? id,
          String? originalId,
          String? title,
          String? pageUrl,
          String? ogpImageUrl,
          DateTime? createdAt,
          int? cookedCount,
          int? defaultServings,
          int? rating,
          Value<DateTime?> lastCookedAt = const Value.absent(),
          bool? isDeleted,
          String? memo}) =>
      RecipeEntity(
        id: id ?? this.id,
        originalId: originalId ?? this.originalId,
        title: title ?? this.title,
        pageUrl: pageUrl ?? this.pageUrl,
        ogpImageUrl: ogpImageUrl ?? this.ogpImageUrl,
        createdAt: createdAt ?? this.createdAt,
        cookedCount: cookedCount ?? this.cookedCount,
        defaultServings: defaultServings ?? this.defaultServings,
        rating: rating ?? this.rating,
        lastCookedAt:
            lastCookedAt.present ? lastCookedAt.value : this.lastCookedAt,
        isDeleted: isDeleted ?? this.isDeleted,
        memo: memo ?? this.memo,
      );
  RecipeEntity copyWithCompanion(RecipesCompanion data) {
    return RecipeEntity(
      id: data.id.present ? data.id.value : this.id,
      originalId:
          data.originalId.present ? data.originalId.value : this.originalId,
      title: data.title.present ? data.title.value : this.title,
      pageUrl: data.pageUrl.present ? data.pageUrl.value : this.pageUrl,
      ogpImageUrl:
          data.ogpImageUrl.present ? data.ogpImageUrl.value : this.ogpImageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cookedCount:
          data.cookedCount.present ? data.cookedCount.value : this.cookedCount,
      defaultServings: data.defaultServings.present
          ? data.defaultServings.value
          : this.defaultServings,
      rating: data.rating.present ? data.rating.value : this.rating,
      lastCookedAt: data.lastCookedAt.present
          ? data.lastCookedAt.value
          : this.lastCookedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeEntity(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('title: $title, ')
          ..write('pageUrl: $pageUrl, ')
          ..write('ogpImageUrl: $ogpImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('cookedCount: $cookedCount, ')
          ..write('defaultServings: $defaultServings, ')
          ..write('rating: $rating, ')
          ..write('lastCookedAt: $lastCookedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      originalId,
      title,
      pageUrl,
      ogpImageUrl,
      createdAt,
      cookedCount,
      defaultServings,
      rating,
      lastCookedAt,
      isDeleted,
      memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeEntity &&
          other.id == this.id &&
          other.originalId == this.originalId &&
          other.title == this.title &&
          other.pageUrl == this.pageUrl &&
          other.ogpImageUrl == this.ogpImageUrl &&
          other.createdAt == this.createdAt &&
          other.cookedCount == this.cookedCount &&
          other.defaultServings == this.defaultServings &&
          other.rating == this.rating &&
          other.lastCookedAt == this.lastCookedAt &&
          other.isDeleted == this.isDeleted &&
          other.memo == this.memo);
}

class RecipesCompanion extends UpdateCompanion<RecipeEntity> {
  final Value<int> id;
  final Value<String> originalId;
  final Value<String> title;
  final Value<String> pageUrl;
  final Value<String> ogpImageUrl;
  final Value<DateTime> createdAt;
  final Value<int> cookedCount;
  final Value<int> defaultServings;
  final Value<int> rating;
  final Value<DateTime?> lastCookedAt;
  final Value<bool> isDeleted;
  final Value<String> memo;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.originalId = const Value.absent(),
    this.title = const Value.absent(),
    this.pageUrl = const Value.absent(),
    this.ogpImageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cookedCount = const Value.absent(),
    this.defaultServings = const Value.absent(),
    this.rating = const Value.absent(),
    this.lastCookedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.memo = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String originalId,
    required String title,
    required String pageUrl,
    required String ogpImageUrl,
    required DateTime createdAt,
    this.cookedCount = const Value.absent(),
    this.defaultServings = const Value.absent(),
    this.rating = const Value.absent(),
    this.lastCookedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.memo = const Value.absent(),
  })  : originalId = Value(originalId),
        title = Value(title),
        pageUrl = Value(pageUrl),
        ogpImageUrl = Value(ogpImageUrl),
        createdAt = Value(createdAt);
  static Insertable<RecipeEntity> custom({
    Expression<int>? id,
    Expression<String>? originalId,
    Expression<String>? title,
    Expression<String>? pageUrl,
    Expression<String>? ogpImageUrl,
    Expression<DateTime>? createdAt,
    Expression<int>? cookedCount,
    Expression<int>? defaultServings,
    Expression<int>? rating,
    Expression<DateTime>? lastCookedAt,
    Expression<bool>? isDeleted,
    Expression<String>? memo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalId != null) 'original_id': originalId,
      if (title != null) 'title': title,
      if (pageUrl != null) 'page_url': pageUrl,
      if (ogpImageUrl != null) 'ogp_image_url': ogpImageUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (cookedCount != null) 'cooked_count': cookedCount,
      if (defaultServings != null) 'default_servings': defaultServings,
      if (rating != null) 'rating': rating,
      if (lastCookedAt != null) 'last_cooked_at': lastCookedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (memo != null) 'memo': memo,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalId,
      Value<String>? title,
      Value<String>? pageUrl,
      Value<String>? ogpImageUrl,
      Value<DateTime>? createdAt,
      Value<int>? cookedCount,
      Value<int>? defaultServings,
      Value<int>? rating,
      Value<DateTime?>? lastCookedAt,
      Value<bool>? isDeleted,
      Value<String>? memo}) {
    return RecipesCompanion(
      id: id ?? this.id,
      originalId: originalId ?? this.originalId,
      title: title ?? this.title,
      pageUrl: pageUrl ?? this.pageUrl,
      ogpImageUrl: ogpImageUrl ?? this.ogpImageUrl,
      createdAt: createdAt ?? this.createdAt,
      cookedCount: cookedCount ?? this.cookedCount,
      defaultServings: defaultServings ?? this.defaultServings,
      rating: rating ?? this.rating,
      lastCookedAt: lastCookedAt ?? this.lastCookedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      memo: memo ?? this.memo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalId.present) {
      map['original_id'] = Variable<String>(originalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pageUrl.present) {
      map['page_url'] = Variable<String>(pageUrl.value);
    }
    if (ogpImageUrl.present) {
      map['ogp_image_url'] = Variable<String>(ogpImageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cookedCount.present) {
      map['cooked_count'] = Variable<int>(cookedCount.value);
    }
    if (defaultServings.present) {
      map['default_servings'] = Variable<int>(defaultServings.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (lastCookedAt.present) {
      map['last_cooked_at'] = Variable<DateTime>(lastCookedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('title: $title, ')
          ..write('pageUrl: $pageUrl, ')
          ..write('ogpImageUrl: $ogpImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('cookedCount: $cookedCount, ')
          ..write('defaultServings: $defaultServings, ')
          ..write('rating: $rating, ')
          ..write('lastCookedAt: $lastCookedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, IngredientEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalIdMeta =
      const VerificationMeta('originalId');
  @override
  late final GeneratedColumn<String> originalId = GeneratedColumn<String>(
      'original_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _standardNameMeta =
      const VerificationMeta('standardName');
  @override
  late final GeneratedColumn<String> standardName = GeneratedColumn<String>(
      'standard_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _storageTypeMeta =
      const VerificationMeta('storageType');
  @override
  late final GeneratedColumn<int> storageType = GeneratedColumn<int>(
      'storage_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isEssentialMeta =
      const VerificationMeta('isEssential');
  @override
  late final GeneratedColumn<bool> isEssential = GeneratedColumn<bool>(
      'is_essential', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_essential" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _consumedAtMeta =
      const VerificationMeta('consumedAt');
  @override
  late final GeneratedColumn<DateTime> consumedAt = GeneratedColumn<DateTime>(
      'consumed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalId,
        name,
        standardName,
        category,
        unit,
        status,
        storageType,
        isEssential,
        amount,
        purchaseDate,
        expiryDate,
        consumedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<IngredientEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_id')) {
      context.handle(
          _originalIdMeta,
          originalId.isAcceptableOrUnknown(
              data['original_id']!, _originalIdMeta));
    } else if (isInserting) {
      context.missing(_originalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('standard_name')) {
      context.handle(
          _standardNameMeta,
          standardName.isAcceptableOrUnknown(
              data['standard_name']!, _standardNameMeta));
    } else if (isInserting) {
      context.missing(_standardNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('storage_type')) {
      context.handle(
          _storageTypeMeta,
          storageType.isAcceptableOrUnknown(
              data['storage_type']!, _storageTypeMeta));
    } else if (isInserting) {
      context.missing(_storageTypeMeta);
    }
    if (data.containsKey('is_essential')) {
      context.handle(
          _isEssentialMeta,
          isEssential.isAcceptableOrUnknown(
              data['is_essential']!, _isEssentialMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('consumed_at')) {
      context.handle(
          _consumedAtMeta,
          consumedAt.isAcceptableOrUnknown(
              data['consumed_at']!, _consumedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      standardName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}standard_name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      storageType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}storage_type'])!,
      isEssential: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_essential'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      purchaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}purchase_date']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      consumedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}consumed_at']),
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class IngredientEntity extends DataClass
    implements Insertable<IngredientEntity> {
  final int id;
  final String originalId;
  final String name;
  final String standardName;
  final String category;
  final String unit;
  final int status;
  final int storageType;
  final bool isEssential;
  final double amount;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final DateTime? consumedAt;
  const IngredientEntity(
      {required this.id,
      required this.originalId,
      required this.name,
      required this.standardName,
      required this.category,
      required this.unit,
      required this.status,
      required this.storageType,
      required this.isEssential,
      required this.amount,
      this.purchaseDate,
      this.expiryDate,
      this.consumedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_id'] = Variable<String>(originalId);
    map['name'] = Variable<String>(name);
    map['standard_name'] = Variable<String>(standardName);
    map['category'] = Variable<String>(category);
    map['unit'] = Variable<String>(unit);
    map['status'] = Variable<int>(status);
    map['storage_type'] = Variable<int>(storageType);
    map['is_essential'] = Variable<bool>(isEssential);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || consumedAt != null) {
      map['consumed_at'] = Variable<DateTime>(consumedAt);
    }
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      originalId: Value(originalId),
      name: Value(name),
      standardName: Value(standardName),
      category: Value(category),
      unit: Value(unit),
      status: Value(status),
      storageType: Value(storageType),
      isEssential: Value(isEssential),
      amount: Value(amount),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      consumedAt: consumedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(consumedAt),
    );
  }

  factory IngredientEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientEntity(
      id: serializer.fromJson<int>(json['id']),
      originalId: serializer.fromJson<String>(json['originalId']),
      name: serializer.fromJson<String>(json['name']),
      standardName: serializer.fromJson<String>(json['standardName']),
      category: serializer.fromJson<String>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      status: serializer.fromJson<int>(json['status']),
      storageType: serializer.fromJson<int>(json['storageType']),
      isEssential: serializer.fromJson<bool>(json['isEssential']),
      amount: serializer.fromJson<double>(json['amount']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      consumedAt: serializer.fromJson<DateTime?>(json['consumedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalId': serializer.toJson<String>(originalId),
      'name': serializer.toJson<String>(name),
      'standardName': serializer.toJson<String>(standardName),
      'category': serializer.toJson<String>(category),
      'unit': serializer.toJson<String>(unit),
      'status': serializer.toJson<int>(status),
      'storageType': serializer.toJson<int>(storageType),
      'isEssential': serializer.toJson<bool>(isEssential),
      'amount': serializer.toJson<double>(amount),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'consumedAt': serializer.toJson<DateTime?>(consumedAt),
    };
  }

  IngredientEntity copyWith(
          {int? id,
          String? originalId,
          String? name,
          String? standardName,
          String? category,
          String? unit,
          int? status,
          int? storageType,
          bool? isEssential,
          double? amount,
          Value<DateTime?> purchaseDate = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<DateTime?> consumedAt = const Value.absent()}) =>
      IngredientEntity(
        id: id ?? this.id,
        originalId: originalId ?? this.originalId,
        name: name ?? this.name,
        standardName: standardName ?? this.standardName,
        category: category ?? this.category,
        unit: unit ?? this.unit,
        status: status ?? this.status,
        storageType: storageType ?? this.storageType,
        isEssential: isEssential ?? this.isEssential,
        amount: amount ?? this.amount,
        purchaseDate:
            purchaseDate.present ? purchaseDate.value : this.purchaseDate,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        consumedAt: consumedAt.present ? consumedAt.value : this.consumedAt,
      );
  IngredientEntity copyWithCompanion(IngredientsCompanion data) {
    return IngredientEntity(
      id: data.id.present ? data.id.value : this.id,
      originalId:
          data.originalId.present ? data.originalId.value : this.originalId,
      name: data.name.present ? data.name.value : this.name,
      standardName: data.standardName.present
          ? data.standardName.value
          : this.standardName,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      status: data.status.present ? data.status.value : this.status,
      storageType:
          data.storageType.present ? data.storageType.value : this.storageType,
      isEssential:
          data.isEssential.present ? data.isEssential.value : this.isEssential,
      amount: data.amount.present ? data.amount.value : this.amount,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      consumedAt:
          data.consumedAt.present ? data.consumedAt.value : this.consumedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientEntity(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('name: $name, ')
          ..write('standardName: $standardName, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('storageType: $storageType, ')
          ..write('isEssential: $isEssential, ')
          ..write('amount: $amount, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('consumedAt: $consumedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      originalId,
      name,
      standardName,
      category,
      unit,
      status,
      storageType,
      isEssential,
      amount,
      purchaseDate,
      expiryDate,
      consumedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientEntity &&
          other.id == this.id &&
          other.originalId == this.originalId &&
          other.name == this.name &&
          other.standardName == this.standardName &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.status == this.status &&
          other.storageType == this.storageType &&
          other.isEssential == this.isEssential &&
          other.amount == this.amount &&
          other.purchaseDate == this.purchaseDate &&
          other.expiryDate == this.expiryDate &&
          other.consumedAt == this.consumedAt);
}

class IngredientsCompanion extends UpdateCompanion<IngredientEntity> {
  final Value<int> id;
  final Value<String> originalId;
  final Value<String> name;
  final Value<String> standardName;
  final Value<String> category;
  final Value<String> unit;
  final Value<int> status;
  final Value<int> storageType;
  final Value<bool> isEssential;
  final Value<double> amount;
  final Value<DateTime?> purchaseDate;
  final Value<DateTime?> expiryDate;
  final Value<DateTime?> consumedAt;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.originalId = const Value.absent(),
    this.name = const Value.absent(),
    this.standardName = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.status = const Value.absent(),
    this.storageType = const Value.absent(),
    this.isEssential = const Value.absent(),
    this.amount = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.consumedAt = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String originalId,
    required String name,
    required String standardName,
    required String category,
    required String unit,
    required int status,
    required int storageType,
    this.isEssential = const Value.absent(),
    this.amount = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.consumedAt = const Value.absent(),
  })  : originalId = Value(originalId),
        name = Value(name),
        standardName = Value(standardName),
        category = Value(category),
        unit = Value(unit),
        status = Value(status),
        storageType = Value(storageType);
  static Insertable<IngredientEntity> custom({
    Expression<int>? id,
    Expression<String>? originalId,
    Expression<String>? name,
    Expression<String>? standardName,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<int>? status,
    Expression<int>? storageType,
    Expression<bool>? isEssential,
    Expression<double>? amount,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? consumedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalId != null) 'original_id': originalId,
      if (name != null) 'name': name,
      if (standardName != null) 'standard_name': standardName,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (status != null) 'status': status,
      if (storageType != null) 'storage_type': storageType,
      if (isEssential != null) 'is_essential': isEssential,
      if (amount != null) 'amount': amount,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (consumedAt != null) 'consumed_at': consumedAt,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalId,
      Value<String>? name,
      Value<String>? standardName,
      Value<String>? category,
      Value<String>? unit,
      Value<int>? status,
      Value<int>? storageType,
      Value<bool>? isEssential,
      Value<double>? amount,
      Value<DateTime?>? purchaseDate,
      Value<DateTime?>? expiryDate,
      Value<DateTime?>? consumedAt}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      originalId: originalId ?? this.originalId,
      name: name ?? this.name,
      standardName: standardName ?? this.standardName,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      storageType: storageType ?? this.storageType,
      isEssential: isEssential ?? this.isEssential,
      amount: amount ?? this.amount,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalId.present) {
      map['original_id'] = Variable<String>(originalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (standardName.present) {
      map['standard_name'] = Variable<String>(standardName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (storageType.present) {
      map['storage_type'] = Variable<int>(storageType.value);
    }
    if (isEssential.present) {
      map['is_essential'] = Variable<bool>(isEssential.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (consumedAt.present) {
      map['consumed_at'] = Variable<DateTime>(consumedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('name: $name, ')
          ..write('standardName: $standardName, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('storageType: $storageType, ')
          ..write('isEssential: $isEssential, ')
          ..write('amount: $amount, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('consumedAt: $consumedAt')
          ..write(')'))
        .toString();
  }
}

class $MealPlansTable extends MealPlans
    with TableInfo<$MealPlansTable, MealPlanEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalIdMeta =
      const VerificationMeta('originalId');
  @override
  late final GeneratedColumn<String> originalId = GeneratedColumn<String>(
      'original_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<int> mealType = GeneratedColumn<int>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, originalId, recipeId, date, mealType, isDone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlanEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_id')) {
      context.handle(
          _originalIdMeta,
          originalId.isAcceptableOrUnknown(
              data['original_id']!, _originalIdMeta));
    } else if (isInserting) {
      context.missing(_originalIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_type'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
    );
  }

  @override
  $MealPlansTable createAlias(String alias) {
    return $MealPlansTable(attachedDatabase, alias);
  }
}

class MealPlanEntity extends DataClass implements Insertable<MealPlanEntity> {
  final int id;
  final String originalId;
  final String recipeId;
  final DateTime date;
  final int mealType;
  final bool isDone;
  const MealPlanEntity(
      {required this.id,
      required this.originalId,
      required this.recipeId,
      required this.date,
      required this.mealType,
      required this.isDone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_id'] = Variable<String>(originalId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['date'] = Variable<DateTime>(date);
    map['meal_type'] = Variable<int>(mealType);
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  MealPlansCompanion toCompanion(bool nullToAbsent) {
    return MealPlansCompanion(
      id: Value(id),
      originalId: Value(originalId),
      recipeId: Value(recipeId),
      date: Value(date),
      mealType: Value(mealType),
      isDone: Value(isDone),
    );
  }

  factory MealPlanEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanEntity(
      id: serializer.fromJson<int>(json['id']),
      originalId: serializer.fromJson<String>(json['originalId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      date: serializer.fromJson<DateTime>(json['date']),
      mealType: serializer.fromJson<int>(json['mealType']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalId': serializer.toJson<String>(originalId),
      'recipeId': serializer.toJson<String>(recipeId),
      'date': serializer.toJson<DateTime>(date),
      'mealType': serializer.toJson<int>(mealType),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  MealPlanEntity copyWith(
          {int? id,
          String? originalId,
          String? recipeId,
          DateTime? date,
          int? mealType,
          bool? isDone}) =>
      MealPlanEntity(
        id: id ?? this.id,
        originalId: originalId ?? this.originalId,
        recipeId: recipeId ?? this.recipeId,
        date: date ?? this.date,
        mealType: mealType ?? this.mealType,
        isDone: isDone ?? this.isDone,
      );
  MealPlanEntity copyWithCompanion(MealPlansCompanion data) {
    return MealPlanEntity(
      id: data.id.present ? data.id.value : this.id,
      originalId:
          data.originalId.present ? data.originalId.value : this.originalId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      date: data.date.present ? data.date.value : this.date,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntity(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('recipeId: $recipeId, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, originalId, recipeId, date, mealType, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanEntity &&
          other.id == this.id &&
          other.originalId == this.originalId &&
          other.recipeId == this.recipeId &&
          other.date == this.date &&
          other.mealType == this.mealType &&
          other.isDone == this.isDone);
}

class MealPlansCompanion extends UpdateCompanion<MealPlanEntity> {
  final Value<int> id;
  final Value<String> originalId;
  final Value<String> recipeId;
  final Value<DateTime> date;
  final Value<int> mealType;
  final Value<bool> isDone;
  const MealPlansCompanion({
    this.id = const Value.absent(),
    this.originalId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.date = const Value.absent(),
    this.mealType = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  MealPlansCompanion.insert({
    this.id = const Value.absent(),
    required String originalId,
    required String recipeId,
    required DateTime date,
    required int mealType,
    this.isDone = const Value.absent(),
  })  : originalId = Value(originalId),
        recipeId = Value(recipeId),
        date = Value(date),
        mealType = Value(mealType);
  static Insertable<MealPlanEntity> custom({
    Expression<int>? id,
    Expression<String>? originalId,
    Expression<String>? recipeId,
    Expression<DateTime>? date,
    Expression<int>? mealType,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalId != null) 'original_id': originalId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (date != null) 'date': date,
      if (mealType != null) 'meal_type': mealType,
      if (isDone != null) 'is_done': isDone,
    });
  }

  MealPlansCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalId,
      Value<String>? recipeId,
      Value<DateTime>? date,
      Value<int>? mealType,
      Value<bool>? isDone}) {
    return MealPlansCompanion(
      id: id ?? this.id,
      originalId: originalId ?? this.originalId,
      recipeId: recipeId ?? this.recipeId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalId.present) {
      map['original_id'] = Variable<String>(originalId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<int>(mealType.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansCompanion(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('recipeId: $recipeId, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoriesTable extends SearchHistories
    with TableInfo<$SearchHistoriesTable, SearchHistoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalIdMeta =
      const VerificationMeta('originalId');
  @override
  late final GeneratedColumn<String> originalId = GeneratedColumn<String>(
      'original_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, originalId, query, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_histories';
  @override
  VerificationContext validateIntegrity(
      Insertable<SearchHistoryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_id')) {
      context.handle(
          _originalIdMeta,
          originalId.isAcceptableOrUnknown(
              data['original_id']!, _originalIdMeta));
    } else if (isInserting) {
      context.missing(_originalIdMeta);
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SearchHistoriesTable createAlias(String alias) {
    return $SearchHistoriesTable(attachedDatabase, alias);
  }
}

class SearchHistoryEntity extends DataClass
    implements Insertable<SearchHistoryEntity> {
  final int id;
  final String originalId;
  final String query;
  final DateTime createdAt;
  const SearchHistoryEntity(
      {required this.id,
      required this.originalId,
      required this.query,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_id'] = Variable<String>(originalId);
    map['query'] = Variable<String>(query);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SearchHistoriesCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoriesCompanion(
      id: Value(id),
      originalId: Value(originalId),
      query: Value(query),
      createdAt: Value(createdAt),
    );
  }

  factory SearchHistoryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryEntity(
      id: serializer.fromJson<int>(json['id']),
      originalId: serializer.fromJson<String>(json['originalId']),
      query: serializer.fromJson<String>(json['query']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalId': serializer.toJson<String>(originalId),
      'query': serializer.toJson<String>(query),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SearchHistoryEntity copyWith(
          {int? id, String? originalId, String? query, DateTime? createdAt}) =>
      SearchHistoryEntity(
        id: id ?? this.id,
        originalId: originalId ?? this.originalId,
        query: query ?? this.query,
        createdAt: createdAt ?? this.createdAt,
      );
  SearchHistoryEntity copyWithCompanion(SearchHistoriesCompanion data) {
    return SearchHistoryEntity(
      id: data.id.present ? data.id.value : this.id,
      originalId:
          data.originalId.present ? data.originalId.value : this.originalId,
      query: data.query.present ? data.query.value : this.query,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryEntity(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, originalId, query, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryEntity &&
          other.id == this.id &&
          other.originalId == this.originalId &&
          other.query == this.query &&
          other.createdAt == this.createdAt);
}

class SearchHistoriesCompanion extends UpdateCompanion<SearchHistoryEntity> {
  final Value<int> id;
  final Value<String> originalId;
  final Value<String> query;
  final Value<DateTime> createdAt;
  const SearchHistoriesCompanion({
    this.id = const Value.absent(),
    this.originalId = const Value.absent(),
    this.query = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SearchHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required String originalId,
    required String query,
    required DateTime createdAt,
  })  : originalId = Value(originalId),
        query = Value(query),
        createdAt = Value(createdAt);
  static Insertable<SearchHistoryEntity> custom({
    Expression<int>? id,
    Expression<String>? originalId,
    Expression<String>? query,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalId != null) 'original_id': originalId,
      if (query != null) 'query': query,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SearchHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalId,
      Value<String>? query,
      Value<DateTime>? createdAt}) {
    return SearchHistoriesCompanion(
      id: id ?? this.id,
      originalId: originalId ?? this.originalId,
      query: query ?? this.query,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalId.present) {
      map['original_id'] = Variable<String>(originalId.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSettingsEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalIdMeta =
      const VerificationMeta('originalId');
  @override
  late final GeneratedColumn<String> originalId = GeneratedColumn<String>(
      'original_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
      'points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _adRightsMeta =
      const VerificationMeta('adRights');
  @override
  late final GeneratedColumn<int> adRights = GeneratedColumn<int>(
      'ad_rights', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _contentWifiOnlyMeta =
      const VerificationMeta('contentWifiOnly');
  @override
  late final GeneratedColumn<bool> contentWifiOnly = GeneratedColumn<bool>(
      'content_wifi_only', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("content_wifi_only" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _hideAiIngredientRegistrationDialogMeta =
      const VerificationMeta('hideAiIngredientRegistrationDialog');
  @override
  late final GeneratedColumn<bool> hideAiIngredientRegistrationDialog =
      GeneratedColumn<bool>(
          'hide_ai_ingredient_registration_dialog', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("hide_ai_ingredient_registration_dialog" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _myAreaLatMeta =
      const VerificationMeta('myAreaLat');
  @override
  late final GeneratedColumn<double> myAreaLat = GeneratedColumn<double>(
      'my_area_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _myAreaLngMeta =
      const VerificationMeta('myAreaLng');
  @override
  late final GeneratedColumn<double> myAreaLng = GeneratedColumn<double>(
      'my_area_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalId,
        points,
        adRights,
        contentWifiOnly,
        hideAiIngredientRegistrationDialog,
        myAreaLat,
        myAreaLng
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(Insertable<UserSettingsEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_id')) {
      context.handle(
          _originalIdMeta,
          originalId.isAcceptableOrUnknown(
              data['original_id']!, _originalIdMeta));
    } else if (isInserting) {
      context.missing(_originalIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    }
    if (data.containsKey('ad_rights')) {
      context.handle(_adRightsMeta,
          adRights.isAcceptableOrUnknown(data['ad_rights']!, _adRightsMeta));
    }
    if (data.containsKey('content_wifi_only')) {
      context.handle(
          _contentWifiOnlyMeta,
          contentWifiOnly.isAcceptableOrUnknown(
              data['content_wifi_only']!, _contentWifiOnlyMeta));
    }
    if (data.containsKey('hide_ai_ingredient_registration_dialog')) {
      context.handle(
          _hideAiIngredientRegistrationDialogMeta,
          hideAiIngredientRegistrationDialog.isAcceptableOrUnknown(
              data['hide_ai_ingredient_registration_dialog']!,
              _hideAiIngredientRegistrationDialogMeta));
    }
    if (data.containsKey('my_area_lat')) {
      context.handle(
          _myAreaLatMeta,
          myAreaLat.isAcceptableOrUnknown(
              data['my_area_lat']!, _myAreaLatMeta));
    }
    if (data.containsKey('my_area_lng')) {
      context.handle(
          _myAreaLngMeta,
          myAreaLng.isAcceptableOrUnknown(
              data['my_area_lng']!, _myAreaLngMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_id'])!,
      points: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}points'])!,
      adRights: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ad_rights'])!,
      contentWifiOnly: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}content_wifi_only'])!,
      hideAiIngredientRegistrationDialog: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}hide_ai_ingredient_registration_dialog'])!,
      myAreaLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}my_area_lat']),
      myAreaLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}my_area_lng']),
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSettingsEntity extends DataClass
    implements Insertable<UserSettingsEntity> {
  final int id;
  final String originalId;
  final int points;
  final int adRights;
  final bool contentWifiOnly;
  final bool hideAiIngredientRegistrationDialog;
  final double? myAreaLat;
  final double? myAreaLng;
  const UserSettingsEntity(
      {required this.id,
      required this.originalId,
      required this.points,
      required this.adRights,
      required this.contentWifiOnly,
      required this.hideAiIngredientRegistrationDialog,
      this.myAreaLat,
      this.myAreaLng});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_id'] = Variable<String>(originalId);
    map['points'] = Variable<int>(points);
    map['ad_rights'] = Variable<int>(adRights);
    map['content_wifi_only'] = Variable<bool>(contentWifiOnly);
    map['hide_ai_ingredient_registration_dialog'] =
        Variable<bool>(hideAiIngredientRegistrationDialog);
    if (!nullToAbsent || myAreaLat != null) {
      map['my_area_lat'] = Variable<double>(myAreaLat);
    }
    if (!nullToAbsent || myAreaLng != null) {
      map['my_area_lng'] = Variable<double>(myAreaLng);
    }
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      originalId: Value(originalId),
      points: Value(points),
      adRights: Value(adRights),
      contentWifiOnly: Value(contentWifiOnly),
      hideAiIngredientRegistrationDialog:
          Value(hideAiIngredientRegistrationDialog),
      myAreaLat: myAreaLat == null && nullToAbsent
          ? const Value.absent()
          : Value(myAreaLat),
      myAreaLng: myAreaLng == null && nullToAbsent
          ? const Value.absent()
          : Value(myAreaLng),
    );
  }

  factory UserSettingsEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsEntity(
      id: serializer.fromJson<int>(json['id']),
      originalId: serializer.fromJson<String>(json['originalId']),
      points: serializer.fromJson<int>(json['points']),
      adRights: serializer.fromJson<int>(json['adRights']),
      contentWifiOnly: serializer.fromJson<bool>(json['contentWifiOnly']),
      hideAiIngredientRegistrationDialog:
          serializer.fromJson<bool>(json['hideAiIngredientRegistrationDialog']),
      myAreaLat: serializer.fromJson<double?>(json['myAreaLat']),
      myAreaLng: serializer.fromJson<double?>(json['myAreaLng']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalId': serializer.toJson<String>(originalId),
      'points': serializer.toJson<int>(points),
      'adRights': serializer.toJson<int>(adRights),
      'contentWifiOnly': serializer.toJson<bool>(contentWifiOnly),
      'hideAiIngredientRegistrationDialog':
          serializer.toJson<bool>(hideAiIngredientRegistrationDialog),
      'myAreaLat': serializer.toJson<double?>(myAreaLat),
      'myAreaLng': serializer.toJson<double?>(myAreaLng),
    };
  }

  UserSettingsEntity copyWith(
          {int? id,
          String? originalId,
          int? points,
          int? adRights,
          bool? contentWifiOnly,
          bool? hideAiIngredientRegistrationDialog,
          Value<double?> myAreaLat = const Value.absent(),
          Value<double?> myAreaLng = const Value.absent()}) =>
      UserSettingsEntity(
        id: id ?? this.id,
        originalId: originalId ?? this.originalId,
        points: points ?? this.points,
        adRights: adRights ?? this.adRights,
        contentWifiOnly: contentWifiOnly ?? this.contentWifiOnly,
        hideAiIngredientRegistrationDialog:
            hideAiIngredientRegistrationDialog ??
                this.hideAiIngredientRegistrationDialog,
        myAreaLat: myAreaLat.present ? myAreaLat.value : this.myAreaLat,
        myAreaLng: myAreaLng.present ? myAreaLng.value : this.myAreaLng,
      );
  UserSettingsEntity copyWithCompanion(UserSettingsCompanion data) {
    return UserSettingsEntity(
      id: data.id.present ? data.id.value : this.id,
      originalId:
          data.originalId.present ? data.originalId.value : this.originalId,
      points: data.points.present ? data.points.value : this.points,
      adRights: data.adRights.present ? data.adRights.value : this.adRights,
      contentWifiOnly: data.contentWifiOnly.present
          ? data.contentWifiOnly.value
          : this.contentWifiOnly,
      hideAiIngredientRegistrationDialog:
          data.hideAiIngredientRegistrationDialog.present
              ? data.hideAiIngredientRegistrationDialog.value
              : this.hideAiIngredientRegistrationDialog,
      myAreaLat: data.myAreaLat.present ? data.myAreaLat.value : this.myAreaLat,
      myAreaLng: data.myAreaLng.present ? data.myAreaLng.value : this.myAreaLng,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntity(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('points: $points, ')
          ..write('adRights: $adRights, ')
          ..write('contentWifiOnly: $contentWifiOnly, ')
          ..write(
              'hideAiIngredientRegistrationDialog: $hideAiIngredientRegistrationDialog, ')
          ..write('myAreaLat: $myAreaLat, ')
          ..write('myAreaLng: $myAreaLng')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      originalId,
      points,
      adRights,
      contentWifiOnly,
      hideAiIngredientRegistrationDialog,
      myAreaLat,
      myAreaLng);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsEntity &&
          other.id == this.id &&
          other.originalId == this.originalId &&
          other.points == this.points &&
          other.adRights == this.adRights &&
          other.contentWifiOnly == this.contentWifiOnly &&
          other.hideAiIngredientRegistrationDialog ==
              this.hideAiIngredientRegistrationDialog &&
          other.myAreaLat == this.myAreaLat &&
          other.myAreaLng == this.myAreaLng);
}

class UserSettingsCompanion extends UpdateCompanion<UserSettingsEntity> {
  final Value<int> id;
  final Value<String> originalId;
  final Value<int> points;
  final Value<int> adRights;
  final Value<bool> contentWifiOnly;
  final Value<bool> hideAiIngredientRegistrationDialog;
  final Value<double?> myAreaLat;
  final Value<double?> myAreaLng;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.originalId = const Value.absent(),
    this.points = const Value.absent(),
    this.adRights = const Value.absent(),
    this.contentWifiOnly = const Value.absent(),
    this.hideAiIngredientRegistrationDialog = const Value.absent(),
    this.myAreaLat = const Value.absent(),
    this.myAreaLng = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String originalId,
    this.points = const Value.absent(),
    this.adRights = const Value.absent(),
    this.contentWifiOnly = const Value.absent(),
    this.hideAiIngredientRegistrationDialog = const Value.absent(),
    this.myAreaLat = const Value.absent(),
    this.myAreaLng = const Value.absent(),
  }) : originalId = Value(originalId);
  static Insertable<UserSettingsEntity> custom({
    Expression<int>? id,
    Expression<String>? originalId,
    Expression<int>? points,
    Expression<int>? adRights,
    Expression<bool>? contentWifiOnly,
    Expression<bool>? hideAiIngredientRegistrationDialog,
    Expression<double>? myAreaLat,
    Expression<double>? myAreaLng,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalId != null) 'original_id': originalId,
      if (points != null) 'points': points,
      if (adRights != null) 'ad_rights': adRights,
      if (contentWifiOnly != null) 'content_wifi_only': contentWifiOnly,
      if (hideAiIngredientRegistrationDialog != null)
        'hide_ai_ingredient_registration_dialog':
            hideAiIngredientRegistrationDialog,
      if (myAreaLat != null) 'my_area_lat': myAreaLat,
      if (myAreaLng != null) 'my_area_lng': myAreaLng,
    });
  }

  UserSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalId,
      Value<int>? points,
      Value<int>? adRights,
      Value<bool>? contentWifiOnly,
      Value<bool>? hideAiIngredientRegistrationDialog,
      Value<double?>? myAreaLat,
      Value<double?>? myAreaLng}) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      originalId: originalId ?? this.originalId,
      points: points ?? this.points,
      adRights: adRights ?? this.adRights,
      contentWifiOnly: contentWifiOnly ?? this.contentWifiOnly,
      hideAiIngredientRegistrationDialog: hideAiIngredientRegistrationDialog ??
          this.hideAiIngredientRegistrationDialog,
      myAreaLat: myAreaLat ?? this.myAreaLat,
      myAreaLng: myAreaLng ?? this.myAreaLng,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalId.present) {
      map['original_id'] = Variable<String>(originalId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (adRights.present) {
      map['ad_rights'] = Variable<int>(adRights.value);
    }
    if (contentWifiOnly.present) {
      map['content_wifi_only'] = Variable<bool>(contentWifiOnly.value);
    }
    if (hideAiIngredientRegistrationDialog.present) {
      map['hide_ai_ingredient_registration_dialog'] =
          Variable<bool>(hideAiIngredientRegistrationDialog.value);
    }
    if (myAreaLat.present) {
      map['my_area_lat'] = Variable<double>(myAreaLat.value);
    }
    if (myAreaLng.present) {
      map['my_area_lng'] = Variable<double>(myAreaLng.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('originalId: $originalId, ')
          ..write('points: $points, ')
          ..write('adRights: $adRights, ')
          ..write('contentWifiOnly: $contentWifiOnly, ')
          ..write(
              'hideAiIngredientRegistrationDialog: $hideAiIngredientRegistrationDialog, ')
          ..write('myAreaLat: $myAreaLat, ')
          ..write('myAreaLng: $myAreaLng')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $MealPlansTable mealPlans = $MealPlansTable(this);
  late final $SearchHistoriesTable searchHistories =
      $SearchHistoriesTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [recipes, ingredients, mealPlans, searchHistories, userSettings];
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String originalId,
  required String title,
  required String pageUrl,
  required String ogpImageUrl,
  required DateTime createdAt,
  Value<int> cookedCount,
  Value<int> defaultServings,
  Value<int> rating,
  Value<DateTime?> lastCookedAt,
  Value<bool> isDeleted,
  Value<String> memo,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> originalId,
  Value<String> title,
  Value<String> pageUrl,
  Value<String> ogpImageUrl,
  Value<DateTime> createdAt,
  Value<int> cookedCount,
  Value<int> defaultServings,
  Value<int> rating,
  Value<DateTime?> lastCookedAt,
  Value<bool> isDeleted,
  Value<String> memo,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pageUrl => $composableBuilder(
      column: $table.pageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ogpImageUrl => $composableBuilder(
      column: $table.ogpImageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookedCount => $composableBuilder(
      column: $table.cookedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultServings => $composableBuilder(
      column: $table.defaultServings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCookedAt => $composableBuilder(
      column: $table.lastCookedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pageUrl => $composableBuilder(
      column: $table.pageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ogpImageUrl => $composableBuilder(
      column: $table.ogpImageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookedCount => $composableBuilder(
      column: $table.cookedCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultServings => $composableBuilder(
      column: $table.defaultServings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCookedAt => $composableBuilder(
      column: $table.lastCookedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get pageUrl =>
      $composableBuilder(column: $table.pageUrl, builder: (column) => column);

  GeneratedColumn<String> get ogpImageUrl => $composableBuilder(
      column: $table.ogpImageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get cookedCount => $composableBuilder(
      column: $table.cookedCount, builder: (column) => column);

  GeneratedColumn<int> get defaultServings => $composableBuilder(
      column: $table.defaultServings, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCookedAt => $composableBuilder(
      column: $table.lastCookedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeEntity,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeEntity, BaseReferences<_$AppDatabase, $RecipesTable, RecipeEntity>),
    RecipeEntity,
    PrefetchHooks Function()> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> pageUrl = const Value.absent(),
            Value<String> ogpImageUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> cookedCount = const Value.absent(),
            Value<int> defaultServings = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<DateTime?> lastCookedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> memo = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            originalId: originalId,
            title: title,
            pageUrl: pageUrl,
            ogpImageUrl: ogpImageUrl,
            createdAt: createdAt,
            cookedCount: cookedCount,
            defaultServings: defaultServings,
            rating: rating,
            lastCookedAt: lastCookedAt,
            isDeleted: isDeleted,
            memo: memo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalId,
            required String title,
            required String pageUrl,
            required String ogpImageUrl,
            required DateTime createdAt,
            Value<int> cookedCount = const Value.absent(),
            Value<int> defaultServings = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<DateTime?> lastCookedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> memo = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            originalId: originalId,
            title: title,
            pageUrl: pageUrl,
            ogpImageUrl: ogpImageUrl,
            createdAt: createdAt,
            cookedCount: cookedCount,
            defaultServings: defaultServings,
            rating: rating,
            lastCookedAt: lastCookedAt,
            isDeleted: isDeleted,
            memo: memo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeEntity,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeEntity, BaseReferences<_$AppDatabase, $RecipesTable, RecipeEntity>),
    RecipeEntity,
    PrefetchHooks Function()>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required String originalId,
  required String name,
  required String standardName,
  required String category,
  required String unit,
  required int status,
  required int storageType,
  Value<bool> isEssential,
  Value<double> amount,
  Value<DateTime?> purchaseDate,
  Value<DateTime?> expiryDate,
  Value<DateTime?> consumedAt,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<String> originalId,
  Value<String> name,
  Value<String> standardName,
  Value<String> category,
  Value<String> unit,
  Value<int> status,
  Value<int> storageType,
  Value<bool> isEssential,
  Value<double> amount,
  Value<DateTime?> purchaseDate,
  Value<DateTime?> expiryDate,
  Value<DateTime?> consumedAt,
});

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get standardName => $composableBuilder(
      column: $table.standardName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get storageType => $composableBuilder(
      column: $table.storageType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEssential => $composableBuilder(
      column: $table.isEssential, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get consumedAt => $composableBuilder(
      column: $table.consumedAt, builder: (column) => ColumnFilters(column));
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get standardName => $composableBuilder(
      column: $table.standardName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get storageType => $composableBuilder(
      column: $table.storageType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEssential => $composableBuilder(
      column: $table.isEssential, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get consumedAt => $composableBuilder(
      column: $table.consumedAt, builder: (column) => ColumnOrderings(column));
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get standardName => $composableBuilder(
      column: $table.standardName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get storageType => $composableBuilder(
      column: $table.storageType, builder: (column) => column);

  GeneratedColumn<bool> get isEssential => $composableBuilder(
      column: $table.isEssential, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get consumedAt => $composableBuilder(
      column: $table.consumedAt, builder: (column) => column);
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    IngredientEntity,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (
      IngredientEntity,
      BaseReferences<_$AppDatabase, $IngredientsTable, IngredientEntity>
    ),
    IngredientEntity,
    PrefetchHooks Function()> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> standardName = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> storageType = const Value.absent(),
            Value<bool> isEssential = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime?> purchaseDate = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime?> consumedAt = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            originalId: originalId,
            name: name,
            standardName: standardName,
            category: category,
            unit: unit,
            status: status,
            storageType: storageType,
            isEssential: isEssential,
            amount: amount,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            consumedAt: consumedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalId,
            required String name,
            required String standardName,
            required String category,
            required String unit,
            required int status,
            required int storageType,
            Value<bool> isEssential = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime?> purchaseDate = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime?> consumedAt = const Value.absent(),
          }) =>
              IngredientsCompanion.insert(
            id: id,
            originalId: originalId,
            name: name,
            standardName: standardName,
            category: category,
            unit: unit,
            status: status,
            storageType: storageType,
            isEssential: isEssential,
            amount: amount,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            consumedAt: consumedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    IngredientEntity,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (
      IngredientEntity,
      BaseReferences<_$AppDatabase, $IngredientsTable, IngredientEntity>
    ),
    IngredientEntity,
    PrefetchHooks Function()>;
typedef $$MealPlansTableCreateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  required String originalId,
  required String recipeId,
  required DateTime date,
  required int mealType,
  Value<bool> isDone,
});
typedef $$MealPlansTableUpdateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  Value<String> originalId,
  Value<String> recipeId,
  Value<DateTime> date,
  Value<int> mealType,
  Value<bool> isDone,
});

class $$MealPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));
}

class $$MealPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));
}

class $$MealPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);
}

class $$MealPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealPlansTable,
    MealPlanEntity,
    $$MealPlansTableFilterComposer,
    $$MealPlansTableOrderingComposer,
    $$MealPlansTableAnnotationComposer,
    $$MealPlansTableCreateCompanionBuilder,
    $$MealPlansTableUpdateCompanionBuilder,
    (
      MealPlanEntity,
      BaseReferences<_$AppDatabase, $MealPlansTable, MealPlanEntity>
    ),
    MealPlanEntity,
    PrefetchHooks Function()> {
  $$MealPlansTableTableManager(_$AppDatabase db, $MealPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalId = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> mealType = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
          }) =>
              MealPlansCompanion(
            id: id,
            originalId: originalId,
            recipeId: recipeId,
            date: date,
            mealType: mealType,
            isDone: isDone,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalId,
            required String recipeId,
            required DateTime date,
            required int mealType,
            Value<bool> isDone = const Value.absent(),
          }) =>
              MealPlansCompanion.insert(
            id: id,
            originalId: originalId,
            recipeId: recipeId,
            date: date,
            mealType: mealType,
            isDone: isDone,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MealPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealPlansTable,
    MealPlanEntity,
    $$MealPlansTableFilterComposer,
    $$MealPlansTableOrderingComposer,
    $$MealPlansTableAnnotationComposer,
    $$MealPlansTableCreateCompanionBuilder,
    $$MealPlansTableUpdateCompanionBuilder,
    (
      MealPlanEntity,
      BaseReferences<_$AppDatabase, $MealPlansTable, MealPlanEntity>
    ),
    MealPlanEntity,
    PrefetchHooks Function()>;
typedef $$SearchHistoriesTableCreateCompanionBuilder = SearchHistoriesCompanion
    Function({
  Value<int> id,
  required String originalId,
  required String query,
  required DateTime createdAt,
});
typedef $$SearchHistoriesTableUpdateCompanionBuilder = SearchHistoriesCompanion
    Function({
  Value<int> id,
  Value<String> originalId,
  Value<String> query,
  Value<DateTime> createdAt,
});

class $$SearchHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoriesTable> {
  $$SearchHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoriesTable> {
  $$SearchHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoriesTable> {
  $$SearchHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SearchHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoriesTable,
    SearchHistoryEntity,
    $$SearchHistoriesTableFilterComposer,
    $$SearchHistoriesTableOrderingComposer,
    $$SearchHistoriesTableAnnotationComposer,
    $$SearchHistoriesTableCreateCompanionBuilder,
    $$SearchHistoriesTableUpdateCompanionBuilder,
    (
      SearchHistoryEntity,
      BaseReferences<_$AppDatabase, $SearchHistoriesTable, SearchHistoryEntity>
    ),
    SearchHistoryEntity,
    PrefetchHooks Function()> {
  $$SearchHistoriesTableTableManager(
      _$AppDatabase db, $SearchHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalId = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SearchHistoriesCompanion(
            id: id,
            originalId: originalId,
            query: query,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalId,
            required String query,
            required DateTime createdAt,
          }) =>
              SearchHistoriesCompanion.insert(
            id: id,
            originalId: originalId,
            query: query,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchHistoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoriesTable,
    SearchHistoryEntity,
    $$SearchHistoriesTableFilterComposer,
    $$SearchHistoriesTableOrderingComposer,
    $$SearchHistoriesTableAnnotationComposer,
    $$SearchHistoriesTableCreateCompanionBuilder,
    $$SearchHistoriesTableUpdateCompanionBuilder,
    (
      SearchHistoryEntity,
      BaseReferences<_$AppDatabase, $SearchHistoriesTable, SearchHistoryEntity>
    ),
    SearchHistoryEntity,
    PrefetchHooks Function()>;
typedef $$UserSettingsTableCreateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<int> id,
  required String originalId,
  Value<int> points,
  Value<int> adRights,
  Value<bool> contentWifiOnly,
  Value<bool> hideAiIngredientRegistrationDialog,
  Value<double?> myAreaLat,
  Value<double?> myAreaLng,
});
typedef $$UserSettingsTableUpdateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<int> id,
  Value<String> originalId,
  Value<int> points,
  Value<int> adRights,
  Value<bool> contentWifiOnly,
  Value<bool> hideAiIngredientRegistrationDialog,
  Value<double?> myAreaLat,
  Value<double?> myAreaLng,
});

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get adRights => $composableBuilder(
      column: $table.adRights, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get contentWifiOnly => $composableBuilder(
      column: $table.contentWifiOnly,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hideAiIngredientRegistrationDialog =>
      $composableBuilder(
          column: $table.hideAiIngredientRegistrationDialog,
          builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get myAreaLat => $composableBuilder(
      column: $table.myAreaLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get myAreaLng => $composableBuilder(
      column: $table.myAreaLng, builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get adRights => $composableBuilder(
      column: $table.adRights, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get contentWifiOnly => $composableBuilder(
      column: $table.contentWifiOnly,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hideAiIngredientRegistrationDialog =>
      $composableBuilder(
          column: $table.hideAiIngredientRegistrationDialog,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get myAreaLat => $composableBuilder(
      column: $table.myAreaLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get myAreaLng => $composableBuilder(
      column: $table.myAreaLng, builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalId => $composableBuilder(
      column: $table.originalId, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get adRights =>
      $composableBuilder(column: $table.adRights, builder: (column) => column);

  GeneratedColumn<bool> get contentWifiOnly => $composableBuilder(
      column: $table.contentWifiOnly, builder: (column) => column);

  GeneratedColumn<bool> get hideAiIngredientRegistrationDialog =>
      $composableBuilder(
          column: $table.hideAiIngredientRegistrationDialog,
          builder: (column) => column);

  GeneratedColumn<double> get myAreaLat =>
      $composableBuilder(column: $table.myAreaLat, builder: (column) => column);

  GeneratedColumn<double> get myAreaLng =>
      $composableBuilder(column: $table.myAreaLng, builder: (column) => column);
}

class $$UserSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSettingsEntity,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (
      UserSettingsEntity,
      BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingsEntity>
    ),
    UserSettingsEntity,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalId = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<int> adRights = const Value.absent(),
            Value<bool> contentWifiOnly = const Value.absent(),
            Value<bool> hideAiIngredientRegistrationDialog =
                const Value.absent(),
            Value<double?> myAreaLat = const Value.absent(),
            Value<double?> myAreaLng = const Value.absent(),
          }) =>
              UserSettingsCompanion(
            id: id,
            originalId: originalId,
            points: points,
            adRights: adRights,
            contentWifiOnly: contentWifiOnly,
            hideAiIngredientRegistrationDialog:
                hideAiIngredientRegistrationDialog,
            myAreaLat: myAreaLat,
            myAreaLng: myAreaLng,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalId,
            Value<int> points = const Value.absent(),
            Value<int> adRights = const Value.absent(),
            Value<bool> contentWifiOnly = const Value.absent(),
            Value<bool> hideAiIngredientRegistrationDialog =
                const Value.absent(),
            Value<double?> myAreaLat = const Value.absent(),
            Value<double?> myAreaLng = const Value.absent(),
          }) =>
              UserSettingsCompanion.insert(
            id: id,
            originalId: originalId,
            points: points,
            adRights: adRights,
            contentWifiOnly: contentWifiOnly,
            hideAiIngredientRegistrationDialog:
                hideAiIngredientRegistrationDialog,
            myAreaLat: myAreaLat,
            myAreaLng: myAreaLng,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSettingsEntity,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (
      UserSettingsEntity,
      BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingsEntity>
    ),
    UserSettingsEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db, _db.mealPlans);
  $$SearchHistoriesTableTableManager get searchHistories =>
      $$SearchHistoriesTableTableManager(_db, _db.searchHistories);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
