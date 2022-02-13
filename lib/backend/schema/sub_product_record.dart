import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'sub_product_record.g.dart';

abstract class SubProductRecord
    implements Built<SubProductRecord, SubProductRecordBuilder> {
  static Serializer<SubProductRecord> get serializer =>
      _$subProductRecordSerializer;

  @nullable
  DocumentReference get product;

  @nullable
  int get subTotal;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(SubProductRecordBuilder builder) =>
      builder..subTotal = 0;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('subProduct');

  static Stream<SubProductRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<SubProductRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  SubProductRecord._();
  factory SubProductRecord([void Function(SubProductRecordBuilder) updates]) =
      _$SubProductRecord;

  static SubProductRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createSubProductRecordData({
  DocumentReference product,
  int subTotal,
}) =>
    serializers.toFirestore(
        SubProductRecord.serializer,
        SubProductRecord((s) => s
          ..product = product
          ..subTotal = subTotal));
