import 'package:flutter/material.dart';

void main() => runApp(const TarjetaApp());

class TarjetaApp extends StatelessWidget {
  const TarjetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TarjetaScreen(),
    );
  }
}

class TarjetaScreen extends StatefulWidget {
  const TarjetaScreen({super.key});

  @override
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {
  bool _fondoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoOscuro ? Colors.blueGrey.shade900 : Colors.amber.shade50,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 44. Foto circular con tu imagen
                const CircleAvatar(
                  radius: 80, // Aumenté el tamaño para que se aprecie mejor tu foto
                  backgroundColor: Colors.indigo, // Un borde sutil
                  child: CircleAvatar(
                    radius: 76,
                    backgroundImage: AssetImage('assets/images/tu_rostro.jpg'), // <-- Asegúrate de tener tu imagen aquí
                  ),
                ),
                const SizedBox(height: 24),
                // 45. Nombre grande (puedes cambiarlo por tu nombre si quieres)
                Text(
                  'Agustín Rodríguez',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _fondoOscuro ? Colors.white : Colors.indigo.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                // 46. Rol en gris
                const Text(
                  'Estudiante de Desarrollo de Apps con Flutter\n(Desafío 2)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _fondoOscuro ? Colors.black26 : Colors.white54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _fondoOscuro ? Icons.dark_mode : Icons.light_mode,
                        color: _fondoOscuro ? Colors.amber : Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Modo Oscuro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _fondoOscuro ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Switch(
                        value: _fondoOscuro,
                        activeColor: Colors.amber,
                        onChanged: (v) => setState(() => _fondoOscuro = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 48. Botón con SnackBar
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Hola! Soy tu tarjeta de presentación.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.waving_hand),
                  label: const Text('Saludar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}