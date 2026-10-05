class UserModel {
  final int? id;
  final String name;
  final String email;

  UserModel({this.id, required this.name, required this.email});

  // Converte o objeto UserModel num Map para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Cria um UserModel a partir de um Map vindo do SQLite
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}