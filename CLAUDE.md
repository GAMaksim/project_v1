# Zzz — Premium Sleep Ritual App

## 🎯 Суть проекта

Мобильное приложение для улучшения сна через **вечерние ритуалы**.

**Главная идея:** Умный коуч, который ГОТОВИТ пользователя ко сну через серию push-уведомлений:
- Напоминает поужинать за 4 часа до сна
- Начинает ритуал за 1 час (приглушить свет, закончить работу)
- За 30 минут — умыться, почистить зубы
- За 20 минут — убрать телефон, включить музыку
- За 10 минут — лечь, расслабиться

**Уникальность:** При выборе времени сна — показывает Sleep Score (0-100) и объясняет пользу/вред. Например: выбрал 00:00 → "⚠️ Повышенный кортизол. Рекомендуем: 22:30"

---

## 👤 Разработчик

- Один fullstack разработчик (Узбекистан)
- Цель: lifestyle бизнес, $100k/год, минимум времени после запуска
- Монетизация через App Store / Google Play

---

## 📱 Платформы и стек

- **Flutter** (Dart, последняя стабильная версия)
- **Hive** — локальная БД (офлайн, быстрая NoSQL)
- **flutter_local_notifications** — локальные push-уведомления
- **firebase_messaging** — FCM для фоновых уведомлений
- **just_audio** + **audio_service** — фоновое аудио
- **purchases_flutter** — RevenueCat (подписки)
- **go_router** — навигация
- **flutter_riverpod** — управление состоянием
- **google_fonts** — Cormorant Garamond + Inter
- **flutter_animate** — плавные анимации

### pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_local_notifications: ^17.0.0
  firebase_core: ^3.0.0
  firebase_messaging: ^15.0.0
  just_audio: ^0.9.40
  audio_service: ^0.18.15
  purchases_flutter: ^7.0.0
  go_router: ^14.0.0
  flutter_riverpod: ^2.5.0
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
```

---

## 🎨 Дизайн-система (СТРОГО СОБЛЮДАТЬ)

### Цвета (lib/core/theme/app_colors.dart):
```dart
static const Color deepIndigo    = Color(0xFF2d3561); // Главный бренд
static const Color softMauve     = Color(0xFFb8a9c9); // Акцент
static const Color warmSand      = Color(0xFFe8d5c4); // Вторичный акцент
static const Color goldAccent    = Color(0xFFd4af37); // Только premium
static const Color cream         = Color(0xFFfaf8f5); // Основной фон
static const Color whisperGray   = Color(0xFFe5e3df); // Границы
static const Color textPrimary   = Color(0xFF1a1a1a);
static const Color textSecondary = Color(0xFF6b6b6b);
static const Color success       = Color(0xFF7ba88d);
static const Color warning       = Color(0xFFc9a88b);
```

### Шрифты:
```dart
// Заголовки — элегантный serif
GoogleFonts.cormorantGaramond(fontSize: 42, fontWeight: FontWeight.w500)

// Текст — современный sans
GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400)
```

### Стиль:
- Элегантный, минималистичный, **ПРЕМИУМ**
- Padding: 24px по бокам
- Анимации: 400-600ms, Curves.easeOut
- Максимум 1 emoji на сообщение
- Тон: спокойный, как Calm/Headspace

---

## 🗂️ Структура проекта

```
zzz/
├── CLAUDE.md
├── TASKS.md
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_theme.dart
│   │   ├── constants/
│   │   │   ├── sounds.dart
│   │   │   └── notification_content.dart
│   │   ├── utils/
│   │   │   ├── sleep_score.dart
│   │   │   ├── streak_calculator.dart
│   │   │   └── time_helpers.dart
│   │   └── router/
│   │       └── app_router.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_settings.dart        (Hive model)
│   │   │   ├── sleep_schedule.dart       (Hive model)
│   │   │   └── sleep_record.dart         (Hive model)
│   │   └── services/
│   │       ├── database_service.dart
│   │       ├── notification_service.dart
│   │       ├── audio_service.dart
│   │       └── purchase_service.dart
│   ├── providers/
│   │   ├── settings_provider.dart
│   │   ├── schedule_provider.dart
│   │   ├── statistics_provider.dart
│   │   └── audio_provider.dart
│   └── ui/
│       ├── screens/
│       │   ├── onboarding/onboarding_screen.dart
│       │   ├── schedule/schedule_setup_screen.dart
│       │   ├── home/home_screen.dart
│       │   ├── soundscapes/soundscapes_screen.dart
│       │   ├── statistics/statistics_screen.dart
│       │   └── settings/settings_screen.dart
│       ├── widgets/
│       │   ├── day_selector.dart
│       │   ├── sleep_score_badge.dart
│       │   ├── recommendation_card.dart
│       │   ├── timer_circle.dart
│       │   ├── notification_card.dart
│       │   ├── stat_card.dart
│       │   ├── calendar_grid.dart
│       │   ├── music_preset_tile.dart
│       │   └── premium_paywall.dart
│       └── shared/
│           ├── primary_button.dart
│           └── app_bottom_nav.dart
└── assets/
    └── sounds/
        ├── free/ (white_noise.mp3, rain.mp3, ocean.mp3)
        └── premium/ (fireplace.mp3, forest.mp3, piano.mp3, meditation.mp3, lullaby.mp3)
