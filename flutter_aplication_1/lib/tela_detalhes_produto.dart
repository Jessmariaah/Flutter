import 'package:flutter/material.dart';
import 'produto.dart';
import 'tela_form_produto.dart';

class TelaDetalhesProduto extends StatefulWidget {
  final Produto produto;
  final Function(Produto) onEditar;

  const TelaDetalhesProduto({
    super.key,
    required this.produto,
    required this.onEditar,
  });

  @override
  State<TelaDetalhesProduto> createState() => _TelaDetalhesProdutoState();
}

class _TelaDetalhesProdutoState extends State<TelaDetalhesProduto> {
  @override
  Widget build(BuildContext context) {
    final prod = widget.produto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final prodAtualizado = await Navigator.push<Produto>(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaFormProduto(produtoParaEditar: prod),
                ),
              );

              if (prodAtualizado != null) {
                widget.onEditar(prodAtualizado);
                setState(() {});
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _campoDetalhe('Código', prod.codigo),
                const Divider(),
                _campoDetalhe('Descrição', prod.descricao),
                const Divider(),
                _campoDetalhe('Tipo/Categoria', prod.tipo),
                const Divider(),
                _campoDetalhe('Preço Unitário', 'R\$ ${prod.preco.toStringAsFixed(2)}'),
                const Divider(),
                _campoDetalhe('Quantidade em Estoque', '${prod.quantidadeEstoque} unidades'),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoDetalhe(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(valor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}