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
        emit(PaymentError('No se pudo inicializar el pago. Intenta nuevamente.'));
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
        emit(PaymentError('No se pudo crear la transacción. Intenta nuevamente.'));
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

      emit(const PaymentError('Método createPaymentSource no implementado en el nuevo servicio'));

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
      final status = await WompiPaymentService.getTransactionStatus(event.transactionId);

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
        approvalCode: event.approvalCode,
      );

      print('📊 BLoC: Datos de transacción construidos:');
      print('   Items: ${transaction.items.length}');
      print('   Shipping Address ID: ${transaction.shippingAddressId}');
      print('   Wompi Transaction ID: ${transaction.wompiTransactionId}');
      print('   Payment Status: ${transaction.paymentStatus}');
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;
      // Enviar al backend usando el repositorio
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
      final productType = (product.variants != null && product.variants!.isNotEmpty) ? 'variable' : 'simple';

      // Construir variaciones si existen
      ProductVariations? variations;
      if (product.variants != null && product.variants!.isNotEmpty) {
        final variant = product.variants!.first;

        variations = ProductVariations(
          color: variant.color != null
              ? ColorVariation(
                  name: variant.color!.name ?? '',
                  code: variant.color!.code ?? '',
                  image: null, // El modelo Colores no tiene campo de imagen
                )
              : null,
          size: variant.size != null
              ? SizeVariation(
                  name: variant.size!,
                  code: variant.size!,
                )
              : null,
        );
      }

      return TransactionItem(
        productId: product.id ?? '',
        productType: productType,
        quantity: product.quantity ?? 1,
        unitPrice: product.pricing?.salePrice?.toDouble() ?? 0.0,
        commission: product.pricing?.commission?.toDouble() ?? 0.0,
        variations: variations,
      );
    }).toList();
  }
}
