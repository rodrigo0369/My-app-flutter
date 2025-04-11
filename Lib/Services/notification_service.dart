import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('diabetes_channel', 'Diabetes Notificaciones',
            importance: Importance.max, priority: Priority.high);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleDailyNotification(
      int id, String title, String body, Time time) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('diabetes_channel', 'Diabetes Notificaciones',
            importance: Importance.max, priority: Priority.high);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      const NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
Future<void> scheduleDailyReminder(TimeOfDay time, String message) async {
  final androidDetails = AndroidNotificationDetails(
    'daily_reminder_channel',
    'Daily Reminder',
    channelDescription: 'Recordatorio diario inteligente',
    importance: Importance.max,
    priority: Priority.high,
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  final now = DateTime.now();
  final scheduledTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Recordatorio',
    message,
    tz.TZDateTime.from(scheduledTime, tz.local).isBefore(tz.TZDateTime.now(tz.local))
        ? tz.TZDateTime.from(scheduledTime.add(Duration(days: 1)), tz.local)
        : tz.TZDateTime.from(scheduledTime, tz.local),
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
