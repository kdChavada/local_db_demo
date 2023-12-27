import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/dog_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*------ db Variable ----*/
  var database;

  @override
  void initState() {
    super.initState();
    dbCreate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var fido = const Dog(
                id: 0,
                name: 'ram',
                age: 45,
              );
              await insertDog(fido);
            },
            child: const Text("Add Detail"),
          ),
          ElevatedButton(
            onPressed: () async {
              print(await dogs());
            },
            child: const  Text("View"),
          ),

          ElevatedButton(onPressed: ()async{
           /* [Dog{id: 0, name: ram, age: 45}, Dog{id: 3, name: ram, age: 45}, Dog{id: 4, name: ram, age: 45}, Dog{id: 5, name: ram, age: 45}, Dog{id: 6, name: ram, age: 45}, Dog{id: 7, name: ram, age: 45}, Dog{id: 8, name: ram, age: 45}, Dog{id: 9, name: ram, age: 45}, Dog{id: 10, name: ram, age: 45}]*/
            deleteDog(5);

          }, child: const Text("Delete"))

        ],
      ),
    );
  }

  dbCreate() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER  AUTO_INCREMENT, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;


    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        age: maps[i]['age'] as int,
      );
    });
  }


  /*------ Delete ------*/
  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
     /* where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],*/
    );
  }
}
