import 'package:flutter/material.dart';
import 'produto.dart';
import 'tela_lista_produtos.dart';
import 'tela_form_produto.dart';
import 'tela_login.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // Lista global de produtos mantida em memória
  final List<Produto> listaProdutos = [
    Produto(codigo: 'P001', descricao: 'Notebook Dell', tipo: 'Eletrônicos', preco: 4500.00, quantidadeEstoque: 12),
    Produto(codigo: 'P002', descricao: 'Mouse Sem Fio', tipo: 'Acessórios', preco: 89.90, quantidadeEstoque: 45),
    Produto(codigo: 'P003', descricao: 'Teclado Mecânico', tipo: 'Acessórios', preco: 250.00, quantidadeEstoque: 20),
    Produto(codigo: 'P004', descricao: 'Monitor 27"', tipo: 'Eletrônicos', preco: 1300.00, quantidadeEstoque: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Principal'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.analytics, size: 40, color: Colors.deepPurple),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // <-- CORRIGIDO AQUI
                      children: [
                        const Text('Total de Produtos Cadastrados', style: TextStyle(color: Colors.grey)),
                        Text('${listaProdutos.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _criarBotaoMenu(
                    icon: Icons.list_alt,
                    titulo: 'Listar Produtos',
                    cor: Colors.blue,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaListaProdutos(produtos: listaProdutos),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                  _criarBotaoMenu(
                    icon: Icons.add_box,
                    titulo: 'Cadastrar Produto',
                    cor: Colors.green,
                    onTap: () async {
                      final produtoNovo = await Navigator.push<Produto>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaFormProduto(),
                        ),
                      );
                      if (produtoNovo != null) {
                        setState(() {
                          listaProdutos.add(produtoNovo);
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Produto cadastrado com sucesso!')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _criarBotaoMenu({
    required IconData icon,
    required String titulo,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: cor),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}