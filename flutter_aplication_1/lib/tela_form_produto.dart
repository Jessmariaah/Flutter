import 'package:flutter/material.dart';
import 'produto.dart';

class TelaFormProduto extends StatefulWidget {
  final Produto? produtoParaEditar;

  const TelaFormProduto({super.key, this.produtoParaEditar});

  @override
  State<TelaFormProduto> createState() => _TelaFormProdutoState();
}

class _TelaFormProdutoState extends State<TelaFormProduto> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codigoController;
  late TextEditingController _descricaoController;
  late TextEditingController _tipoController;
  late TextEditingController _precoController;
  late TextEditingController _estoqueController;

  bool get eEdicao => widget.produtoParaEditar != null;

  @override
  void initState() {
    super.initState();
    final p = widget.produtoParaEditar;
    _codigoController = TextEditingController(text: p?.codigo ?? '');
    _descricaoController = TextEditingController(text: p?.descricao ?? '');
    _tipoController = TextEditingController(text: p?.tipo ?? '');
    _precoController = TextEditingController(text: p != null ? p.preco.toString() : '');
    _estoqueController = TextEditingController(text: p != null ? p.quantidadeEstoque.toString() : '');
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final produtoModificado = Produto(
        codigo: _codigoController.text,
        descricao: _descricaoController.text,
        tipo: _tipoController.text,
        preco: double.parse(_precoController.text),
        quantidadeEstoque: int.parse(_estoqueController.text),
      );

      Navigator.pop(context, produtoModificado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eEdicao ? 'Editar Produto' : 'Novo Produto'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codigoController,
                enabled: !eEdicao, // O código não pode ser alterado se for edição
                decoration: const InputDecoration(labelText: 'Código do Produto', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Informe o código' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo/Categoria', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Informe o tipo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preço (R\$)', border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Informe o preço';
                  if (double.tryParse(val) == null) return 'Digite um preço válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _estoqueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade em Estoque', border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Informe o estoque';
                  if (int.tryParse(val) == null) return 'Digite um número inteiro válido';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text(eEdicao ? 'Atualizar' : 'Salvar', style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}