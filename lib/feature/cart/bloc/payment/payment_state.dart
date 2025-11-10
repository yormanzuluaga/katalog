part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitialized extends PaymentState {
  final String acceptanceToken;

  const PaymentInitialized({required this.acceptanceToken});

  @override
  List<Object?> get props => [acceptanceToken];
}

class PaymentTransactionCreated extends PaymentState {
  final Map<String, dynamic> transactionResponse;
  final String reference;

  const PaymentTransactionCreated({
    required this.transactionResponse,
    required this.reference,
  });

  @override
  List<Object?> get props => [transactionResponse, reference];
}

class PaymentSourceCreated extends PaymentState {
  final Map<String, dynamic> paymentSourceResponse;

  const PaymentSourceCreated({required this.paymentSourceResponse});

  @override
  List<Object?> get props => [paymentSourceResponse];
}

class PaymentStatusChecked extends PaymentState {
  final Map<String, dynamic> transactionStatus;

  const PaymentStatusChecked({required this.transactionStatus});

  @override
  List<Object?> get props => [transactionStatus];
}

class PSEBanksLoaded extends PaymentState {
  final List<Map<String, dynamic>> banks;

  const PSEBanksLoaded({required this.banks});

  @override
  List<Object?> get props => [banks];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentSuccess extends PaymentState {
  final String transactionId;
  final String reference;
  final int amount;

  const PaymentSuccess({
    required this.transactionId,
    required this.reference,
    required this.amount,
  });

  @override
  List<Object?> get props => [transactionId, reference, amount];
}
