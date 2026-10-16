import 'package:llmm/feature/product/domain/entity/product.dart';

class ProductResponseModel extends ProductResponse {
  ProductResponseModel({
    required super.products,
    required super.total,
    required super.skip,
    required super.limit,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
    );
  }
}

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      description: json['description'] as String?,
      id: json['id'] as int?,
      title: json['title'] as String?,
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
