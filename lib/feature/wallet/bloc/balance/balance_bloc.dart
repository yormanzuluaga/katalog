import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc({
    required BalanceRepository balanceRepository,
  })  : _balanceRepository = balanceRepository,
        super(BalanceInitial()) {
    on<LoadBalance>(_onLoadBalance);
  }

  final BalanceRepository _balanceRepository;

  Future<void> _onLoadBalance(
    LoadBalance event,
    Emitter<BalanceState> emit,
  ) async {
    emit(BalanceLoading());

    try {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;
      final (error, response) = await _balanceRepository.getBalance(
        headers: appState.createHeaders(),
      );

      if (error != null) {
        emit(BalanceError(error.message));
        return;
      }

      if (response != null) {
        emit(BalanceLoaded(balance: response));
      }
    } catch (e) {
      emit(BalanceError('Error al cargar balance: ${e.toString()}'));
    }
  }
}
