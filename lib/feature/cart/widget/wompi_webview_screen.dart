import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/services/wompi_payment_service.dart';
import 'package:talentpitch_test/feature/cart/widget/payment_success_screen.dart';
import 'package:talentpitch_test/feature/cart/widget/payment_rejected_screen.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class WompiWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  final double amount;
  final String customerEmail;

  const WompiWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.reference,
    required this.amount,
    required this.customerEmail,
  });

  @override
  State<WompiWebViewScreen> createState() => _WompiWebViewScreenState();
}

class _WompiWebViewScreenState extends State<WompiWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _currentUrl;
  bool _paymentProcessed = false; // Evitar múltiples detecciones

  @override
  void initState() {
    super.initState();
    print('🚀 WompiWebViewScreen iniciado');
    print('📍 Payment URL: ${widget.paymentUrl}');

    // Verificar que la URL tenga los parámetros necesarios
    final uri = Uri.tryParse(widget.paymentUrl);
    if (uri != null) {
      print('🔍 Verificando parámetros en URL:');
      print('   Public Key: ${uri.queryParameters['public-key'] != null ? 'Presente' : 'FALTANTE'}');
      print('   Amount: ${uri.queryParameters['amount-in-cents'] != null ? 'Presente' : 'FALTANTE'}');
      print('   Reference: ${uri.queryParameters['reference'] != null ? 'Presente' : 'FALTANTE'}');
      print('   Signature:integrity: ${uri.queryParameters['signature:integrity'] != null ? 'Presente' : 'FALTANTE'}');
      print('   Acceptance token: ${uri.queryParameters['acceptance-token'] != null ? 'Presente' : 'FALTANTE'}');

      if (uri.queryParameters['signature:integrity'] == null) {
        print('❌ PROBLEMA: Falta signature:integrity en la URL');
      }
    }
  }

  void _handleUrlChange(String url) {
    print('🔍 Analizando URL (InAppWebView): $url');

    // URLs de respuesta personalizadas que configuramos en el checkout
    if (url.startsWith('https://myapp.payment/success') ||
        url.startsWith('https://myapp.payment/error') ||
        url.startsWith('https://myapp.payment/cancel')) {
      print('📍 URL de respuesta detectada: $url');

      // Capturar los parámetros de la URL
      final uri = Uri.tryParse(url);
      if (uri != null) {
        final uriParams = uri.queryParameters;
        print('🎯 Parámetros capturados: $uriParams');

        // Determinar el resultado del pago basado en la URL
        if (url.startsWith('https://myapp.payment/success')) {
          _handleSuccessUrl(url, uriParams);
        } else if (url.startsWith('https://myapp.payment/error') || url.startsWith('https://myapp.payment/cancel')) {
          _handleErrorUrl(url, uriParams);
        }
      }
      return;
    }

    // También verificar parámetros directos de Wompi
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final status = uri.queryParameters['status'];
      final transactionId = uri.queryParameters['id'];

      if (status == 'APPROVED' && transactionId != null) {
        print('✅ Pago APROBADO detectado en URL: $url');
        _handleSuccessUrl(url, uri.queryParameters);
        return;
      }

      if (status == 'DECLINED' || status == 'ERROR') {
        print('❌ Pago RECHAZADO detectado en URL: $url');
        _handleErrorUrl(url, uri.queryParameters);
        return;
      }
    }
  }

  void _handleSuccessUrl(String url, Map<String, String> params) {
    if (_paymentProcessed) return;
    _paymentProcessed = true;

    print('🎉 Procesando URL de éxito: $url');
    print('📋 Parámetros: $params');

    // Buscar el transaction ID en diferentes parámetros
    final transactionId = params['id'] ?? params['transaction_id'] ?? params['transactionId'];

    if (transactionId != null && transactionId.isNotEmpty) {
      print('✅ Transaction ID encontrado: $transactionId');
      _verifyTransactionAndRedirect(transactionId, url);
    } else {
      print('⚠️ URL de éxito pero sin Transaction ID');
      _showPaymentError(
          'No se pudo verificar el estado del pago. Transaction ID no encontrado en la respuesta de Wompi.');
    }
  }

  void _handleErrorUrl(String url, Map<String, String> params) {
    if (_paymentProcessed) return;
    _paymentProcessed = true;

    print('❌ Procesando URL de error: $url');
    print('📋 Parámetros: $params');

    final reason = params['reason'] ?? params['error'] ?? 'El pago fue cancelado o falló';
    _showPaymentError(reason);
  }

  void _verifyTransactionAndRedirect(String transactionId, String originalUrl) async {
    try {
      print('🔍 Verificando estado real de la transacción en Wompi...');
      print('   Transaction ID: $transactionId');

      _showLoadingDialog('Verificando estado del pago...');

      final verificationResult = await WompiPaymentService.verifyTransactionStatus(transactionId);

      // Cerrar diálogo de carga
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (verificationResult == null) {
        print('❌ Error al verificar estado de transacción');
        _showPaymentError('Error al verificar el estado del pago');
        return;
      }

      final isApproved = verificationResult['approved'] as bool;
      final status = verificationResult['status'] as String;
      final transactionDetails = verificationResult['transaction'];

      print('📊 RESULTADO FINAL DE VERIFICACIÓN:');
      print('   Aprobada: $isApproved');
      print('   Status: $status');
      print('   Transaction ID: $transactionId');

      if (isApproved) {
        print('✅ TRANSACCIÓN APROBADA - Navegando a pantalla de éxito');
        _navigateToSuccessScreen(transactionId, transactionDetails);
      } else {
        print('❌ TRANSACCIÓN RECHAZADA - Navegando a pantalla de rechazo');
        _navigateToRejectedScreen(transactionId, transactionDetails, 'El pago fue rechazado. Status: $status');
      }
    } catch (e) {
      print('❌ Error al verificar transacción: $e');
      // Cerrar diálogo de carga si existe
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {}
      }
      _showPaymentError('Error al procesar el pago: $e');
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSuccessScreen(String? transactionId, Map<String, dynamic>? transactionDetails) {
    if (!mounted) return;

    DateTime? approvedAt;
    if (transactionDetails != null) {
      final createdAtStr = transactionDetails['created_at'] as String?;
      if (createdAtStr != null) {
        try {
          approvedAt = DateTime.parse(createdAtStr);
        } catch (e) {
          print('⚠️ Error parsing date: $e');
        }
      }
    }

    // Datos robustos para la navegación
    final extraData = {
      'reference': widget.reference,
      'amount': widget.amount,
      'customerEmail': widget.customerEmail,
      'transactionId': transactionId,
      'approvedAt': (approvedAt ?? DateTime.now()).toIso8601String(),
    };

    print('🚀 Navegando a pantalla de éxito con GoRouter');
    print('📊 Datos enviados: $extraData');

    // Usar pushReplacement para mantener el stack de navegación
    try {
      context.pushReplacement(RoutesNames.paymentSuccess, extra: extraData);
    } catch (e) {
      print('❌ Error en navegación con pushReplacement: $e');
      // Segundo fallback: usar go
      try {
        context.go(RoutesNames.paymentSuccess, extra: extraData);
      } catch (e2) {
        print('❌ Error en navegación con go: $e2');
        // Último fallback: usar Navigator tradicional
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              reference: widget.reference,
              amount: widget.amount,
              customerEmail: widget.customerEmail,
              transactionId: transactionId,
              approvedAt: approvedAt,
            ),
          ),
        );
      }
    }
  }

  void _navigateToRejectedScreen(String? transactionId, Map<String, dynamic>? transactionDetails, String reason) {
    if (!mounted) return;

    DateTime? attemptedAt;
    if (transactionDetails != null) {
      final createdAtStr = transactionDetails['created_at'] as String?;
      if (createdAtStr != null) {
        try {
          attemptedAt = DateTime.parse(createdAtStr);
        } catch (e) {
          print('⚠️ Error parsing date: $e');
        }
      }
    }

    // Datos robustos para la navegación
    final extraData = {
      'reference': widget.reference,
      'amount': widget.amount,
      'customerEmail': widget.customerEmail,
      'transactionId': transactionId,
      'reason': reason,
      'attemptedAt': (attemptedAt ?? DateTime.now()).toIso8601String(),
    };

    print('🚀 Navegando a pantalla de rechazo con GoRouter');
    print('📊 Datos enviados: $extraData');

    // Usar pushReplacement para mantener el stack de navegación
    try {
      context.pushReplacement(RoutesNames.paymentRejected, extra: extraData);
    } catch (e) {
      print('❌ Error en navegación con pushReplacement: $e');
      // Segundo fallback: usar go
      try {
        context.go(RoutesNames.paymentRejected, extra: extraData);
      } catch (e2) {
        print('❌ Error en navegación con go: $e2');
        // Último fallback: usar Navigator tradicional
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentRejectedScreen(
              reference: widget.reference,
              amount: widget.amount,
              customerEmail: widget.customerEmail,
              transactionId: transactionId,
              reason: reason,
              attemptedAt: attemptedAt,
            ),
          ),
        );
      }
    }
  }

  void _showPaymentError(String message) {
    // Evitar mostrar múltiples diálogos
    if (_paymentProcessed) return;
    _paymentProcessed = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(
                FontAwesomeIcons.circleXmark,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text('Pago No Completado'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red[700], size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'No se realizó ningún cargo',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ref: ${widget.reference}',
                      style: TextStyle(fontSize: 12, color: Colors.red[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Cerrar WebView
              },
              child: const Text('Intentar de nuevo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Cerrar WebView
                context.go(RoutesNames.home); // Ir a home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDebugInfo() {
    final uri = Uri.tryParse(widget.paymentUrl);
    final debugInfo = '''
Debug Info - Wompi WebView

URL Original: ${widget.paymentUrl}

Parámetros verificados:
• Public Key: ${uri?.queryParameters['public-key'] ?? 'FALTANTE'}
• Amount: ${uri?.queryParameters['amount-in-cents'] ?? 'FALTANTE'}
• Reference: ${uri?.queryParameters['reference'] ?? 'FALTANTE'}
• Signature:integrity: ${uri?.queryParameters['signature:integrity'] != null ? 'PRESENTE' : 'FALTANTE'}
• Acceptance token: ${uri?.queryParameters['acceptance-token'] != null ? 'PRESENTE' : 'FALTANTE'}

URL Actual: $_currentUrl

Payment Processed: $_paymentProcessed
Loading: $_isLoading
    ''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Info'),
        content: SingleChildScrollView(
          child: Text(
            debugInfo,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              // Copiar al clipboard si es posible
              print(debugInfo);
              Navigator.of(context).pop();
            },
            child: const Text('Log to Console'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          'Pago Wompi',
          style: TextStyle(color: AppColors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('🔄 Recargando WebView...');
              _webViewController?.reload();
            },
            tooltip: 'Recargar',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showDebugInfo();
            },
            tooltip: 'Debug Info',
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.paymentUrl),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
              print('🌐 InAppWebView creado exitosamente');
            },
            onLoadStart: (InAppWebViewController controller, WebUri? url) {
              setState(() {
                _isLoading = true;
                _currentUrl = url?.toString();
              });
              print('📍 InAppWebView iniciando carga: ${url?.toString()}');

              // Verificar si la URL es la inicial de Wompi
              if (url?.toString().contains('checkout.wompi.co') == true) {
                print('✅ Cargando checkout de Wompi correctamente');
              }
            },
            onLoadStop: (InAppWebViewController controller, WebUri? url) async {
              setState(() {
                _isLoading = false;
                _currentUrl = url?.toString();
              });
              print('✅ InAppWebView carga completa: ${url?.toString()}');

              // Verificar si hay errores en la página
              try {
                final title = await controller.getTitle();
                print('📄 Título de la página: $title');

                // Si el título indica un error de Wompi, reportarlo
                if (title != null &&
                    (title.toLowerCase().contains('error') || title.toLowerCase().contains('invalid'))) {
                  print('❌ Posible error en la página de Wompi detectado por título');
                }
              } catch (e) {
                print('⚠️ No se pudo obtener el título de la página: $e');
              }
            },
            onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
              print('❌ Error en InAppWebView: $code - $message');
              print('   URL que falló: $url');

              // Errores específicos de Wompi
              if (message.contains('signature') || message.contains('integrity')) {
                print('🚨 ERROR DE FIRMA: Problema con signature:integrity');
                _showError('Error de firma de integridad. Verifica los parámetros de Wompi.');
              } else if (code == 400) {
                print('🚨 ERROR 400: Parámetros incorrectos enviados a Wompi');
                _showError('Parámetros incorrectos. Verifica la configuración del pago.');
              } else if (code == 401) {
                print('🚨 ERROR 401: Problema de autenticación con Wompi');
                _showError('Error de autenticación con Wompi. Verifica las credenciales.');
              } else {
                _showError('Error de conexión: $message');
              }
            },
            onUpdateVisitedHistory: (InAppWebViewController controller, WebUri? url, bool? androidIsReload) {
              // ESTA ES LA FUNCIÓN CLAVE QUE CAPTURA LAS REDIRECCIONES
              if (url != null && !_paymentProcessed) {
                final urlString = url.toString();
                print('📍 Historial actualizado: $urlString');
                _handleUrlChange(urlString);
              }
            },
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              databaseEnabled: true,
              clearCache: false,
              clearSessionCache: false,
              supportZoom: false,
              builtInZoomControls: false,
              displayZoomControls: false,
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando checkout seguro de Wompi...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
