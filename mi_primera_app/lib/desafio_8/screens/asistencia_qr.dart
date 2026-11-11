import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// QR de referencia: el código que debe escanearse para registrar asistencia
const String qrAsistencia = 'https://qrco.de/bh5fEb';

// Para correr solo este desafío:
// flutter run -t lib/desafio_8/screens/asistencia_screen.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AsistenciaScreen(),
  ));
}

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({super.key});

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  bool _escaneando = false;
  final List<DateTime> _historial = [];

  Future<void> _alDetectar(BarcodeCapture captura) async {
    if (!_escaneando || captura.barcodes.isEmpty) return;
    final codigo = captura.barcodes.first.rawValue;
    if (codigo == null) return;

    // Al apagar el escáner, el widget se quita y la cámara se libera
    setState(() => _escaneando = false);

    // Acepta el enlace completo o cualquier variante que contenga su código
    if (codigo.contains('bh5fEb')) {
      setState(() => _historial.insert(0, DateTime.now()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tu asistencia se registró correctamente.'),
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código QR no válido. Se leyó: $codigo')),
      );
    }
  }

  String _formato(DateTime d) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(d.day)}/${dos(d.month)}/${d.year}  ${dos(d.hour)}:${dos(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control de asistencia')),
      body: Column(
        children: [
          // Zona superior: cámara cuando se escanea, botón si no
          SizedBox(
            height: 280,
            child: _escaneando
                ? MobileScanner(onDetect: _alDetectar)
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.qr_code_scanner, size: 72),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => setState(() => _escaneando = true),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Escanear QR'),
                        ),
                      ],
                    ),
                  ),
          ),
          if (_escaneando)
            TextButton(
              onPressed: () => setState(() => _escaneando = false),
              child: const Text('Cancelar'),
            ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: SelectableText('Enlace de referencia: $qrAsistencia'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Historial de asistencias',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _historial.isEmpty
                ? const Center(child: Text('Aún no hay asistencias.'))
                : ListView.builder(
                    itemCount: _historial.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: const Icon(Icons.check_circle,
                          color: Colors.green),
                      title: Text('Asistencia #${_historial.length - i}'),
                      subtitle: Text(_formato(_historial[i])),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}