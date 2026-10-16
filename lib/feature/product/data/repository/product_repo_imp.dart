import 'package:llmm/core/error/exceptions.dart';
import 'package:llmm/core/error/failures.dart';
import 'package:llmm/feature/product/data/datasource/product_remote_data_source.dart';
import 'package:llmm/feature/product/domain/entity/product.dart';
import 'package:llmm/feature/product/domain/repository/product_repo.dart';

class ProductRepoImp implements ProductRepo {
  final ProductRemoteDataSource _dataSource;
  ProductRepoImp(this._dataSource);

  @override
  Future<List<Product>> getProduct() async {
    try {
      final list = await _dataSource.fetchProduct();
      return list;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
