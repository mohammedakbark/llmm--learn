import 'package:dio/dio.dart';
import 'package:llmm/core/error/exceptions.dart';
import 'package:llmm/core/network/api_client.dart';
import 'package:llmm/core/network/api_constant.dart';
import 'package:llmm/feature/product/data/models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource(this.apiClient);

  Future<List<ProductModel>> fetchProduct() async {
    try {
      final response = await apiClient.get(ApiConstant.product);
      final products = response.data['products'] as List;
      return products.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unable to fetch products');
    }
  }
}
