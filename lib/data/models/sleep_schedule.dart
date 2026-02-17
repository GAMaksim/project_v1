import 'package:hive/hive.dart';

part 'sleep_schedule.g.dart';

@HiveType(typeId: 1)
class SleepSchedule extends HiveObject {
  @HiveField(0)
  late int dayOfWeek; // 0=Sun, 1=Mon, ..., 6=Sat

  @HiveField(1)
  late String plannedBedtime; // "22:00"

  @HiveField(2)
  late bool isEnabled;

  SleepSchedule({
    required this.dayOfWeek,
    this.plannedBedtime = '22:30',
    this.isEnabled = true,
  });
}
