class Asignatura {
  String? nombre;
  String? codigo;
  int? curso;
  Asignatura({
    this.nombre, this.codigo, this.curso
  });
}

class Curso {
  String id;
  String name;
  String teacher;
  Curso({
    required this.id, required this.name, required this.teacher
  });
}
