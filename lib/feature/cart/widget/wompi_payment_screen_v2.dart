import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/services/wompi_payment_service.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class WompiPaymentScreenV2 extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const WompiPaymentScreenV2({
    super.key,
    required this.orderData,
  });

  @override
  State<WompiPaymentScreenV2> createState() => _WompiPaymentScreenV2State();
}

class _WompiPaymentScreenV2State extends State<WompiPaymentScreenV2> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  bool _isProcessing = false;
  String? _selectedPaymentMethod = 'WOMPI_WIDGET';

  @override
  void initState() {
    super.initState();
    _initializeWompi();
  }

  Future<void> _initializeWompi() async {
    await WompiPaymentService.initialize();
  }

  int _calculateTotalUnits() {
    final cartItems = widget.orderData['cartItems'] as List?;
    if (cartItems == null || cartItems.isEmpty) return 0;

    int totalUnits = 0;
    for (var item in cartItems) {
      totalUnits += (item.quantity as int?) ?? 1;
    }
    return totalUnits;
  }

  double _calculateTotalProfit() {
    final cartItems = widget.orderData['cartItems'] as List?;
    if (cartItems == null || cartItems.isEmpty) return 0.0;

    final totalUnits = _calculateTotalUnits();
    final isWholesale = totalUnits >= 6;

    double totalProfit = 0.0;
    for (var item in cartItems) {
      final commission = isWholesale
          ? (item.pricing?.wholesaleCommission?.toDouble() ??
              item.pricing?.commission?.toDouble() ??
              0.0)
          : (item.pricing?.commission?.toDouble() ?? 0.0);
      final quantity = (item.quantity as int?) ?? 1;
      totalProfit += commission * quantity;
    }
    return totalProfit;
  }

  @override
  Widget build(BuildContext context) {
    var totalAmount = widget.orderData['totalPriceCop'] as double? ?? 0.0;
    final customerEmail =
        widget.orderData['customerEmail'] as String? ?? 'test@test.com';

    // Asegurar monto mínimo para pruebas de Wompi (mínimo 1500 COP)
    if (totalAmount < 1500.0) {
      print('⚠️ Monto menor al mínimo, usando 1500 COP para prueba');
      totalAmount = 1500.0;
    }

    print('💰 BUILD: Monto total final: $totalAmount COP');

    return Column(
      children: [
        Text(
          'Pago Seguro',
          style: APTextStyle.textLG.bold,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen del pedido
                _buildOrderSummary(totalAmount),

                const SizedBox(height: 30),

                // Métodos de pago
                _buildPaymentMethods(),

                const SizedBox(height: 30),

                // Widget de pago Wompi
                if (_selectedPaymentMethod == 'WOMPI_WIDGET')
                  _buildWompiWidget(totalAmount, customerEmail),

                // Información temporal sobre firma de integridad
                if (_selectedPaymentMethod != 'WOMPI_WIDGET')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(Icons.info_outline,
                                color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Información sobre pagos directos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '✅ Widget de Wompi ahora incluye la firma de integridad automáticamente. Los pagos directos aún requieren implementación adicional.',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Monto de prueba ajustado a: \$${totalAmount.toStringAsFixed(0)} COP',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(double totalAmount) {
    final totalItems = widget.orderData['totalItems'] as int? ?? 0;
    final totalUnits = _calculateTotalUnits();
    final totalProfit = _calculateTotalProfit();
    final isWholesale = totalUnits >= 6;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.cartShopping,
                color: AppColors.primaryMain,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'Resumen del pedido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalItems productos',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                _currencyFormat.format(totalAmount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          // Ganancia
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 18,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isWholesale ? 'Tu ganancia por mayor' : 'Tu ganancia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    if (isWholesale) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Por Mayor',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  _currencyFormat.format(totalProfit),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total a pagar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _currencyFormat.format(totalAmount),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Método de pago',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // Widget de Wompi (recomendado)
        _buildPaymentMethodTile(
          id: 'WOMPI_WIDGET',
          title: 'Pago con Wompi',
          subtitle: 'PSE, Nequi, Tarjetas (Recomendado)',
          icon: FontAwesomeIcons.creditCard,
          isRecommended: true,
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPaymentMethodTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryMain : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryMain.withOpacity(0.15)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(
                icon,
                color: isSelected ? AppColors.primaryMain : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primaryMain
                              : Colors.black87,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Recomendado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              activeColor: AppColors.primaryMain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWompiWidget(double totalAmount, String customerEmail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.shield,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pago seguro con Wompi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Checkout oficial con firma de integridad incluida',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'RECOMENDADO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Información del pago
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.creditCard,
                      size: 24,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Métodos de pago disponibles:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PSE, Nequi, Tarjetas de crédito/débito',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.dollarSign,
                      size: 20,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Monto a pagar: ${_currencyFormat.format(totalAmount)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Email: $customerEmail',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Botón de pago
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _processPaymentWithWidget(totalAmount, customerEmail),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Procesando...'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.shield, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Pagar ${_currencyFormat.format(totalAmount)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // Nota informativa
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.info,
                  size: 14,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Al hacer clic, se abrirá el checkout seguro de Wompi dentro de la aplicación para completar tu pago.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPaymentWithWidget(
      double totalAmount, String customerEmail) async {
    print('💳 ====== INICIANDO PAGO CON WIDGET WOMPI ======');
    print('💰 Monto: $totalAmount COP');
    print('📧 Email: $customerEmail');

    setState(() {
      _isProcessing = true;
    });

    try {
      final reference = WompiPaymentService.generateReference();
      final amountInCents = (totalAmount * 100).round();

      print('📝 Referencia generada: $reference');
      print('💰 Monto en centavos: $amountInCents');

      // Obtener token de aceptación
      final acceptanceToken = await WompiPaymentService.getAcceptanceToken();
      if (acceptanceToken == null) {
        throw Exception('No se pudo obtener el token de aceptación');
      }

      print('✅ Token de aceptación obtenido');

      // Generar firma de integridad (SOLO con los parámetros requeridos según documentación oficial)
      final signature = WompiPaymentService.generateIntegritySignature(
        reference: reference,
        amountInCents: amountInCents.toString(),
        currency: 'COP',
      );

      // Crear URL de checkout de Wompi
      final checkoutUrl = Uri.parse('https://checkout.wompi.co/p/');
      final queryParams = {
        'public-key': 'pub_test_ndxNzt5NE33wReX3pT7UeVO5fFHJaxxV',
        'currency': 'COP',
        'amount-in-cents': amountInCents.toString(),
        'reference': reference,
        'acceptance-token': acceptanceToken,
        'customer-email': customerEmail,
        'redirect-url':
            'https://myapp.payment/success?ref=$reference', // URL personalizada de éxito
        'fail-url':
            'https://myapp.payment/error?ref=$reference', // URL personalizada de error
        'cancel-url':
            'https://myapp.payment/cancel?ref=$reference', // URL personalizada de cancelación
        'signature:integrity':
            signature, // Formato correcto según documentación oficial de Wompi
      };

      final fullUrl = checkoutUrl.replace(queryParameters: queryParams);

      print('🌐 URL de checkout: $fullUrl');
      print('🚀 Abriendo widget de Wompi en WebView...');

      // Obtener datos necesarios del orderData
      final shippingAddressId =
          widget.orderData['shippingAddressId'] as String? ?? '';
      final cartItems = widget.orderData['cartItems'] as List? ?? [];

      // Navegar al WebView de Wompi
      if (mounted) {
        context.push(
          RoutesNames.wompiPaymentWebView,
          extra: {
            'paymentUrl': fullUrl.toString(),
            'reference': reference,
            'amount': totalAmount,
            'customerEmail': customerEmail,
            'shippingAddressId': shippingAddressId,
            'cartItems': cartItems,
          },
        );

        print('✅ WebView de Wompi abierto exitosamente');
      }
    } catch (e) {
      print('❌ Error en pago con widget: $e');
      _showPaymentError('Error al procesar pago: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showPaymentError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
