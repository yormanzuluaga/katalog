import 'dart:convert';

import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';
import 'package:talentpitch_test/feature/cart/services/wompi_payment_service.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({
    required TransactionsRepository transactionsRepository,
  })  : _transactionsRepository = transactionsRepository,
        super(PaymentInitial()) {
    on<InitializePayment>(_onInitializePayment);
    on<CreatePaymentTransaction>(_onCreatePaymentTransaction);
    on<CreatePaymentSource>(_onCreatePaymentSource);
    on<CheckTransactionStatus>(_onCheckTransactionStatus);
    on<LoadPSEBanks>(_onLoadPSEBanks);
    on<SendTransactionToBackend>(_onSendTransactionToBackend);
  }

  final TransactionsRepository _transactionsRepository;

  Future<void> _onInitializePayment(
    InitializePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      // Obtener el token de aceptación
      final acceptanceToken = await WompiPaymentService.getAcceptanceToken();

      if (acceptanceToken != null) {
        emit(PaymentInitialized(acceptanceToken: acceptanceToken));
      } else {
        emit(PaymentError(
            'No se pudo inicializar el pago. Intenta nuevamente.'));
      }
    } catch (e) {
      emit(PaymentError('Error al inicializar el pago: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePaymentTransaction(
    CreatePaymentTransaction event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final response = await WompiPaymentService.createTransaction(
        amountInCents: event.amountInCents,
        currency: event.currency,
        customerEmail: event.customerEmail,
        reference: event.reference,
        acceptanceToken: event.acceptanceToken,
        customerData: event.customerData,
        shippingAddress: event.shippingAddress,
      );

      if (response != null) {
        emit(PaymentTransactionCreated(
          transactionResponse: response,
          reference: event.reference,
        ));
      } else {
        emit(PaymentError(
            'No se pudo crear la transacción. Intenta nuevamente.'));
      }
    } catch (e) {
      emit(PaymentError('Error al crear transacción: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePaymentSource(
    CreatePaymentSource event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      // TODO: Actualizar para usar el nuevo servicio WompiPaymentService
      // El nuevo servicio usa processPaymentWithPSE() o processPaymentWithNequi()
      // en lugar de createPaymentSource()

      emit(const PaymentError(
          'Método createPaymentSource no implementado en el nuevo servicio'));

      /*
      // Código comentado del método anterior:
      // final response = await WompiPaymentService.createPaymentSource(
      //   type: event.type,
      //   acceptanceToken: event.acceptanceToken,
      //   additionalData: event.additionalData,
      // );
      // if (response != null) {
      //   emit(PaymentSourceCreated(paymentSourceResponse: response));
      // } else {
      //   emit(PaymentError('No se pudo crear la fuente de pago. Intenta nuevamente.'));
      // }
      */
    } catch (e) {
      emit(PaymentError('Error al crear fuente de pago: ${e.toString()}'));
    }
  }

  Future<void> _onCheckTransactionStatus(
    CheckTransactionStatus event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final status =
          await WompiPaymentService.getTransactionStatus(event.transactionId);

      if (status != null) {
        emit(PaymentStatusChecked(transactionStatus: status));
      } else {
        emit(PaymentError('No se pudo verificar el estado del pago.'));
      }
    } catch (e) {
      emit(PaymentError('Error al verificar estado: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPSEBanks(
    LoadPSEBanks event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final banks = await WompiPaymentService.getPSEBanks();

      if (banks != null) {
        emit(PSEBanksLoaded(banks: banks));
      } else {
        emit(PaymentError('No se pudieron cargar los bancos PSE.'));
      }
    } catch (e) {
      emit(PaymentError('Error al cargar bancos PSE: ${e.toString()}'));
    }
  }

  Future<void> _onSendTransactionToBackend(
    SendTransactionToBackend event,
    Emitter<PaymentState> emit,
  ) async {
    emit(SendingTransactionToBackend());

    try {
      print('📤 BLoC: Enviando transacción al backend...');

      // Construir los items de la transacción desde el carrito
      final transactionItems = _buildTransactionItems(event.cartItems);

      // Crear el modelo de transacción
      final transaction = PaymentTransactionModel(
        items: transactionItems,
        shippingAddressId: event.shippingAddressId,
        wompiTransactionId: event.wompiTransactionId,
        wompiReference: event.wompiReference,
        paymentStatus: event.paymentStatus.toLowerCase(),
        customerEmail: event.customerEmail,
        approvalCode: '1234',
      );

      print('📋 BLoC: JSON completo de la transacción:');
      print(jsonEncode(transaction.toJson()));

      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;
      final (error, success) = await _transactionsRepository.createTransaction(
        transaction: transaction,
        headers: appState.createHeaders(),
      );

      if (error != null) {
        print('❌ BLoC: Error del backend: ${error.message}');
        emit(TransactionBackendError(
          message: 'Error al guardar la transacción: ${error.message}',
          wompiTransactionId: event.wompiTransactionId,
        ));
        return;
      }

      if (success == true) {
        print('✅ BLoC: Transacción guardada exitosamente en el backend');
        emit(TransactionSentToBackend(
          wompiTransactionId: event.wompiTransactionId,
          wompiReference: event.wompiReference,
        ));
      } else {
        print('⚠️ BLoC: Backend respondió con éxito=false');
        emit(TransactionBackendError(
          message: 'No se pudo guardar la transacción',
          wompiTransactionId: event.wompiTransactionId,
        ));
      }
    } catch (e) {
      print('❌ BLoC: Excepción al enviar transacción al backend: $e');
      emit(TransactionBackendError(
        message: 'Error al procesar la transacción: ${e.toString()}',
        wompiTransactionId: event.wompiTransactionId,
      ));
    }
  }

  List<TransactionItem> _buildTransactionItems(List<Product> cartItems) {
    return cartItems.map((product) {
      // Determinar el tipo de producto
      final productType =
          (product.variants != null && product.variants!.isNotEmpty)
              ? 'variable'
              : 'simple';

      // Construir datos de variante si existen
      String? variantSku;
      SelectedVariant? selectedVariant;

      if (product.variants != null && product.variants!.isNotEmpty) {
        final variant = product.variants!.first;

        // Asignar el SKU de la variante
        variantSku = variant.sku;

        // Construir selectedVariant solo con color si existe
        if (variant.color != null) {
          selectedVariant = SelectedVariant(
            color: ColorVariation(
              name: variant.color!.name ?? '',
              code: variant.color!.code ?? '',
            ),
            size: variant.size,
          );
        }
      }

      // Extraer el ID original del producto (sin el sufijo de variante)
      final originalProductId = _extractOriginalProductId(product.id ?? '');

      return TransactionItem(
        productId: originalProductId,
        productType: productType,
        quantity: product.quantity ?? 1,
        unitPrice: product.pricing?.salePrice?.toDouble() ?? 0.0,
        commission: product.pricing?.commission?.toDouble() ?? 0.0,
        variantSku: variantSku,
        selectedVariant: selectedVariant,
      );
    }).toList();
  }

  /// Extrae el ID original del producto removiendo el sufijo de variante
  /// Ejemplo: "691a1d942853a326a14b2b74_color_rojo_pasión_sku_ll-matte-red01" -> "691a1d942853a326a14b2b74"
  String _extractOriginalProductId(String productId) {
    // Si el ID contiene "_color_", "_size_" o "_sku_", es un ID modificado
    if (productId.contains('_color_') ||
        productId.contains('_size_') ||
        productId.contains('_sku_')) {
      // Extraer solo la primera parte antes del primer "_"
      return productId.split('_').first;
    }
    // Si no tiene sufijos, devolver el ID tal cual
    return productId;
  }
}
