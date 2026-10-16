import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:llmm/core/network/network_provider.dart';
import 'package:llmm/feature/product/data/datasource/product_remote_data_source.dart';
import 'package:llmm/feature/product/data/repository/product_repo_imp.dart';
import 'package:llmm/feature/product/domain/entity/product.dart';
import 'package:llmm/feature/product/domain/repository/product_repo.dart';
import 'package:llmm/feature/product/domain/usecases/get_products.dart';

final productDataSourceprovider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSource(ref.watch(apiClientProvider)),
);
final productRepoProvider = Provider<ProductRepo>(
  (ref) => ProductRepoImp(ref.watch(productDataSourceprovider)),
);
final getProductProvider = Provider<GetProducts>(
  (ref) => GetProducts(ref.watch(productRepoProvider)),
);

class ProductController extends AsyncNotifier<ProductState> {
  int skip = 0;
  @override
  FutureOr<ProductState> build() {
    return _fetchProducts();
  }

  Future<ProductState> _fetchProducts() async {
    final getProducts = ref.watch(getProductProvider);
    final products = await getProducts(skip);
    return ProductState(
      products: products.products,
      ispaginationLoading: false,
    );
  }

  Future<void> fetchNextProducts() async {
    final currentState = state;
    skip += 5;
    state = AsyncValue.data(
      currentState.value ??
          ProductState(products: [], ispaginationLoading: true),
    );
    log("fetchNextProducts called with skip: $skip");
    log(currentState.value!.ispaginationLoading.toString());
    try {
      final getProducts = ref.watch(getProductProvider);
      final products = await getProducts(skip);
      currentState.value?.products.addAll(products.products);
      state = AsyncValue.data(
        currentState.value ??
            ProductState(
              products: products.products,
              ispaginationLoading: false,
            ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final productControllerProvider =
    AsyncNotifierProvider.autoDispose<ProductController, ProductState>(
      ProductController.new,
    );

class ProductState {
  List<Product> products;
  bool ispaginationLoading;

  ProductState({required this.products, required this.ispaginationLoading});

  ProductState copyWith({List<Product>? products, bool? ispaginationLoading}) {
    return ProductState(
      products: products ?? this.products,
      ispaginationLoading: ispaginationLoading ?? this.ispaginationLoading,
    );
  }
}
