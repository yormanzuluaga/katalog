// ignore_for_file: cast_nullable_to_non_nullable

part of 'router_config.dart';

Widget _loginHandler(BuildContext context, GoRouterState state) {
  return const AuthPage();
}

Widget _homeHandler(BuildContext context, GoRouterState state, Widget child) {
  return HomePage(
    child: child,
  );
}

Page<Widget> _detailPageHandler(
  BuildContext context,
  GoRouterState state,
) {
  final data = state.extra as List<Product>;
  return NoTransitionPage(
      child: Detail(
    product: data.first,
  ));
}

Page<Widget> _productListHandler(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(
      child: ProductList(
    title: 'prueba',
    info: 'prueba',
    id: '12',
  ));
}

Page<Widget> _productPageHandler(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: ProductPage());
}

Page<Widget> _cartPageHandler(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: CartPage());
}

Page<Widget> _paymentProcess(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: PaymentProcess());
}

Page<Widget> _formPaymentProcess(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: FormPayment());
}

Page<Widget> _addressSelectionHandler(
  BuildContext context,
  GoRouterState state,
) {
  final data = state.extra as Map<String, dynamic>;
  return NoTransitionPage(
    child: AddressSelectionScreen(
      totalItems: data['totalItems'] ?? 0,
      totalPriceCop: data['totalPriceCop'] ?? 0,
    ),
  );
}

Page<Widget> _wompiPaymentHandler(
  BuildContext context,
  GoRouterState state,
) {
  final data = state.extra as Map<String, dynamic>;
  return NoTransitionPage(
    child: WompiPaymentScreenV2(
      orderData: data,
    ),
  );
}

Page<Widget> _settingPageHandler(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: SettingPage());
}

Page<Widget> _subCategoryPageHandler(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: SubCategoryList());
}

Page<Widget> _walletPageHandler(
  BuildContext context,
  GoRouterState state,
) {
  return NoTransitionPage(child: WalletPage());
}

Page<Widget> _wompiPaymentWebViewHandler(
  BuildContext context,
  GoRouterState state,
) {
  final data = state.extra as Map<String, dynamic>;
  return NoTransitionPage(
    child: BlocProvider(
      create: (context) => sl<PaymentBloc>(),
      child: WompiWebViewScreen(
        paymentUrl: data['paymentUrl'],
        reference: data['reference'],
        amount: data['amount'],
        customerEmail: data['customerEmail'],
        shippingAddressId: data['shippingAddressId'] ?? '',
        cartItems: data['cartItems'] ?? [],
      ),
    ),
  );
}

Page<Widget> _paymentSuccessHandler(
  BuildContext context,
  GoRouterState state,
) {
  final data = state.extra as Map<String, dynamic>?;

  // Validación robusta de datos
  String reference = '';
  double amount = 0.0;
  String customerEmail = '';
  String? transactionId;
  DateTime approvedAt = DateTime.now();

  if (data != null) {
    reference = data['reference']?.toString() ?? '';

    // Manejo seguro de amount (puede venir como int, double o string)
    final amountValue = data['amount'];
    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0.0;
    }

    customerEmail = data['customerEmail']?.toString() ?? '';
    transactionId = data['transactionId']?.toString();

    // Manejo seguro de fecha
    final approvedAtStr = data['approvedAt']?.toString();
    if (approvedAtStr != null && approvedAtStr.isNotEmpty) {
      try {
        approvedAt = DateTime.parse(approvedAtStr);
      } catch (e) {
        // Si hay error en el parsing, usar fecha actual
        approvedAt = DateTime.now();
      }
    }
  }

  return NoTransitionPage(
    child: PaymentSuccessScreen(
      reference: reference,
      amount: amount,
      customerEmail: customerEmail,
      transactionId: transactionId,
      approvedAt: approvedAt,
    ),
  );
}

Page<Widget> _paymentRejectedHandler(
  BuildContext context,
  GoRouterState state,
) {
  final data = state.extra as Map<String, dynamic>?;

  // Validación robusta de datos
  String reference = '';
  double amount = 0.0;
  String customerEmail = '';
  String? transactionId;
  String reason = 'Pago rechazado';
  DateTime attemptedAt = DateTime.now();

  if (data != null) {
    reference = data['reference']?.toString() ?? '';

    // Manejo seguro de amount (puede venir como int, double o string)
    final amountValue = data['amount'];
    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0.0;
    }

    customerEmail = data['customerEmail']?.toString() ?? '';
    transactionId = data['transactionId']?.toString();
    reason = data['reason']?.toString() ?? 'Pago rechazado';

    // Manejo seguro de fecha
    final attemptedAtStr = data['attemptedAt']?.toString();
    if (attemptedAtStr != null && attemptedAtStr.isNotEmpty) {
      try {
        attemptedAt = DateTime.parse(attemptedAtStr);
      } catch (e) {
        // Si hay error en el parsing, usar fecha actual
        attemptedAt = DateTime.now();
      }
    }
  }

  return NoTransitionPage(
    child: PaymentRejectedScreen(
      reference: reference,
      amount: amount,
      customerEmail: customerEmail,
      transactionId: transactionId,
      reason: reason,
      attemptedAt: attemptedAt,
    ),
  );
}
