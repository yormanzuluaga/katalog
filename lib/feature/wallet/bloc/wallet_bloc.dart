import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_helper/api_helper.dart';

// Events
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {}

class RefreshWallet extends WalletEvent {}

class RequestWithdrawal extends WalletEvent {
  final double amount;

  const RequestWithdrawal(this.amount);

  @override
  List<Object?> get props => [amount];
}

class LoadTransactionDetail extends WalletEvent {
  final String transactionId;

  const LoadTransactionDetail(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

// States
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletModel wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

class WithdrawalProcessing extends WalletState {}

class WithdrawalSuccess extends WalletState {
  final String message;

  const WithdrawalSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class WithdrawalError extends WalletState {
  final String message;

  const WithdrawalError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  // final WalletRepository _repository;

  WalletBloc() : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<RefreshWallet>(_onRefreshWallet);
    on<RequestWithdrawal>(_onRequestWithdrawal);
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      // TODO: Reemplazar con llamada real a la API
      // final wallet = await _repository.getWallet();

      // Datos de ejemplo - eliminar cuando integres con API real
      await Future.delayed(const Duration(seconds: 1));
      final wallet = WalletModel(
        balance: 2450.50,
        totalEarnings: 5230.75,
        pendingEarnings: 320.00,
        transactions: [
          TransactionModel(
            id: '1',
            type: 'sale',
            amount: 150.00,
            date: DateTime.now().subtract(const Duration(hours: 2)),
            status: 'completed',
            orderId: 'ORD-001',
            productName: 'Producto Premium',
            description: 'Venta de producto',
          ),
          TransactionModel(
            id: '2',
            type: 'sale',
            amount: 89.99,
            date: DateTime.now().subtract(const Duration(days: 1)),
            status: 'completed',
            orderId: 'ORD-002',
            productName: 'Servicio de consultoría',
            description: 'Venta de servicio',
          ),
          TransactionModel(
            id: '3',
            type: 'withdrawal',
            amount: 500.00,
            date: DateTime.now().subtract(const Duration(days: 2)),
            status: 'pending',
            description: 'Retiro a cuenta bancaria',
          ),
        ],
      );

      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError('Error al cargar el wallet: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshWallet(
    RefreshWallet event,
    Emitter<WalletState> emit,
  ) async {
    // Mantener el estado actual mientras se recarga
    if (state is WalletLoaded) {
      final currentWallet = (state as WalletLoaded).wallet;
      emit(WalletLoaded(currentWallet));
    }

    try {
      // TODO: Reemplazar con llamada real a la API
      // final wallet = await _repository.getWallet();

      await Future.delayed(const Duration(seconds: 1));
      final wallet = WalletModel(
        balance: 2450.50,
        totalEarnings: 5230.75,
        pendingEarnings: 320.00,
        transactions: [],
      );

      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError('Error al actualizar el wallet: ${e.toString()}'));
    }
  }

  Future<void> _onRequestWithdrawal(
    RequestWithdrawal event,
    Emitter<WalletState> emit,
  ) async {
    emit(WithdrawalProcessing());

    try {
      // Validaciones
      if (state is WalletLoaded) {
        final wallet = (state as WalletLoaded).wallet;

        if (event.amount <= 0) {
          emit(const WithdrawalError('El monto debe ser mayor a 0'));
          emit(WalletLoaded(wallet));
          return;
        }

        if (event.amount > wallet.balance) {
          emit(const WithdrawalError('Saldo insuficiente'));
          emit(WalletLoaded(wallet));
          return;
        }
      }

      // TODO: Reemplazar con llamada real a la API
      // await _repository.requestWithdrawal(event.amount);

      await Future.delayed(const Duration(seconds: 2));

      emit(const WithdrawalSuccess('Solicitud de retiro enviada exitosamente'));

      // Recargar el wallet después del retiro
      add(LoadWallet());
    } catch (e) {
      emit(WithdrawalError('Error al procesar el retiro: ${e.toString()}'));
      if (state is WalletLoaded) {
        final wallet = (state as WalletLoaded).wallet;
        emit(WalletLoaded(wallet));
      }
    }
  }
}
