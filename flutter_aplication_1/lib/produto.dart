class Produto {
  final String codigo;
  String descricao;
  String tipo;
  double preco;
  int quantidadeEstoque;

  Produto({
    required this.codigo,
    required this.descricao,
    required this.tipo,
    required this.preco,
    required this.quantidadeEstoque,
  });
}