import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/cart/services/wompi_payment_service.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<InitializePayment>(_onInitializePayment);
    on<CreatePaymentTransaction>(_onCreatePaymentTransaction);
    on<CreatePaymentSource>(_onCreatePaymentSource);
    on<CheckTransactionStatus>(_onCheckTransactionStatus);
    on<LoadPSEBanks>(_onLoadPSEBanks);
  }

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
}
