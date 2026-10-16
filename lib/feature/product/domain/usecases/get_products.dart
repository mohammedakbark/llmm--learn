import 'package:llmm/feature/product/domain/entity/product.dart';
import 'package:llmm/feature/product/domain/repository/product_repo.dart';

class GetProducts {
  final ProductRepo _productRepo;
  GetProducts(this._productRepo);

  Future<List<Product>> call() => _productRepo.getProduct();
}
