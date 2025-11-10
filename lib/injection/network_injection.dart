part of 'injection_container.dart';

void _initNetworkInjections(void Function(dynamic, StackTrace?)? onError) {
  sl.registerLazySingleton<ApiClient>(() => ApiClient(
        onError: onError,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'TalentPitch-Flutter-App/1.0',
        },
      ));
}
