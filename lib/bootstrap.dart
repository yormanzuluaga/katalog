import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:talentpitch_test/core/database/db.dart';
import 'package:talentpitch_test/core/database/login_store.dart';
import 'package:talentpitch_test/core/database/play_list_store.dart';
import 'package:talentpitch_test/core/database/user_store.dart';
import 'package:talentpitch_test/flavor.dart';

import 'app/view/app.dart';
import 'injection/injection_container.dart' as di;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Custom instance of [BlocObserver] which logs
/// any state changes and errors.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder] in an error zone.
Future<void> bootstrap({
  required FlavorType flavor,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  Bloc.observer = AppBlocObserver();
  await runZonedGuarded(() async {
    Flavor.instance.setFlavor = flavor;
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await di.init(
      onError: (exception, stack) {
        if (!kIsWeb) {
          // FirebaseCrashlytics.instance.recordError(exception, stack);
          //  final platform = io.Platform.isAndroid ? dynatrace.Platform.Android : dynatrace.Platform.iOS;
          //  dynatrace.Dynatrace().reportZoneStacktrace(exception, stack ?? StackTrace.fromString(''), platform: platform);
        }
      },
    );
    await DB.instance.init();
    await UserStore.instance.init();
    await LoginStore.instance.init();
    await PlayListStore.instance.init();

    runApp(const App());
  }, onError);
}

onError(Object exception, StackTrace stackTrace) {}
