part of 'injection_container.dart';

void _initResourcesInjections() {
  sl.registerFactory<CategoryResource>(() => CategoryResource(
        apiClient: sl(),
      ));
  sl.registerFactory<VideoResource>(() => VideoResource(
        apiClient: sl(),
      ));
  sl.registerFactory<AuthResource>(() => AuthResource(
        apiClient: sl(),
      ));
  sl.registerFactory<AddressResource>(() => AddressResource(
        apiClient: sl(),
      ));
  sl.registerFactory<TransactionsResource>(() => TransactionsResource(
        apiClient: sl(),
      ));
}
