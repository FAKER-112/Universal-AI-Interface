// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_provider_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarProviderConfigCollection on Isar {
  IsarCollection<IsarProviderConfig> get isarProviderConfigs =>
      this.collection();
}

const IsarProviderConfigSchema = CollectionSchema(
  name: r'IsarProviderConfig',
  id: -8493488844306129178,
  properties: {
    r'baseUrl': PropertySchema(
      id: 0,
      name: r'baseUrl',
      type: IsarType.string,
    ),
    r'configId': PropertySchema(
      id: 1,
      name: r'configId',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'frequencyPenalty': PropertySchema(
      id: 3,
      name: r'frequencyPenalty',
      type: IsarType.double,
    ),
    r'isPinned': PropertySchema(
      id: 4,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'maxRetries': PropertySchema(
      id: 5,
      name: r'maxRetries',
      type: IsarType.long,
    ),
    r'maxTokens': PropertySchema(
      id: 6,
      name: r'maxTokens',
      type: IsarType.long,
    ),
    r'modelName': PropertySchema(
      id: 7,
      name: r'modelName',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 8,
      name: r'name',
      type: IsarType.string,
    ),
    r'organization': PropertySchema(
      id: 9,
      name: r'organization',
      type: IsarType.string,
    ),
    r'presencePenalty': PropertySchema(
      id: 10,
      name: r'presencePenalty',
      type: IsarType.double,
    ),
    r'temperature': PropertySchema(
      id: 11,
      name: r'temperature',
      type: IsarType.double,
    ),
    r'timeout': PropertySchema(
      id: 12,
      name: r'timeout',
      type: IsarType.long,
    ),
    r'topP': PropertySchema(
      id: 13,
      name: r'topP',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 14,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _isarProviderConfigEstimateSize,
  serialize: _isarProviderConfigSerialize,
  deserialize: _isarProviderConfigDeserialize,
  deserializeProp: _isarProviderConfigDeserializeProp,
  idName: r'id',
  indexes: {
    r'configId': IndexSchema(
      id: 7164334513802924883,
      name: r'configId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'configId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarProviderConfigGetId,
  getLinks: _isarProviderConfigGetLinks,
  attach: _isarProviderConfigAttach,
  version: '3.1.0+1',
);

int _isarProviderConfigEstimateSize(
  IsarProviderConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.baseUrl.length * 3;
  bytesCount += 3 + object.configId.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.modelName.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.organization.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _isarProviderConfigSerialize(
  IsarProviderConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.baseUrl);
  writer.writeString(offsets[1], object.configId);
  writer.writeString(offsets[2], object.description);
  writer.writeDouble(offsets[3], object.frequencyPenalty);
  writer.writeBool(offsets[4], object.isPinned);
  writer.writeLong(offsets[5], object.maxRetries);
  writer.writeLong(offsets[6], object.maxTokens);
  writer.writeString(offsets[7], object.modelName);
  writer.writeString(offsets[8], object.name);
  writer.writeString(offsets[9], object.organization);
  writer.writeDouble(offsets[10], object.presencePenalty);
  writer.writeDouble(offsets[11], object.temperature);
  writer.writeLong(offsets[12], object.timeout);
  writer.writeDouble(offsets[13], object.topP);
  writer.writeString(offsets[14], object.type);
}

IsarProviderConfig _isarProviderConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarProviderConfig();
  object.baseUrl = reader.readString(offsets[0]);
  object.configId = reader.readString(offsets[1]);
  object.description = reader.readString(offsets[2]);
  object.frequencyPenalty = reader.readDouble(offsets[3]);
  object.id = id;
  object.isPinned = reader.readBool(offsets[4]);
  object.maxRetries = reader.readLong(offsets[5]);
  object.maxTokens = reader.readLong(offsets[6]);
  object.modelName = reader.readString(offsets[7]);
  object.name = reader.readString(offsets[8]);
  object.organization = reader.readString(offsets[9]);
  object.presencePenalty = reader.readDouble(offsets[10]);
  object.temperature = reader.readDouble(offsets[11]);
  object.timeout = reader.readLong(offsets[12]);
  object.topP = reader.readDouble(offsets[13]);
  object.type = reader.readString(offsets[14]);
  return object;
}

P _isarProviderConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarProviderConfigGetId(IsarProviderConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarProviderConfigGetLinks(
    IsarProviderConfig object) {
  return [];
}

void _isarProviderConfigAttach(
    IsarCollection<dynamic> col, Id id, IsarProviderConfig object) {
  object.id = id;
}

extension IsarProviderConfigByIndex on IsarCollection<IsarProviderConfig> {
  Future<IsarProviderConfig?> getByConfigId(String configId) {
    return getByIndex(r'configId', [configId]);
  }

  IsarProviderConfig? getByConfigIdSync(String configId) {
    return getByIndexSync(r'configId', [configId]);
  }

  Future<bool> deleteByConfigId(String configId) {
    return deleteByIndex(r'configId', [configId]);
  }

  bool deleteByConfigIdSync(String configId) {
    return deleteByIndexSync(r'configId', [configId]);
  }

  Future<List<IsarProviderConfig?>> getAllByConfigId(
      List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'configId', values);
  }

  List<IsarProviderConfig?> getAllByConfigIdSync(List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'configId', values);
  }

  Future<int> deleteAllByConfigId(List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'configId', values);
  }

  int deleteAllByConfigIdSync(List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'configId', values);
  }

  Future<Id> putByConfigId(IsarProviderConfig object) {
    return putByIndex(r'configId', object);
  }

  Id putByConfigIdSync(IsarProviderConfig object, {bool saveLinks = true}) {
    return putByIndexSync(r'configId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByConfigId(List<IsarProviderConfig> objects) {
    return putAllByIndex(r'configId', objects);
  }

  List<Id> putAllByConfigIdSync(List<IsarProviderConfig> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'configId', objects, saveLinks: saveLinks);
  }
}

extension IsarProviderConfigQueryWhereSort
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QWhere> {
  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarProviderConfigQueryWhere
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QWhereClause> {
  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
      configIdEqualTo(String configId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'configId',
        value: [configId],
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterWhereClause>
      configIdNotEqualTo(String configId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [],
              upper: [configId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [configId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [configId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [],
              upper: [configId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarProviderConfigQueryFilter
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QFilterCondition> {
  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'baseUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      baseUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'baseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      configIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      frequencyPenaltyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequencyPenalty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      frequencyPenaltyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frequencyPenalty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      frequencyPenaltyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frequencyPenalty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      frequencyPenaltyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frequencyPenalty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      isPinnedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxRetriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxRetries',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxRetriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxRetries',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxRetriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxRetries',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxRetriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxRetries',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxTokensEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxTokens',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxTokensGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxTokens',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxTokensLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxTokens',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      maxTokensBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxTokens',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      modelNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'organization',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'organization',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organization',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      organizationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'organization',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      presencePenaltyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'presencePenalty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      presencePenaltyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'presencePenalty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      presencePenaltyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'presencePenalty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      presencePenaltyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'presencePenalty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      temperatureEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      temperatureGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      temperatureLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      temperatureBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'temperature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      timeoutEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeout',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      timeoutGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeout',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      timeoutLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeout',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      timeoutBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeout',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      topPEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topP',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      topPGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topP',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      topPLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topP',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      topPBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topP',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension IsarProviderConfigQueryObject
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QFilterCondition> {}

extension IsarProviderConfigQueryLinks
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QFilterCondition> {}

extension IsarProviderConfigQuerySortBy
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QSortBy> {
  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByConfigIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByFrequencyPenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyPenalty', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByFrequencyPenaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyPenalty', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByMaxRetries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByMaxRetriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByMaxTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByMaxTokensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByModelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByModelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByPresencePenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'presencePenalty', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByPresencePenaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'presencePenalty', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTimeout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeout', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTimeoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeout', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTopP() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topP', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTopPDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topP', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension IsarProviderConfigQuerySortThenBy
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QSortThenBy> {
  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByConfigIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByFrequencyPenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyPenalty', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByFrequencyPenaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyPenalty', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByMaxRetries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByMaxRetriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByMaxTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByMaxTokensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByModelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByModelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByPresencePenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'presencePenalty', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByPresencePenaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'presencePenalty', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTimeout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeout', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTimeoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeout', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTopP() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topP', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTopPDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topP', Sort.desc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension IsarProviderConfigQueryWhereDistinct
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct> {
  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByBaseUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByConfigId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByFrequencyPenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequencyPenalty');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByMaxRetries() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxRetries');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByMaxTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxTokens');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByModelName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByOrganization({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'organization', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByPresencePenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'presencePenalty');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByTimeout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeout');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByTopP() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topP');
    });
  }

  QueryBuilder<IsarProviderConfig, IsarProviderConfig, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension IsarProviderConfigQueryProperty
    on QueryBuilder<IsarProviderConfig, IsarProviderConfig, QQueryProperty> {
  QueryBuilder<IsarProviderConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations> baseUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseUrl');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations>
      configIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configId');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarProviderConfig, double, QQueryOperations>
      frequencyPenaltyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequencyPenalty');
    });
  }

  QueryBuilder<IsarProviderConfig, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<IsarProviderConfig, int, QQueryOperations> maxRetriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxRetries');
    });
  }

  QueryBuilder<IsarProviderConfig, int, QQueryOperations> maxTokensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxTokens');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations>
      modelNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelName');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations>
      organizationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'organization');
    });
  }

  QueryBuilder<IsarProviderConfig, double, QQueryOperations>
      presencePenaltyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'presencePenalty');
    });
  }

  QueryBuilder<IsarProviderConfig, double, QQueryOperations>
      temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }

  QueryBuilder<IsarProviderConfig, int, QQueryOperations> timeoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeout');
    });
  }

  QueryBuilder<IsarProviderConfig, double, QQueryOperations> topPProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topP');
    });
  }

  QueryBuilder<IsarProviderConfig, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
