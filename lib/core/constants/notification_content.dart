class NotificationContent {
  final String titleEn;
  final String titleRu;
  final String bodyEn;
  final String bodyRu;
  final int offsetMinutes; // negative = before bedtime, positive = after

  const NotificationContent({
    required this.titleEn,
    required this.titleRu,
    required this.bodyEn,
    required this.bodyRu,
    required this.offsetMinutes,
  });

  String title(String lang) => lang == 'ru' ? titleRu : titleEn;
  String body(String lang) => lang == 'ru' ? bodyRu : bodyEn;
}

class NotificationContents {
  NotificationContents._();

  static const dinner = NotificationContent(
    titleEn: '🍽 Dinner Moment',
    titleRu: '🍽 Время ужина',
    bodyEn: 'Time for your last meal. A light dinner helps you sleep better.',
    bodyRu: 'Время последнего приёма пищи. Лёгкий ужин — залог хорошего сна.',
    offsetMinutes: -240,
  );

  static const ritualStart = NotificationContent(
    titleEn: '🌙 Begin Ritual',
    titleRu: '🌙 Начни ритуал',
    bodyEn: 'Dim the lights. Wrap up your work. Your evening begins now.',
    bodyRu: 'Приглуши свет. Заверши дела. Твой вечер начинается.',
    offsetMinutes: -60,
  );

  static const eveningCare = NotificationContent(
    titleEn: '✨ Evening Care',
    titleRu: '✨ Вечерний уход',
    bodyEn: 'Wash up, brush your teeth. Prepare for a restful night.',
    bodyRu: 'Умойся, почисти зубы. Подготовься к спокойной ночи.',
    offsetMinutes: -30,
  );

  static const digitalSunset = NotificationContent(
    titleEn: '📱 Digital Sunset',
    titleRu: '📱 Цифровой закат',
    bodyEn: 'Put your phone away. Turn on calming sounds if you\'d like.',
    bodyRu: 'Убери телефон. Включи спокойные звуки, если хочешь.',
    offsetMinutes: -20,
  );

  static const finalMoment = NotificationContent(
    titleEn: '😌 Final Moment',
    titleRu: '😌 Последний момент',
    bodyEn: 'Lie down, close your eyes. You\'ve earned this rest.',
    bodyRu: 'Ложись, закрой глаза. Ты заслужил этот отдых.',
    offsetMinutes: -10,
  );

  static const stillAwake = NotificationContent(
    titleEn: '🤔 Still awake?',
    titleRu: '🤔 Ещё не спишь?',
    bodyEn: 'It\'s past your bedtime. Ready to sleep?',
    bodyRu: 'Твоё время сна прошло. Готов уснуть?',
    offsetMinutes: 30,
  );

  static const List<NotificationContent> all = [
    dinner,
    ritualStart,
    eveningCare,
    digitalSunset,
    finalMoment,
    stillAwake,
  ];
}
