What you fixed since last time ✅
 
- flutter_riverpod and go_router are in pubspec.yaml.
- ApiClient now takes Dio through its constructor.
- core/error now has ServerException and a sealed failure class.
- The DataSource catches DioException and throws ServerException; the RepoImp turns that into ServerFailure.
- The model consistently uses inheritance now: toEntity() is gone and the repo returns the list directly.
- GetProducts and RepoImp fields are final, and the RepoImp field is also private.
 
Problems, most important first
 
1. main.dart:5 has no ProviderScope (this breaks Riverpod)
Every ref.watch will throw "No ProviderScope found".
Fix: runApp(const ProviderScope(child: MainApp()));
 
2. Nothing creates Dio any more, so baseUrl is lost
When you moved Dio out of ApiClient, the BaseOptions (baseUrl, timeouts) went with it. ApiConstant.baseUrl isn't used anywhere now. That setup has to live in a provider (step 2 below).
 
3. context.go() to a top-level route leaves no back button
initial_screen.dart:14 with app_router.dart:13: /products is a sibling of /, so go replaces the whole page stack. ProductScreen gets no back arrow, and Android back closes the app.
Fix, either:
- Use context.push(AppRoutes.products), or
- Nest the route: GoRoute(path: '/', ..., routes: [GoRoute(pato('/products') builds the stack / → /products.
 
4. Every entity field is now nullable (product.dart)
int? id, String? title and so on push ?? '' checks into every widget, and an id should never be null.
Fix: make the entity non-nullable again with a const constructor, and handle missing values in ProductModel.fromJson, e.g. title: json['title'] as String?
?? ''. The data layer cleans the data; the domain stays strict
 
5. NetworkFailure is never used
The DataSource turns every Dio error into ServerException.
Fix: check e.type. For connectionError, connectionTimeout and receiveTimeout, throw a NetworkException; the repo maps that to NetworkFailure and everything else to ServerFailure.
Also, a malformed JSON response throws a raw TypeError that no
 
6. Minor
- Rename Failures to Failure, since one object is one failure.
- Fix the typo intialRoute → initialRoute.
- initial_screen.dart sits loose in lib/. Move it into a feature, e.g. feature/home/presentation/pages/.
- Rename presentation/ui/ to presentation/pages/, and add cont it.
- Run dart format . (for int ?id, the spacing in app_router.dart, and the empty line in app.dart).
- Add const to InitialScreen(), ProductScreen() and Text(...).
- Leftovers from last review: getProduct/fetchProduct should be plural, Imp should be Impl, and fromJson still uses implicit dynamic casts.
 
---
 
How to implement the controller (Riverpod 3, no code generation)
 
Target folder layout:
core/network/network_providers.dart          ← dioProvider, apiClientProvider
feature/product/
  data/ ...  domain/ ...
  di/product_providers.dart                  ← datasource, rep
  presentation/
    controllers/product_controller.dart      ← AsyncNotifier
    pages/product_screen.dart                ← ConsumerWidget
 
Step 1 – main.dart: wrap the app in ProviderScope (problem 1).
 
Step 2 – core providers: this is where Dio gets created now.
final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    )));
 
final apiClientProvider =
    Provider<ApiClient>((ref) => ApiClient(ref.watch(dioProvider)));
 
Step 3 – feature providers (di/product_providers.dart): this is the only file that imports data, domain and core together.
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
    (ref) => ProductRemoteDataSource(ref.watch(apiClientProvid
 
final productRepoProvider = Provider<ProductRepo>(            // abstract type!
    (ref) => ProductRepoImp(ref.watch(productRemoteDataSourceProvider)));
 
final getProductsProvider = Provider<GetProducts>(
    (ref) => GetProducts(ref.watch(productRepoProvider)));
Type productRepoProvider as ProductRepo, not ProductRepoImp. Th a fake repo, and the UI never sees the data layer.
 
Step 4 – the controller (AsyncNotifier):
class ProductController extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() {
    final getProducts = ref.watch(getProductsProvider); // watch in build
    return getProducts();
  }
 
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(getProductsProvider)()); // read in methods
  }
}
 
final productControllerProvider =
    AsyncNotifierProvider.autoDispose<ProductController, List<Product>>(
        ProductController.new);
- build() runs automatically the first time the screen watches the provider, so you don't need to call anything like "fetchProducts" yourself.
- The Future's states become AsyncLoading, AsyncData and AsyncError for you. When your repo throws a Failure, it ends up in AsyncError, which is why
  throwing failures works well with Riverpod.
- AsyncValue.guard does the same for manual actions like refresh: it catches the throw and stores it as AsyncError.
 
Step 5 – the screen (ConsumerWidget):
class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e is Failure ? e.mg')),
        data: (products) => RefreshIndicator(
          onRefresh: () => ref.read(productControllerProvider.
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(products[i].title),
              subtitle: Text(products[i].description),
            ),
          ),
        ),
      ),
    );
  }
}
 
Rules to remember:
- Use ref.watch inside build (provider or widget), and ref.read inside callbacks and methods.
- The UI imports only the controller and domain entities. It nRepoImp, Dio or ApiClient.
- If something only fetches and has no actions, FutureProvider is enough. Use AsyncNotifier once you need methods like refresh, add or delete.
- Riverpod 3 retries failed providers automatically. If you test with a bad URL, the error appears after a few retries, not instantly. You can turn this off with ProviderScope(retry: (_, _) => null, ...).
 
To check: run dart analyze, then open Products. You should see a spinner, then the list, a back arrow (after fix 3), and pull-to-refresh working. With the
base URL broken you should see your own failure message, not a