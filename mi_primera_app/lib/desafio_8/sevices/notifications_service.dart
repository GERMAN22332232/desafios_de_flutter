import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // Llamar ANTES de runApp() en main()
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      settings: const InitializationSettings(android: android),
    );

    // Android 13+ exige pedir permiso para mostrar notificaciones
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Muestra una notificación inmediata (alerta flotante)
  static Future<void> mostrarNotificacion({
    required String titulo,
    required String cuerpo,
  }) async {
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titulo,
      body: cuerpo,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_asistencia',
          'Asistencia',
          channelDescription: 'Avisos de registro de asistencia',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}