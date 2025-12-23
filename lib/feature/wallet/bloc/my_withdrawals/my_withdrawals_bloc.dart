import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';

// Events
abstract class MyWithdrawalsEvent extends Equatable {
  const MyWithdrawalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyWithdrawals extends MyWithdrawalsEvent {
  const LoadMyWithdrawals();
}

class RefreshMyWithdrawals extends MyWithdrawalsEvent {
  const RefreshMyWithdrawals();
}

// States
abstract class MyWithdrawalsState extends Equatable {
  const MyWithdrawalsState();

  @override
  List<Object?> get props => [];
}

class MyWithdrawalsInitial extends MyWithdrawalsState {}

class MyWithdrawalsLoading extends MyWithdrawalsState {}

class MyWithdrawalsLoaded extends MyWithdrawalsState {
  final List<MyWithdrawal> withdrawals;

  const MyWithdrawalsLoaded(this.withdrawals);

  @override
  List<Object?> get props => [withdrawals];
}

class MyWithdrawalsError extends MyWithdrawalsState {
  final String message;

  const MyWithdrawalsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class MyWithdrawalsBloc extends Bloc<MyWithdrawalsEvent, MyWithdrawalsState> {
  final WithdrawalRepository _withdrawalRepository;

  MyWithdrawalsBloc({
    required WithdrawalRepository withdrawalRepository,
  })  : _withdrawalRepository = withdrawalRepository,
        super(MyWithdrawalsInitial()) {
    on<LoadMyWithdrawals>(_onLoadMyWithdrawals);
    on<RefreshMyWithdrawals>(_onRefreshMyWithdrawals);
  }

  Future<void> _onLoadMyWithdrawals(
    LoadMyWithdrawals event,
    Emitter<MyWithdrawalsState> emit,
  ) async {
    emit(MyWithdrawalsLoading());

    try {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      final (error, withdrawals) = await _withdrawalRepository.getMyWithdrawals(
        headers: appState.createHeaders(),
      );

      if (error != null) {
        emit(MyWithdrawalsError(
            'Error al cargar los retiros: ${error.message}'));
        return;
      }

      if (withdrawals != null) {
        emit(MyWithdrawalsLoaded(withdrawals));
      } else {
        emit(const MyWithdrawalsError('No se pudieron cargar los retiros'));
      }
    } catch (e) {
      emit(MyWithdrawalsError('Error inesperado: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshMyWithdrawals(
    RefreshMyWithdrawals event,
    Emitter<MyWithdrawalsState> emit,
  ) async {
    try {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      final (error, withdrawals) = await _withdrawalRepository.getMyWithdrawals(
        headers: appState.createHeaders(),
      );

      if (error != null) {
        emit(MyWithdrawalsError(
            'Error al actualizar los retiros: ${error.message}'));
        return;
      }

      if (withdrawals != null) {
        emit(MyWithdrawalsLoaded(withdrawals));
      } else {
        emit(const MyWithdrawalsError('No se pudieron actualizar los retiros'));
      }
    } catch (e) {
      emit(MyWithdrawalsError('Error inesperado: ${e.toString()}'));
    }
  }
}
