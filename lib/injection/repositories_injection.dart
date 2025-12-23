part of 'injection_container.dart';

void _initRepositoriesInjections() {
  sl.registerFactory<CategoryRepository>(
      () => CategoryRepositoryImpl(categoryResource: sl()));
  sl.registerFactory<VideoRepository>(
      () => VideoRepositoryImpl(videoResource: sl()));
  sl.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authResource: sl()));
  sl.registerFactory<AddressRepository>(
      () => AddressRepositoryImpl(addressResource: sl()));
  sl.registerFactory<TransactionsRepository>(
      () => TransactionsRepositoryImpl(transactionsResource: sl()));
  sl.registerFactory<ShippingOrderRepository>(
      () => ShippingOrderRepositoryImpl(shippingOrderResource: sl()));
  sl.registerFactory<BalanceRepository>(
      () => BalanceRepositoryImpl(balanceResource: sl()));
  sl.registerFactory<WithdrawalRepository>(
      () => WithdrawalRepositoryImpl(withdrawalResource: sl()));
  sl.registerFactory<BrandRepository>(
      () => BrandRepositoryImpl(brandResource: sl()));
  sl.registerFactory<CatalogRepository>(
      () => CatalogRepositoryImpl(catalogResource: sl()));
  sl.registerFactory<BannerRepository>(
      () => BannerRepositoryImpl(bannerResource: sl()));
  sl.registerFactory<UserRepository>(
      () => UserRepositoryImpl(userResource: sl()));
}
