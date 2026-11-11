import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

final auth = FirebaseAuth.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Future<String?> _intentar(Future<dynamic> accion) async {
  try {
    await accion;
    return null; // null = sin error = exitoso
  } on FirebaseAuthException catch (e) {
    return switch (e.code) {
      'weak-password' => 'La contraseña debe tener al menos 6 caracteres.',
      'email-already-in-use' => 'Este email ya está registrado.',
      'invalid-email' => 'El formato del email no es válido.',
      'invalid-credential' => 'Email o contraseña incorrectos.',
      _ => 'Error: ${e.message}',
    };
  }
}

Future<String?> registrar(String e, String p) => _intentar(auth.createUserWithEmailAndPassword(email: e.trim(), password: p));
Future<String?> iniciarSesion(String e, String p) => _intentar(auth.signInWithEmailAndPassword(email: e.trim(), password: p));
Future<void> cerrarSesion() => auth.signOut();
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (_, s) => s.hasData ? const HomeScreen() : const LoginScreen()));
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}
class _LoginState extends State<LoginScreen> {
  final _e = TextEditingController(), _p = TextEditingController();
  Future<void> _ir(bool nuevo) async {
    final r = await (nuevo ? registrar : iniciarSesion)(_e.text, _p.text);
    if (r != null && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r)));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(controller: _e, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: _p, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
        FilledButton(onPressed: () => _ir(false), child: const Text('Entrar')),
        TextButton(onPressed: () => _ir(true), child: const Text('Registrarme')),
      ])));
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(auth.currentUser?.email ?? ''), actions: [IconButton(onPressed: cerrarSesion, icon: const Icon(Icons.logout))]),
      body: const Center(child: Text('Sesión iniciada')));
}