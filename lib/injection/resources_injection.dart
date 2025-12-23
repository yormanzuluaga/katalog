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
  sl.registerFactory<ShippingOrderResource>(() => ShippingOrderResource(
        apiClient: sl(),
      ));
  sl.registerFactory<BalanceResource>(() => BalanceResource(
        apiClient: sl(),
      ));
  sl.registerFactory<WithdrawalResource>(() => WithdrawalResource(
        apiClient: sl(),
      ));
  sl.registerFactory<BrandResource>(() => BrandResource(apiClient: sl()));
  sl.registerFactory<CatalogResource>(() => CatalogResource(apiClient: sl()));
  sl.registerFactory<BannerResource>(() => BannerResource(apiClient: sl()));
  sl.registerFactory<UserResource>(() => UserResource(apiClient: sl()));
}
