import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'clothes_record.g.dart';

abstract class ClothesRecord
    implements Built<ClothesRecord, ClothesRecordBuilder> {
  static Serializer<ClothesRecord> get serializer => _$clothesRecordSerializer;

  @nullable
  String get name;

  @nullable
  int get price;

  @nullable
  String get size;

  @nullable
  String get image;

  @nullable
  String get brand;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(ClothesRecordBuilder builder) => builder
    ..name = ''
    ..price = 0
    ..size = ''
    ..image = ''
    ..brand = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('clothes');

  static Stream<ClothesRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<ClothesRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  ClothesRecord._();
  factory ClothesRecord([void Function(ClothesRecordBuilder) updates]) =
      _$ClothesRecord;

  static ClothesRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createClothesRecordData({
  String name,
  int price,
  String size,
  String image,
  String brand,
}) =>
    serializers.toFirestore(
        ClothesRecord.serializer,
        ClothesRecord((c) => c
          ..name = name
          ..price = price
          ..size = size
          ..image = image
          ..brand = brand));
