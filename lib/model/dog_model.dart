class Dog {
 final int id;
 final String name;
 final int age;

  const Dog({
   required this.id,
   required  this.name,
    required this.age,
  });

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
