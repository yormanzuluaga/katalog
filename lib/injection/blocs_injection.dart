part of 'injection_container.dart';

void _initBlocsInjections() {
  sl.registerFactory(
    () => AppBloc(),
  );
  sl.registerFactory(
    () => CategoryBloc(
      categoryRepository: sl(),
      brandRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => HomeBloc(),
  );
  sl.registerFactory(
    () => CartBloc(),
  );
  sl.registerFactory(
    () => ProductBloc(),
  );
  sl.registerFactory(
    () => AuthBloc(authRepository: sl()),
  );
  sl.registerFactory(
    () => SettingBloc(),
  );
  sl.registerFactory(
    () => AddressBloc(addressRepository: sl()),
  );
  sl.registerFactory(
    () => PaymentBloc(transactionsRepository: sl()),
  );
  sl.registerFactory(
    () => ShippingOrdersBloc(shippingOrderRepository: sl()),
  );
  sl.registerFactory(
    () => BalanceBloc(balanceRepository: sl()),
  );
  sl.registerFactory(
    () => BrandBloc(brandRepository: sl()),
  );
  sl.registerFactory(
    () => CatalogBloc(catalogRepository: sl()),
  );
  sl.registerFactory(
    () => BannerBloc(bannerRepository: sl()),
  );
  sl.registerFactory(
    () => ProfileBloc(userRepository: sl()),
  );
  sl.registerFactory(
    () => WalletBloc(withdrawalRepository: sl()),
  );
  sl.registerFactory(
    () => MyWithdrawalsBloc(withdrawalRepository: sl()),
  );
}
