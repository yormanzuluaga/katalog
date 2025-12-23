part of 'balance_bloc.dart';

abstract class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object> get props => [];
}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceLoaded extends BalanceState {
  const BalanceLoaded({required this.balance});

  final WalletBalanceResponse balance;

  @override
  List<Object> get props => [balance];
}

class BalanceError extends BalanceState {
  const BalanceError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
