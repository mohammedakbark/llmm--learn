import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:llmm/core/network/api_client.dart';
import 'package:llmm/core/network/api_constant.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  ),
);

final apiClientProvider = Provider<ApiClient>((ref)=>ApiClient(ref.watch(dioProvider)));
