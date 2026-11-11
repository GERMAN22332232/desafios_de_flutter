 // 29. Crear la clase Alumno con nombre, apellido, edad y una lista de 3 notas
class Alumno {
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas;

  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  // 30. Método calcularPromedio() que devuelva el promedio de las 3 notas
  double calcularPromedio() {
    if (notas.isEmpty) return 0.0;
    double suma = notas.reduce((a, b) => a + b);
    return suma / notas.length;
  }

  // 31. Método estadoFinal() que devuelva 'Aprobado', 'Recuperatorio' o 'Desaprobado'
  String estadoFinal() {
    double promedio = calcularPromedio();
    if (promedio >= 6.0) {
      return 'Aprobado';
    } else if (promedio >= 4.0) {
      return 'Recuperatorio';
    } else {
      return 'Desaprobado';
    }
  }

  // 32. Método toString() que muestre el nombre completo y el estado
  @override
  String toString() {
    return '$nombre $apellido - Estado: ${estadoFinal()} (Promedio: ${calcularPromedio().toStringAsFixed(1)})';
  }
}

void main() {
  // 33. Crear una lista de 5 alumnos distintos y mostrar el estado de cada uno
  List<Alumno> alumnos = [
    Alumno(nombre: 'Sofía', apellido: 'Pérez', edad: 17, notas: [8.5, 9.0, 9.5]),
    Alumno(nombre: 'Lucas', apellido: 'Gómez', edad: 16, notas: [4.0, 5.0, 4.5]),
    Alumno(nombre: 'Ana', apellido: 'Torres', edad: 18, notas: [9.0, 9.5, 10.0]),
    Alumno(nombre: 'Mateo', apellido: 'Díaz', edad: 17, notas: [3.0, 2.5, 4.0]),
    Alumno(nombre: 'Valentina', apellido: 'Ruiz', edad: 16, notas: [6.0, 7.0, 6.5]),
  ];

  print('=== LISTA DE ALUMNOS ===');
  for (var alumno in alumnos) {
    print(alumno); // Llama automáticamente al método toString()
  }

  // 34. Encontrar e imprimir el alumno con el promedio más alto
  Alumno mejorAlumno = alumnos.reduce((a, b) => 
    a.calcularPromedio() > b.calcularPromedio() ? a : b
  );
  print('\n⭐ Alumno con el promedio más alto: ${mejorAlumno.nombre} ${mejorAlumno.apellido} con ${mejorAlumno.calcularPromedio()}');

  // 35. Contar cuántos aprobaron y cuántos desaprobaron
  int aprobados = alumnos.where((a) => a.estadoFinal() == 'Aprobado').length;
  int recuperatorios = alumnos.where((a) => a.estadoFinal() == 'Recuperatorio').length;
  int desaprobados = alumnos.where((a) => a.estadoFinal() == 'Desaprobado').length;

  print('\n📊 Resumen del curso:');
  print('- Aprobados: $aprobados');
  print('- Recuperatorios: $recuperatorios');
  print('- Desaprobados: $desaprobados');

  // 36. EXTRA: Ordenar la lista por promedio de mayor a menor usando list.sort()
  alumnos.sort((a, b) => b.calcularPromedio().compareTo(a.calcularPromedio()));

  print('\n=== ALUMNOS ORDENADOS POR PROMEDIO (MAYOR A MENOR) ===');
  for (var alumno in alumnos) {
    print('${alumno.nombre} ${alumno.apellido}: ${alumno.calcularPromedio().toStringAsFixed(1)}');
  }
}