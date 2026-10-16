import 'package:llmm/core/error/exceptions.dart';
import 'package:llmm/core/error/failures.dart';
import 'package:llmm/feature/product/data/datasource/product_remote_data_source.dart';
import 'package:llmm/feature/product/data/models/product_model.dart';
import 'package:llmm/feature/product/domain/repository/product_repo.dart';

class ProductRepoImp implements ProductRepo {
  final ProductRemoteDataSource _dataSource;
  ProductRepoImp(this._dataSource);

  @override
  Future<ProductResponseModel> getProduct(int skip) async {
    try {
      final response = await _dataSource.fetchProduct(skip);
      return response;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
