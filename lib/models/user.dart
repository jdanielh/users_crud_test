class User {
  final int? id;
  final String name;
  final int sex;
  final String dateOfBirth;

  const User({
     this.id,
    required this.name,
    required this.sex,
    required this.dateOfBirth,
  });

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'birthday': dateOfBirth,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, sex: $sex}';
  }
}