import 'package:flutter/material.dart';
import '../../../data/local/local_database.dart';
import '../tarea.dart';
import 'configuracion_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final LocalDatabase _db = LocalDatabase();
  final TextEditingController _tituloController = TextEditingController();
  
  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  // Leer tareas de SQLite
  Future<void> _cargarTareas() async {
    final tareasList = await _db.obtenerTodas();
    setState(() {
      _tareas = tareasList;
    });
  }

  // Agregar tarea
  Future<void> _agregarTarea() async {
    if (_tituloController.text.isEmpty) return;

    final nuevaTarea = Tarea(
      titulo: _tituloController.text,
      fecha: DateTime.now().toString().substring(0, 10),
    );

    await _db.insertar(nuevaTarea);
    _tituloController.clear();
    _cargarTareas(); // Recargar la lista
  }

  // Eliminar tarea
  Future<void> _eliminarTarea(int id) async {
    await _db.eliminar(id);
    _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas (SQLite)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConfiguracionScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _agregarTarea,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return Dismissible(
                  key: Key(tarea.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _eliminarTarea(tarea.id!);
                  },
                  child: ListTile(
                    title: Text(tarea.titulo),
                    subtitle: Text('Fecha: ${tarea.fecha}'),
                    trailing: Checkbox(
                      value: tarea.completada,
                      onChanged: (val) async {
                        final tareaActualizada = tarea.copyWith(completada: val);
                        await _db.actualizar(tareaActualizada);
                        _cargarTareas();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}