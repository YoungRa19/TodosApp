import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todosapp/data/asignatura.dart';
import 'package:uuid/uuid.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  List<Asignatura> asignaturas = [];
  TextEditingController _textEditing = TextEditingController();
  bool _validate = false;
  int number = 0;

  @override
  void dispose() {
    _textEditing.dispose();
    super.dispose();
  }

  void addSignature() {
    showProcess(context);
  }

  showProcess(BuildContext context, {Asignatura? asignatura, int? id}) {
    String title =
    asignatura == null ? "Nueva Asignatura" : "Editar ${asignatura.nombre}";
    return showDialog(
        context: context,
        builder: (
            context,
            ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  title: Text(title),
                  content: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextField(
                        controller: _textEditing,
                        onChanged: (data) {
                          setState(() {
                            _validate = data.isEmpty;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre',
                            errorText:
                            _validate ? "No puede ser un valor vacío" : null,
                            errorStyle: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _validate = false;
                          });
                          _textEditing.clear();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          if (_textEditing.value.text.isNotEmpty) {
                            if (asignatura != null) {
                              asignaturas[id!].nombre = _textEditing.value.text;
                              this.setState(() {
                                asignaturas;
                              });
                            } else {
                              asignaturas.add(Asignatura(
                                  codigo: Uuid().v4(),
                                  nombre: _textEditing.value.text,
                                  curso: Random().nextDouble().toInt()));
                              _textEditing.clear();
                              this.setState(() {
                                asignaturas;
                                _validate = false;
                              });
                            }
                            Navigator.pop(context);
                          } else {
                            this.setState(() {
                              _validate = _textEditing.text.isEmpty;
                            });
                          }
                        },
                        child: Text(
                          "Aceptar",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                );
              });
        });
  }

  void delete(int id) {
    asignaturas.removeAt(id);
    setState(() {
      asignaturas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de todos",
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: addSignature,
            icon: Icon(Icons.add),
            color: Colors.blue,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Column(
          children: [
            if (asignaturas.isEmpty)
              Expanded(
                  child: Center(
                    child: Text(
                      "No hay datos disponibles",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )),
            if (asignaturas.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: asignaturas.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              asignaturas[idx].nombre,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _textEditing.text = asignaturas[idx].nombre;
                                  showProcess(context,
                                      asignatura: asignaturas[idx], id: idx);
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.orange,
                              ),
                              IconButton(
                                onPressed: () {
                                  delete(idx);
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}