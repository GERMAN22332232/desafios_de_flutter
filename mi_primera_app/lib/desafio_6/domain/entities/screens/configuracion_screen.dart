import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('preferencias');
    final bool modoOscuro = box.get('modoOscuro', defaultValue: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: SwitchListTile(
        title: const Text('Modo Oscuro'),
        subtitle: const Text('Cambiar el tema de la aplicación'),
        value: modoOscuro,
        onChanged: (val) {
          box.put('modoOscuro', val); // Guarda en Hive de forma persistente
        },
      ),
    );
  }
}