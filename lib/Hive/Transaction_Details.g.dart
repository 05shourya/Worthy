// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transaction_Details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionDetailsAdapter extends TypeAdapter<TransactionDetails> {
  @override
  final int typeId = 0;

  @override
  TransactionDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionDetails(
      date: fields[0] as DateTime,
      transactions: (fields[1] as List).cast<Transactions>(),
    )..version = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, TransactionDetails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.transactions)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionsAdapter extends TypeAdapter<Transactions> {
  @override
  final int typeId = 2;

  @override
  Transactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transactions(
      amount: fields[0] as double,
      isDebit: fields[1] as bool,
      catagory: fields[2] as String,
      account: fields[3] as String,
      note: fields[4] as String,
      time: fields[5] as DateTime,
      title: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Transactions obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.isDebit)
      ..writeByte(2)
      ..write(obj.catagory)
      ..writeByte(3)
      ..write(obj.account)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
