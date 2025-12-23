import 'package:api_helper/api_helper.dart';
import 'package:flutter/services.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/core/database/login_store.dart';
import 'package:talentpitch_test/core/database/user_store.dart';
import 'package:talentpitch_test/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:talentpitch_test/feature/cart/bloc/address/address_bloc.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_test/feature/home/bloc/home_bloc.dart';
import 'package:talentpitch_test/feature/product/bloc/brand/brand_bloc.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';
import 'package:talentpitch_test/feature/product/bloc/product/product_bloc.dart';
import 'package:talentpitch_test/feature/setting/bloc/setting_bloc.dart';
import 'package:talentpitch_test/feature/wallet/bloc/balance/balance_bloc.dart';
import 'package:talentpitch_test/feature/wallet/bloc/wallet_bloc.dart';
import 'package:talentpitch_test/l10n/arb/app_localizations.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/routes/routes.dart';
import 'package:talentpitch_test/injection/injection_container.dart'
    as injection;
import 'package:talentpitch_test/app/routes/router_config.dart';

/// {@template app}
/// The `App` class is a Dart class that represents the main application
/// and sets up the theme, localization, and routing.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final router = CustomRouterConfig().router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => injection.sl<AppBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<CategoryBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<HomeBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<CartBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<ProductBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<SettingBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<AddressBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<BrandBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<CatalogBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<BalanceBloc>(),
        ),
        BlocProvider(
          create: (_) => injection.sl<WalletBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return FutureBuilder(
              future: _loadUserData(context),
              builder: (context, snapshot) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,
                  ),
                  child: MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    theme: const AppTheme().themeData,
                    title: 'Talentepitch',
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    routeInformationProvider: router.routeInformationProvider,
                    routeInformationParser: router.routeInformationParser,
                    routerDelegate: router.routerDelegate,
                    scaffoldMessengerKey: rootScaffoldMessengerKey,
                  ),
                );
              });
        },
      ),
    );
  }

  Future<void> _loadUserData(BuildContext context) async {
    final appBloc = context.read<AppBloc>();

    if (appBloc.state.token == null ||
        (appBloc.state.token?.isNotEmpty ?? false)) {
      final token = LoginStore.instance.accessToken;
      final user = UserStore.instance;

      final userSession = user.user.isNotEmpty
          ? User(
              firstName: user.firstName,
              lastName: user.lastName,
              email: user.email,
              countryCode: user.country,
              mobile: user.mobile,
              avatar: user.avatar,
              uid: user.uid,
            )
          : null;

      if (token.isNotEmpty) {
        appBloc.add(
          SetUserData(
            token: token,
            userSession: userSession,
            userName: user.createdAt,
          ),
        );
      }
    }
  }
}
