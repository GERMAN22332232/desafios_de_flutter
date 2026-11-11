import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafío 3 - App Completa',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal, // Mantiene el tono verde elegante que elegiste
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _seccionActual = 0;

  // Lista de tareas compartida para que el contador de Inicio y la pantalla Tareas funcionen juntos
  final List<Map<String, dynamic>> _tareas = [
    {'titulo': 'Estudiar Flutter y Material 3', 'completada': true},
    {'titulo': 'Completar el Desafío 3', 'completada': false},
  ];

  final TextEditingController _taskController = TextEditingController();

  // Función para agregar tareas nuevas
  void _agregarTarea(String titulo) {
    if (titulo.trim().isEmpty) return;
    setState(() {
      _tareas.add({'titulo': titulo, 'completada': false});
    });
    _taskController.clear();
  }

  // Función para marcar o desmarcar una tarea como hecha
  void _toggleTarea(int index) {
    setState(() {
      _tareas[index]['completada'] = !_tareas[index]['completada'];
    });
  }

  // Función para eliminar tareas
  void _eliminarTarea(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cálculos en tiempo real para las estadísticas del inicio
    int total = _tareas.length;
    int hechas = _tareas.where((t) => t['completada'] == true).length;
    int pendientes = total - hechas;

    // Pantallas de la app conectadas a la misma lógica de estado
    final List<Widget> pantallas = [
      InicioTab(total: total, hechas: hechas, pendientes: pendientes),
      TareasTab(
        tareas: _tareas,
        controller: _taskController,
        onAgregar: _agregarTarea,
        onToggle: _toggleTarea,
        onEliminar: _eliminarTarea,
      ),
      const PerfilTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_seccionActual == 0
            ? 'Inicio'
            : _seccionActual == 1
                ? 'Tareas'
                : 'Perfil'),
      ),
      // Drawer completo con diseño Material 3 requerido[span_1](start_span)[span_1](end_span)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('GE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
              ),
              accountName: Text('Germán Esquivel', style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('german@email.com'),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: () {
                setState(() => _seccionActual = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              onTap: () {
                setState(() => _seccionActual = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Perfil'),
              onTap: () {
                setState(() => _seccionActual = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: pantallas[_seccionActual],
      // NavigationBar moderno de Material 3[span_2](start_span)[span_2](end_span)[span_3](start_span)[span_3](end_span)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccionActual,
        onDestinationSelected: (index) {
          setState(() => _seccionActual = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// PANTALLA DE INICIO (Banner + 3 Tarjetas de Estadísticas)[span_4](start_span)[span_4](end_span)
// ----------------------------------------------------
class InicioTab extends StatelessWidget {
  final int total;
  final int hechas;
  final int pendientes;

  const InicioTab({super.key, required this.total, required this.hechas, required this.pendientes});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner decorativo superior usando colores del ColorScheme[span_5](start_span)[span_5](end_span)[span_6](start_span)[span_6](end_span)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tenés $pendientes tareas pendientes para hoy.',
                  style: TextStyle(
                    fontSize: 16,
                    color: cs.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tarjetas de Estadísticas en una Row[span_7](start_span)[span_7](end_span)
          Row(
            children: [
              Expanded(child: _StatCard(icon: Icons.list, title: 'Tareas', value: '$total', color: Colors.blue)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(icon: Icons.check_circle_outline, title: 'Hechas', value: '$hechas', color: Colors.green)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(icon: Icons.pending_actions, title: 'Pendientes', value: '$pendientes', color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// PANTALLA DE TAREAS (Funcional: Agregar, marcar y eliminar)
// ----------------------------------------------------
class TareasTab extends StatelessWidget {
  final List<Map<String, dynamic>> tareas;
  final TextEditingController controller;
  final Function(String) onAgregar;
  final Function(int) onToggle;
  final Function(int) onEliminar;

  const TareasTab({
    super.key,
    required this.tareas,
    required this.controller,
    required this.onAgregar,
    required this.onToggle,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Campo de texto y botón para agregar tareas sin que se vea tosco
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Escribe una nueva tarea...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => onAgregar(controller.text),
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Lista de tareas con casillas de verificación funcionales
          Expanded(
            child: tareas.isEmpty
                ? const Center(child: Text('No hay tareas agregadas', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea['completada'],
                            onChanged: (val) => onToggle(index),
                          ),
                          title: Text(
                            tarea['titulo'],
                            style: TextStyle(
                              decoration: tarea['completada'] ? TextDecoration.lineThrough : null,
                              color: tarea['completada'] ? Colors.grey : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => onEliminar(index),
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

// ----------------------------------------------------
// PANTALLA DE PERFIL
// ----------------------------------------------------
class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          SizedBox(height: 16),
          Text('Germán Esquivel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Estudiante de Desarrollo de Software', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}