```

---

## 🗄️ Hive модели

```dart
@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0) late bool isPremium;
  @HiveField(1) late bool onboardingCompleted;
  @HiveField(2) late String language;        // 'en' | 'ru'
  @HiveField(3) String? selectedSoundId;
  @HiveField(4) late bool notificationsEnabled;
}

@HiveType(typeId: 1)
class SleepSchedule extends HiveObject {
  @HiveField(0) late int dayOfWeek;          // 0=Sun...6=Sat
  @HiveField(1) late String plannedBedtime;  // "22:00"
  @HiveField(2) late bool isEnabled;
}

@HiveType(typeId: 2)
class SleepRecord extends HiveObject {
  @HiveField(0) late DateTime date;
  @HiveField(1) late String plannedBedtime;
  @HiveField(2) String? actualBedtime;
  @HiveField(3) bool? wentToBedOnTime;
  @HiveField(4) int? quality;               // 1-5
}
```

---

## 🔔 Push-уведомления (6 типов)

| Тип | Когда | Title |
|-----|-------|-------|
| dinner | bedtime - 4h | "🍽 Dinner Moment" |
| ritual_start | bedtime - 1h | "🌙 Begin Ritual" |
| evening_care | bedtime - 30m | "✨ Evening Care" |
| digital_sunset | bedtime - 20m | "📱 Digital Sunset" |
| final_moment | bedtime - 10m | "😌 Final Moment" |
| still_awake | bedtime + 30m | "🤔 Still awake?" |

Используем `matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime` для еженедельного повтора.

---

## 🎵 Звуки

- **Free (3):** white_noise, rain, ocean
- **Premium (5):** fireplace, forest, piano, meditation, lullaby
- При тапе на premium → показать `PremiumPaywall`
- Автостоп через 60 минут
- Работает в фоне через `audio_service`

---

## 😴 Sleep Score

```
21:00–22:30 → Score 90+ "Excellent" (success цвет)
22:30–23:00 → Score 78  "Good"      (softMauve)
23:00–00:00 → Score 65  "Fair"      (warning цвет)
после 00:00 → Score 40  "Poor"      (красный)
```

---

## 💰 Монетизация

- **Free:** 3 звука, все пуши, статистика 7 дней, streak
- **Premium:** все звуки, безлимит статистика, все достижения
- **Цена:** $3.99/мес или $34.99/год
- **Trial:** 7 дней бесплатно
- **Soft paywall:** на 3-й день (закрываемый)
- **Hard paywall:** на 7-й день (обязательный)

---

## 📊 Экран Statistics

1. Restful Nights — X/30 дней + прогресс-бар
2. Streak badges — текущая / лучшая серия
3. Average Timing — план vs реальность + отклонение
4. Monthly Progression — 3 месяца с трендом
5. Calendar — цветные ячейки (зелёный/красный/сегодня)
6. Achievements — ✦ 7 дней / ⭑ 30 дней / ✧ 90 дней

---

## 🌍 Языки

- English (основной, запуск)
- Russian (через 1-2 месяца после запуска)

---

## ⚠️ Правила разработки

1. **Всё локально** — нет backend, всё в Hive
2. **Офлайн first** — работает без интернета
3. **Цвета** — только из `AppColors`
4. **Шрифты** — только Cormorant + Inter
5. **State** — только Riverpod
6. **Анимации** — flutter_animate, 400-600ms
7. **Premium guard** — проверять `isPremium` перед premium
8. **Без dynamic** — строгая типизация Dart

---

## 🚫 НЕ делать в MVP

- Sleep debt трекинг
- Факторы сна (кофе, алкоголь)
- Spotify интеграция
- Умный будильник
- Социальные функции
- Экспорт в Health
- AI рекомендации

---

## 📍 Статус

Смотри **TASKS.md** для текущего прогресса.
