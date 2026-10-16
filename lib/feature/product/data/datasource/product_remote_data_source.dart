import 'package:dio/dio.dart';
import 'package:llmm/core/error/exceptions.dart';
import 'package:llmm/core/network/api_client.dart';
import 'package:llmm/core/network/api_constant.dart';
import 'package:llmm/feature/product/data/models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource(this.apiClient);

  Future<ProductResponseModel> fetchProduct(int skip) async {
    try {
      final response = await apiClient.get("${ApiConstant.product}?limit=5&skip=$skip");
      final productsResponse =ProductResponseModel.fromJson(response.data);
      return productsResponse;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unable to fetch products');
    }
  }
}
