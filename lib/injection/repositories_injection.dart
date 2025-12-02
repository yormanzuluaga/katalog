part of 'injection_container.dart';

void _initRepositoriesInjections() {
  sl.registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(categoryResource: sl()));
  sl.registerFactory<VideoRepository>(() => VideoRepositoryImpl(videoResource: sl()));
  sl.registerFactory<AuthRepository>(() => AuthRepositoryImpl(authResource: sl()));
  sl.registerFactory<AddressRepository>(() => AddressRepositoryImpl(addressResource: sl()));
  sl.registerFactory<TransactionsRepository>(() => TransactionsRepositoryImpl(transactionsResource: sl()));
}
