part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitializePayment extends PaymentEvent {
  const InitializePayment();
}

class CreatePaymentTransaction extends PaymentEvent {
  final int amountInCents;
  final String currency;
  final String customerEmail;
  final String reference;
  final String acceptanceToken;
  final Map<String, dynamic>? customerData;
  final Map<String, dynamic>? shippingAddress;

  const CreatePaymentTransaction({
    required this.amountInCents,
    required this.currency,
    required this.customerEmail,
    required this.reference,
    required this.acceptanceToken,
    this.customerData,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [
        amountInCents,
        currency,
        customerEmail,
        reference,
        acceptanceToken,
        customerData,
        shippingAddress,
      ];
}

class CreatePaymentSource extends PaymentEvent {
  final String type;
  final String acceptanceToken;
  final Map<String, dynamic>? additionalData;

  const CreatePaymentSource({
    required this.type,
    required this.acceptanceToken,
    this.additionalData,
  });

  @override
  List<Object?> get props => [type, acceptanceToken, additionalData];
}

class CheckTransactionStatus extends PaymentEvent {
  final String transactionId;

  const CheckTransactionStatus({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class LoadPSEBanks extends PaymentEvent {
  const LoadPSEBanks();
}
