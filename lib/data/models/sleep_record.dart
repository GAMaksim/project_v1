import 'package:hive/hive.dart';

part 'sleep_record.g.dart';

@HiveType(typeId: 2)
class SleepRecord extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late String plannedBedtime;

  @HiveField(2)
  String? actualBedtime;

  @HiveField(3)
  bool? wentToBedOnTime;

  @HiveField(4)
  int? quality; // 1-5

  SleepRecord({
    required this.date,
    required this.plannedBedtime,
    this.actualBedtime,
    this.wentToBedOnTime,
    this.quality,
  });
}
