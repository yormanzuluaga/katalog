import 'package:api_helper/api_helper.dart';
import 'package:talentpitch_test/core/database/login_store.dart';
import 'package:talentpitch_test/feature/auth/view/auth_page.dart';
import 'package:talentpitch_test/feature/cart/view/cart_page.dart';
import 'package:talentpitch_test/feature/cart/widget/form_payment.dart';
import 'package:talentpitch_test/feature/cart/widget/payment_process.dart';
import 'package:talentpitch_test/feature/cart/widget/address_selection.dart';
import 'package:talentpitch_test/feature/cart/widget/wompi_payment_screen_v2.dart';
import 'package:talentpitch_test/feature/cart/widget/payment_success_screen.dart';
import 'package:talentpitch_test/feature/cart/widget/payment_rejected_screen.dart';
import 'package:talentpitch_test/feature/cart/widget/wompi_webview_screen.dart';
import 'package:talentpitch_test/feature/cart/bloc/payment/payment_bloc.dart';
import 'package:talentpitch_test/feature/product/view/product_page.dart';
import 'package:talentpitch_test/feature/product/widget/product_list.dart';
import 'package:talentpitch_test/feature/product/widget/sub_category_list.dart';
import 'package:talentpitch_test/feature/setting/view/setting_page.dart';
import 'package:talentpitch_test/feature/wallet/view/wallet_page.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/home/view/home_page.dart';
import 'package:talentpitch_test/feature/main_dashboard/view/main_dashboard_page.dart';
import 'package:talentpitch_test/feature/main_dashboard/widgets/detail.dart';
import 'package:talentpitch_test/injection/injection_container.dart';

part 'router_handlers.dart';

/// Navigator keys
/// The `healthNavigatorKey` is a global key that is used to access the
/// management navigator.
final healthNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'health_navigator');
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root_navigator');
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home_navigator');

/// The `managementNavigatorKey` is a global key that is used to access the
/// management navigator.
final managementNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'management_navigator');

/// The rootScaffoldMessengerKey is a global key that is used to access the
/// rootScaffold navigator.
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(debugLabel: 'root_scaffold_messenger');

/// Insert in this array all the routes that need to be accessible without login.
final routingExceptions = [
  //RoutesNames.credential,
];

class CustomRouterConfig {
  static final _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutesNames.login,
    redirect: (context, state) {
      if (LoginStore.instance.accessToken.isEmpty && !routingExceptions.contains(state.matchedLocation)) {
        return RoutesNames.login;
      }
      return null;
    },
    errorPageBuilder: (context, state) {
      return NoTransitionPage(
        child: UnderConstruction(title: state.matchedLocation),
      );
    },
    routes: [
      /// Main ShellRoute for authenticated users
      GoRoute(
        path: RoutesNames.login,
        builder: _loginHandler,
        redirect: (context, state) {
          if (LoginStore.instance.accessToken.isNotEmpty) {
            return RoutesNames.home;
          }
          return null;
        },
      ),
      ShellRoute(
        navigatorKey: homeNavigatorKey,
        builder: _homeHandler,
        routes: [
          /// Home route
          GoRoute(
            path: RoutesNames.home,
            parentNavigatorKey: homeNavigatorKey,
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: MainDashboardPage(),
              );
            },
          ),
          ShellRoute(
            parentNavigatorKey: homeNavigatorKey,
            navigatorKey: healthNavigatorKey,
            pageBuilder: (context, state, child) {
              return NoTransitionPage(child: child);
            },
            routes: [
              // Web version

              GoRoute(
                path: RoutesNames.product,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _productPageHandler,
              ),
              GoRoute(
                path: RoutesNames.cart,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _cartPageHandler,
              ),
              GoRoute(
                path: RoutesNames.payment,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _paymentProcess,
              ),
              GoRoute(
                path: RoutesNames.formPayment,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _formPaymentProcess,
              ),
              GoRoute(
                path: RoutesNames.addressSelection,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _addressSelectionHandler,
              ),
              GoRoute(
                path: RoutesNames.wompiPayment,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _wompiPaymentHandler,
              ),

              GoRoute(
                path: RoutesNames.productList,
                parentNavigatorKey: healthNavigatorKey,
                pageBuilder: _productListHandler,
              ),
            ],
          ),
          ShellRoute(
            parentNavigatorKey: homeNavigatorKey,
            navigatorKey: managementNavigatorKey,
            pageBuilder: (context, state, child) {
              return NoTransitionPage(child: child);
            },
            routes: [
              // Mobile version

              GoRoute(
                path: RoutesNames.product,
                parentNavigatorKey: managementNavigatorKey,
                pageBuilder: _productPageHandler,
              ),
              GoRoute(
                path: RoutesNames.cart,
                parentNavigatorKey: managementNavigatorKey,
                pageBuilder: _cartPageHandler,
              ),
              GoRoute(
                path: RoutesNames.wallet,
                parentNavigatorKey: managementNavigatorKey,
                pageBuilder: _walletPageHandler,
              ),
              GoRoute(
                path: RoutesNames.setting,
                parentNavigatorKey: managementNavigatorKey,
                pageBuilder: _settingPageHandler,
              ),
              GoRoute(
                path: RoutesNames.subCategory,
                parentNavigatorKey: managementNavigatorKey,
                pageBuilder: _subCategoryPageHandler,
              ),
            ],
          ),

          GoRoute(
            path: RoutesNames.productList,
            parentNavigatorKey: homeNavigatorKey,
            pageBuilder: _productListHandler,
          ),

          /// Nested routes (shared structure for both health and management)
        ],
      ),
      GoRoute(
        path: RoutesNames.wompiPaymentWebView,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: _wompiPaymentWebViewHandler,
      ),
      GoRoute(
        path: RoutesNames.paymentSuccess,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: _paymentSuccessHandler,
      ),
      GoRoute(
        path: RoutesNames.paymentRejected,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: _paymentRejectedHandler,
      ),
      GoRoute(
        path: RoutesNames.productList,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: _productListHandler,
      ),
      GoRoute(
        path: RoutesNames.detail,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: _detailPageHandler,
      ),
    ],
  );

  /// Expose the router instance
  GoRouter get router => _router;
}

/// Pop until a specific path
void popUntilPath(String routePath, BuildContext context) {
  final router = GoRouter.of(context);
  while ('${router.routeInformationProvider.value.uri}' != routePath) {
    if (!router.canPop()) return;
    router.pop();
  }
}
