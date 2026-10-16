import 'package:go_router/go_router.dart';
import 'package:llmm/app/router/app_routes.dart';
import 'package:llmm/feature/product/presentation/pages/product_screen.dart';
import 'package:llmm/initial_screen.dart';
 
final GoRouter goRouter = GoRouter(
  initialLocation:AppRoutes.intialRoute ,
  routes: [
    GoRoute(path: AppRoutes.intialRoute,
    builder: (context, state) =>InitialScreen() ,
    ),

    GoRoute(path: AppRoutes.products,
    builder: (context, state) =>ProductScreen() ,
    )
  ]);
