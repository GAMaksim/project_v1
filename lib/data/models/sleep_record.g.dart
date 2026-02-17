// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepRecordAdapter extends TypeAdapter<SleepRecord> {
  @override
  final int typeId = 2;

  @override
  SleepRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepRecord(
      date: fields[0] as DateTime,
      plannedBedtime: fields[1] as String,
      actualBedtime: fields[2] as String?,
      wentToBedOnTime: fields[3] as bool?,
      quality: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SleepRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.plannedBedtime)
      ..writeByte(2)
      ..write(obj.actualBedtime)
      ..writeByte(3)
      ..write(obj.wentToBedOnTime)
      ..writeByte(4)
      ..write(obj.quality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
