import 'package:llmm/feature/product/domain/entity/product.dart';

abstract class ProductRepo {
  Future<ProductResponse> getProduct(int skip);
}
