import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:llmm/feature/product/presentation/controller/product_controller.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.watch(productControllerProvider.notifier).fetchNextProducts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, _) {
              if (ref.watch(productControllerProvider).isLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          Expanded(
            child: productState.when(
              data: (data) => ListView.builder(
                itemCount: productState.value?.products.length ?? 0,
                itemBuilder: (context, index) {
                  final product = productState.value?.products[index];
                  return ListTile(
                    title: Text(product?.title ?? ''),
                    subtitle: Text(product?.description ?? ''),
                  );
                },
              ),
              error: (error, _) => Text("Error"),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
