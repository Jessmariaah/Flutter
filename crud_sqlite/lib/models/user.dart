class UserModel {
  final int? id;
  final String name;
  final String email;
  final String telefone; // Novo campo

  UserModel({
    this.id, 
    required this.name, 
    required this.email,
    this.telefone = '', // Padrão vazio: NÃO obriga alterar todas as chamadas no código!
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telefone': telefone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      telefone: map['telefone'] ?? '',
    );
  }
}