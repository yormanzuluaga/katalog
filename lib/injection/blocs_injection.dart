part of 'injection_container.dart';

void _initBlocsInjections() {
  sl.registerFactory(
    () => AppBloc(),
  );
  sl.registerFactory(
    () => CategoryBloc(categoryRepository: sl()),
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
}
