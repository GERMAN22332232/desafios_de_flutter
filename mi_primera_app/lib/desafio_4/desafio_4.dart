import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// 1. ESTADO Y NOTIFIER CON RIVERPOD
// ==========================================
class TasksState {
  final List<String> tareas;
  final int completadas;

  const TasksState({
    this.tareas = const [],
    this.completadas = 0,
  });

  int get pendientes => tareas.length - completadas;
}

class TasksNotifier extends Notifier<TasksState> {
  @override
  TasksState build() => const TasksState();

  void agregar(String titulo) {
    state = TasksState(
      tareas: [...state.tareas, titulo],
      completadas: state.completadas,
    );
  }

  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(
      tareas: nuevas,
      completadas: state.completadas,
    );
  }
}

// Provider global accesible desde cualquier widget
final tasksProvider = NotifierProvider<TasksNotifier, TasksState>(
  TasksNotifier.new,
);

// ==========================================
// 2. FUNCIÓN PRINCIPAL (PROVIDER SCOPE)
// ==========================================
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafío 4 - Riverpod',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ==========================================
// 3. PANTALLA PRINCIPAL (DRAWER Y NAVIGATION BAR)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  // Las 3 secciones requeridas por el desafío
  final List<Widget> _pantallas = const [
    InicioTab(),
    TareasTab(),
    PerfilTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Tareas (Riverpod)'),
      ),
      // Menú lateral Drawer requerido
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text('AG', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Text('Agustín García', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('agus@gmail.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() => _seccion = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              onTap: () {
                setState(() => _seccion = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                setState(() => _seccion = 2);
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
      body: _pantallas[_seccion],
      // Menú inferior NavigationBar (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int indice) {
          setState(() => _seccion = indice);
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
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. PESTAÑAS (INICIO, TAREAS, PERFIL)
// ==========================================

// Pestaña de Inicio (Muestra el contador usando ref.watch)[span_5](start_span)[span_5](end_span)
class InicioTab extends ConsumerWidget {
  const InicioTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bienvenido a la App', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text('${state.pendientes}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const Text('Tareas pendientes', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pestaña de Tareas (Lista completa con TextField para agregar y opción de eliminar)[span_6](start_span)[span_6](end_span)
class TareasTab extends ConsumerStatefulWidget {
  const TareasTab({super.key});

  @override
  ConsumerState<TareasTab> createState() => _TareasTabState();
}

class _TareasTabState extends ConsumerState<TareasTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Nueva tarea...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    ref.read(tasksProvider.notifier).agregar(_controller.text);
                    _controller.clear();
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: state.tareas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.tareas[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(tasksProvider.notifier).eliminar(index);
                    },
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

// Pestaña de Perfil
class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Configuración y Perfil de Usuario', style: TextStyle(fontSize: 18)),
    );
  }
}