// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_payment_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlannedPaymentInfoAdapter extends TypeAdapter<PlannedPaymentInfo> {
  @override
  final int typeId = 50;

  @override
  PlannedPaymentInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlannedPaymentInfo(
      transaction: fields[0] as Transactions,
      dailyFreq: fields[1] as int,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime,
      weekDays: (fields[4] as List).cast<bool>(),
    )..version = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, PlannedPaymentInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.transaction)
      ..writeByte(1)
      ..write(obj.dailyFreq)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.weekDays)
      ..writeByte(5)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlannedPaymentInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
