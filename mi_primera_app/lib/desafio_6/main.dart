import 'domain/entities/screens/tareas_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('preferencias'); 
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferencias').listenable(),
      builder: (context, box, child) {
        final bool modoOscuro = box.get('modoOscuro', defaultValue: false);

        return MaterialApp(
          title: 'Desafío 6 - SQLite y Hive',
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          themeMode: modoOscuro ? ThemeMode.dark : ThemeMode.light,
          home: const TareasScreen(), // Tu pantalla principal
        );
      },
    );
  }
}