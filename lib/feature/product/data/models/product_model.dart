import 'package:llmm/feature/product/domain/entity/product.dart';

class ProductModel extends Product {

  ProductModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      description: json['description'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, 'title': title, 'description': description};
  }

  factory ProductModel.fromEntity(Product product) => ProductModel(
    description: product.description,
    title: product.title,
    id: product.id,
  );
  
}
