import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  void _refreshUserList() async {
    final data = await _dbHelper.getUsers();
    setState(() {
      _users = data;
    });
  }

  void _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _refreshUserList();
  }

  void _navigateToForm([UserModel? user]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserFormScreen(user: user)),
    );
    if (result == true) {
      _refreshUserList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Utilizadores'),
      ),
      body: _users.isEmpty
          ? const Center(child: Text('Nenhum utilizador cadastrado.'))
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToForm(user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}