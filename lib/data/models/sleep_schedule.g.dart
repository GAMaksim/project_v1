// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepScheduleAdapter extends TypeAdapter<SleepSchedule> {
  @override
  final int typeId = 1;

  @override
  SleepSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepSchedule(
      dayOfWeek: fields[0] as int,
      plannedBedtime: fields[1] as String,
      isEnabled: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SleepSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dayOfWeek)
      ..writeByte(1)
      ..write(obj.plannedBedtime)
      ..writeByte(2)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
