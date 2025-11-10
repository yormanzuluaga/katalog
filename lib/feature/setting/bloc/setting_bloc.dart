import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/core/database/login_store.dart';
import 'package:talentpitch_test/core/database/user_store.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<SettingEvent>((event, emit) {});

    on<SignOutSettingEvent>((event, emit) async {
      await LoginStore.instance.logOutSession();
      await UserStore.instance.outUser();
      rootNavigatorKey.currentContext?.go(RoutesNames.login);
    });
  }
}
