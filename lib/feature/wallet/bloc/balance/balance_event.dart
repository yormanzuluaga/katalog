part of 'balance_bloc.dart';

abstract class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object> get props => [];
}

class LoadBalance extends BalanceEvent {
  const LoadBalance();
}
