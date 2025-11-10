import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Servicio para gestionar pagos con Wompi
class WompiPaymentService {
  static const String _publicKey = 'pub_test_ndxNzt5NE33wReX3pT7UeVO5fFHJaxxV';
  static const String _baseUrl = 'https://sandbox.wompi.co/v1'; // Sandbox para pruebas

  // Claves específicas de Wompi
  static const String _eventsKey = 'test_events_FfTfieB3mRTvgk596lx77hNUZdZjLcNV';
  static const String _integrityKey = 'test_integrity_Y5HcTrCbKEzGcfZDGINTcEjHwpseSl6s';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_publicKey',
  };

  /// Inicializar Wompi
  static Future<void> initialize() async {
    try {
      // Inicializar el widget de Wompi con las configuraciones básicas
      print('Inicializando Wompi con clave pública: $_publicKey');
    } catch (e) {
      print('Error al inicializar Wompi: $e');
    }
  }

  /// Obtener token de aceptación
  static Future<String?> getAcceptanceToken() async {
    try {
      print('🔐 Obteniendo token de aceptación...');
      final url = Uri.parse('$_baseUrl/merchants/$_publicKey');
      print('🌐 URL: $url');

      final response = await http.get(url, headers: _headers);
      print('📡 Respuesta status: ${response.statusCode}');
      print('📡 Respuesta body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['data']['presigned_acceptance']['acceptance_token'];
        print('✅ Token obtenido exitosamente: ${token?.substring(0, 20)}...');
        return token;
      } else {
        print('❌ Error en respuesta: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error al obtener token de aceptación: $e');
      return null;
    }
  }

  /// Crear transacción
  static Future<Map<String, dynamic>?> createTransaction({
    required int amountInCents,
    required String currency,
    required String customerEmail,
    required String reference,
    required String acceptanceToken,
    Map<String, dynamic>? paymentMethod,
    Map<String, dynamic>? customerData,
    Map<String, dynamic>? shippingAddress,
  }) async {
    try {
      print('💳 Creando transacción...');
      final url = Uri.parse('$_baseUrl/transactions');
      print('🌐 URL: $url');

      final body = {
        'amount_in_cents': amountInCents,
        'currency': currency,
        'customer_email': customerEmail,
        'reference': reference,
        'acceptance_token': acceptanceToken,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (customerData != null) 'customer_data': customerData,
        if (shippingAddress != null) 'shipping_address': shippingAddress,
      };

      print('📦 Body de la transacción:');
      print(json.encode(body));

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );

      print('📡 Respuesta status: ${response.statusCode}');
      print('📡 Respuesta body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        print('✅ Transacción creada exitosamente');
        return result;
      }

      print('❌ Error crear transacción: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('❌ Error al crear transacción: $e');
      return null;
    }
  }

  /// Obtener estado de transacción
  static Future<Map<String, dynamic>?> getTransactionStatus(String transactionId) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions/$transactionId');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error al consultar estado de transacción: $e');
      return null;
    }
  }

  /// Obtener estado detallado de transacción desde Wompi
  static Future<Map<String, dynamic>?> getDetailedTransactionStatus(String transactionId) async {
    try {
      print('🔍 Consultando estado detallado de transacción: $transactionId');
      final url = Uri.parse('$_baseUrl/transactions/$transactionId');
      final response = await http.get(url, headers: _headers);

      print('📡 Respuesta status transacción: ${response.statusCode}');
      print('📡 Respuesta body transacción: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transaction = data['data'];

        print('✅ Estado de transacción obtenido:');
        print('   ID: ${transaction['id']}');
        print('   Status: ${transaction['status']}');
        print('   Amount: ${transaction['amount_in_cents']}');
        print('   Reference: ${transaction['reference']}');
        print('   Created at: ${transaction['created_at']}');

        return transaction;
      } else {
        print('❌ Error al obtener estado de transacción: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error al consultar estado de transacción: $e');
      return null;
    }
  }

  /// Procesar pago con PSE
  static Future<Map<String, dynamic>?> processPaymentWithPSE({
    required double amount,
    required String customerEmail,
    required String reference,
    required String bankCode,
    required String userType, // '0': Natural, '1': Juridica
    required String userDocument,
    required String documentType, // 'CC', 'CE', 'NIT', 'PP'
    Map<String, dynamic>? customerData,
    Map<String, dynamic>? shippingAddress,
  }) async {
    try {
      print('🏛️ ====== INICIANDO PAGO PSE ======');
      print('💰 Monto recibido: $amount COP');
      print('💰 Monto en centavos: ${(amount * 100).round()}');
      print('📧 Email: $customerEmail');
      print('📝 Referencia: $reference');
      print('🏦 Banco: $bankCode');
      print('👤 Tipo usuario: $userType');
      print('👤 Documento: $documentType $userDocument');

      // Verificar monto mínimo (1500 COP = 150000 centavos)
      final amountInCents = (amount * 100).round();
      if (amountInCents < 150000) {
        print('❌ ERROR: Monto menor al mínimo permitido (1500 COP)');
        return {'error': 'El monto mínimo es \$1,500 COP'};
      }

      final acceptanceToken = await getAcceptanceToken();
      if (acceptanceToken == null) {
        print('❌ No se pudo obtener el token de aceptación');
        return {'error': 'No se pudo obtener token de aceptación'};
      }

      print('✅ Token de aceptación obtenido exitosamente');

      final paymentMethod = {
        'type': 'PSE',
        'user_type': userType,
        'user_legal_id': userDocument,
        'user_legal_id_type': documentType,
        'financial_institution_code': bankCode,
        'payment_description': 'Pago TalentPitch',
      };

      print('🔧 Método de pago configurado:');
      print(json.encode(paymentMethod));

      final result = await createTransaction(
        amountInCents: amountInCents,
        currency: 'COP',
        customerEmail: customerEmail,
        reference: reference,
        acceptanceToken: acceptanceToken,
        paymentMethod: paymentMethod,
        customerData: customerData,
        shippingAddress: shippingAddress,
      );

      if (result != null) {
        print('✅ Pago PSE procesado exitosamente');
        print('🔄 Respuesta completa del servicio:');
        print(json.encode(result));
      } else {
        print('❌ Error al procesar pago PSE - resultado nulo');
        return {'error': 'Error al procesar el pago PSE'};
      }

      print('🏛️ ====== FIN PAGO PSE ======');
      return result;
    } catch (e) {
      print('❌ EXCEPCIÓN al procesar pago PSE: $e');
      print('❌ Tipo de excepción: ${e.runtimeType}');
      return {'error': 'Excepción al procesar pago: $e'};
    }
  }

  /// Procesar pago con Nequi
  static Future<Map<String, dynamic>?> processPaymentWithNequi({
    required double amount,
    required String customerEmail,
    required String reference,
    required String phoneNumber,
    Map<String, dynamic>? customerData,
    Map<String, dynamic>? shippingAddress,
  }) async {
    try {
      final acceptanceToken = await getAcceptanceToken();
      if (acceptanceToken == null) return null;

      final paymentMethod = {
        'type': 'NEQUI',
        'phone_number': phoneNumber,
      };

      return await createTransaction(
        amountInCents: (amount * 100).round(),
        currency: 'COP',
        customerEmail: customerEmail,
        reference: reference,
        acceptanceToken: acceptanceToken,
        paymentMethod: paymentMethod,
        customerData: customerData,
        shippingAddress: shippingAddress,
      );
    } catch (e) {
      print('Error al procesar pago Nequi: $e');
      return null;
    }
  }

  /// Obtener bancos PSE disponibles
  static Future<List<Map<String, dynamic>>?> getPSEBanks() async {
    try {
      print('🏦 Obteniendo lista de bancos PSE...');
      final url = Uri.parse('$_baseUrl/pse/financial_institutions');
      print('🌐 URL bancos: $url');

      final response = await http.get(url, headers: _headers);
      print('📡 Respuesta bancos status: ${response.statusCode}');
      print(
          '📡 Respuesta bancos body: ${response.body.length > 500 ? "${response.body.substring(0, 500)}..." : response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final banks = List<Map<String, dynamic>>.from(data['data']);
        print('✅ ${banks.length} bancos PSE obtenidos exitosamente');
        return banks;
      } else {
        print('❌ Error al obtener bancos: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error al obtener bancos PSE: $e');
      return null;
    }
  }

  /// Generar referencia única
  static String generateReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'TLNTPTCH_$timestamp';
  }

  /// Convertir monto en pesos a centavos
  static int convertToAmountInCents(double amount) {
    return (amount * 100).round();
  }

  /// Generar firma de integridad para el checkout
  /// Según documentación oficial de Wompi: "<Referencia><Monto><Moneda><SecretoIntegridad>"
  /// NO incluir acceptance_token ni public_key
  static String generateIntegritySignature({
    required String reference,
    required String amountInCents,
    required String currency,
    String? encryptionKey,
    // Los siguientes parámetros se mantienen por compatibilidad pero NO se usan
    String? acceptanceToken,
    String? publicKey,
  }) {
    try {
      // Usar la clave específica de integridad de Wompi
      final key = encryptionKey ?? _integrityKey;

      // Crear la cadena a firmar según documentación oficial de Wompi:
      // ORDEN CORRECTO: reference + amount_in_cents + currency + secret_integrity
      final stringToSign = '$reference$amountInCents$currency$key';

      print('🔏 Generando firma de integridad (FORMATO OFICIAL)...');
      print('📝 Parámetros: ref=$reference, amount=$amountInCents, currency=$currency');
      print('🔑 Integrity key: ${key.substring(0, 20)}...');
      print('� String a firmar: ${stringToSign.substring(0, 50)}...');

      // Generar hash SHA256
      final bytes = utf8.encode(stringToSign);
      final digest = sha256.convert(bytes);
      final signature = digest.toString();

      print('✅ Firma generada (OFICIAL): ${signature.substring(0, 20)}...');
      return signature;
    } catch (e) {
      print('❌ Error generando firma de integridad: $e');
      // Retornar una firma por defecto en caso de error
      return sha256.convert(utf8.encode('fallback_checkout_signature')).toString();
    }
  }

  /// Validar firma de webhook usando la clave de eventos
  /// Útil para validar notificaciones de Wompi
  static bool validateWebhookSignature({
    required String payload,
    required String signature,
    required String timestamp,
  }) {
    try {
      print('🔍 Validando firma de webhook...');

      // Crear la cadena a firmar para webhook: timestamp + payload
      final stringToSign = '$timestamp$payload';

      // Generar hash usando la clave de eventos
      final bytes = utf8.encode(stringToSign + _eventsKey);
      final digest = sha256.convert(bytes);
      final expectedSignature = digest.toString();

      final isValid = signature == expectedSignature;
      print(isValid ? '✅ Firma de webhook válida' : '❌ Firma de webhook inválida');

      return isValid;
    } catch (e) {
      print('❌ Error validando firma de webhook: $e');
      return false;
    }
  }

  /// Verificar estado específico de transacción (APROBADA/RECHAZADA)
  /// Retorna: {'approved': true/false, 'status': 'APPROVED/DECLINED', 'transaction': data}
  static Future<Map<String, dynamic>?> verifyTransactionStatus(String transactionId) async {
    try {
      print('🔍 Verificando estado específico de transacción: $transactionId');

      final transactionData = await getDetailedTransactionStatus(transactionId);
      if (transactionData == null) {
        print('❌ No se pudo obtener datos de la transacción de Wompi');
        print('❌ Esto puede indicar que la transacción no existe o hay error de API');
        return null;
      }

      final status = transactionData['status'] as String?;
      final paymentMethod = transactionData['payment_method'];

      print('📊 Análisis del estado:');
      print('   Status principal: $status');
      print('   Payment method: $paymentMethod');
      print('   Transaction data: ${transactionData.toString().substring(0, 200)}...');

      if (status == null || status.isEmpty) {
        print('❌ Status de transacción es nulo o vacío');
        return {
          'approved': false,
          'status': 'ERROR',
          'transaction': transactionData,
          'transactionId': transactionId,
          'error': 'Status de transacción no disponible'
        };
      }

      bool isApproved = false;
      String finalStatus = status.toUpperCase();

      // Verificar diferentes estados que indican aprobación
      if (finalStatus == 'APPROVED') {
        isApproved = true;
        print('✅ Transacción APROBADA confirmada');
      } else if (finalStatus == 'DECLINED' ||
          finalStatus == 'ERROR' ||
          finalStatus == 'VOIDED' ||
          finalStatus == 'REJECTED') {
        isApproved = false;
        print('❌ Transacción RECHAZADA confirmada (Status: $finalStatus)');
      } else if (finalStatus == 'PENDING') {
        isApproved = false;
        print('⏳ Transacción aún PENDIENTE');
      } else {
        print('⚠️ Estado desconocido: $status');
        print('⚠️ Por seguridad, tratando como rechazada');
        isApproved = false;
        finalStatus = 'UNKNOWN';
      }

      final result = {
        'approved': isApproved,
        'status': finalStatus,
        'transaction': transactionData,
        'transactionId': transactionId,
      };

      print('📊 RESULTADO FINAL DE VERIFICACIÓN:');
      print('   Approved: $isApproved');
      print('   Final Status: $finalStatus');

      return result;
    } catch (e) {
      print('❌ EXCEPCIÓN al verificar estado de transacción: $e');
      print('❌ Transaction ID: $transactionId');
      return {
        'approved': false,
        'status': 'ERROR',
        'transaction': null,
        'transactionId': transactionId,
        'error': e.toString()
      };
    }
  }
}
