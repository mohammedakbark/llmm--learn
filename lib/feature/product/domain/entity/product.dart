class ProductResponse {
  List<Product> products;
  int total;
  int skip;
  int limit;
  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });
}

class Product {
  final int? id;
  final String? title;
  final String? description;

  Product({required this.id, required this.title, required this.description});
}
