import 'package:flutter/material.dart';
import 'produto.dart';
import 'tela_detalhes_produto.dart';
import 'tela_form_produto.dart';

class TelaListaProdutos extends StatefulWidget {
  final List<Produto> produtos;

  const TelaListaProdutos({super.key, required this.produtos});

  @override
  State<TelaListaProdutos> createState() => _TelaListaProdutosState();
}

class _TelaListaProdutosState extends State<TelaListaProdutos> {
  String _filtro = '';

  List<Produto> get _produtosFiltrados {
    if (_filtro.isEmpty) return widget.produtos;
    return widget.produtos.where((p) {
      final desc = p.descricao.toLowerCase();
      final cod = p.codigo.toLowerCase();
      final tipo = p.tipo.toLowerCase();
      final busca = _filtro.toLowerCase();
      return desc.contains(busca) || cod.contains(busca) || tipo.contains(busca);
    }).toList();
  }

  void _excluirProduto(Produto produto) {
    setState(() {
      widget.produtos.removeWhere((p) => p.codigo == produto.codigo);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produto ${produto.descricao} removido!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exibicao = _produtosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por Código, Descrição ou Tipo',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _filtro = val;
                });
              },
            ),
          ),
          Expanded(
            child: exibicao.isEmpty
                ? const Center(child: Text('Nenhum produto encontrado.'))
                : ListView.builder(
                    itemCount: exibicao.length,
                    itemBuilder: (context, index) {
                      final prod = exibicao[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(prod.descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Cód: ${prod.codigo} | Tipo: ${prod.tipo}\nEstoque: ${prod.quantidadeEstoque} un.'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'R\$ ${prod.preco.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _excluirProduto(prod),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaDetalhesProduto(
                                  produto: prod,
                                  onEditar: (prodAtualizado) {
                                    setState(() {
                                      prod.descricao = prodAtualizado.descricao;
                                      prod.tipo = prodAtualizado.tipo;
                                      prod.preco = prodAtualizado.preco;
                                      prod.quantidadeEstoque = prodAtualizado.quantidadeEstoque;
                                    });
                                  },
                                ),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novo = await Navigator.push<Produto>(
            context,
            MaterialPageRoute(builder: (context) => const TelaFormProduto()),
          );
          if (novo != null) {
            setState(() {
              widget.produtos.add(novo);
            });
          }
        },
      ),
    );
  }
}