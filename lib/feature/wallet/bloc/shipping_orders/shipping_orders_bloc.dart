import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';

part 'shipping_orders_event.dart';
part 'shipping_orders_state.dart';

class ShippingOrdersBloc
    extends Bloc<ShippingOrdersEvent, ShippingOrdersState> {
  ShippingOrdersBloc({
    required ShippingOrderRepository shippingOrderRepository,
  })  : _shippingOrderRepository = shippingOrderRepository,
        super(ShippingOrdersInitial()) {
    on<LoadMyOrders>(_onLoadMyOrders);
    on<LoadPendingOrders>(_onLoadPendingOrders);
  }

  final ShippingOrderRepository _shippingOrderRepository;

  Future<void> _onLoadMyOrders(
    LoadMyOrders event,
    Emitter<ShippingOrdersState> emit,
  ) async {
    emit(ShippingOrdersLoading());

    try {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;
      final (error, response) = await _shippingOrderRepository.getMyOrders(
        headers: appState.createHeaders(),
      );

      if (error != null) {
        emit(ShippingOrdersError(error.message));
        return;
      }

      if (response != null) {
        emit(ShippingOrdersLoaded(
          orders: response.orders,
          total: response.total,
          hasMore: response.hasMore,
        ));
      }
    } catch (e) {
      emit(ShippingOrdersError('Error al cargar pedidos: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPendingOrders(
    LoadPendingOrders event,
    Emitter<ShippingOrdersState> emit,
  ) async {
    emit(ShippingOrdersLoading());

    try {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;
      final (error, response) =
          await _shippingOrderRepository.getPendingOrders(
        headers: appState.createHeaders(),
      );

      if (error != null) {
        emit(ShippingOrdersError(error.message));
        return;
      }

      if (response != null) {
        emit(ShippingOrdersLoaded(
          orders: response.orders,
          total: response.total,
          hasMore: response.hasMore,
        ));
      }
    } catch (e) {
      emit(ShippingOrdersError(
          'Error al cargar pedidos pendientes: ${e.toString()}'));
    }
  }
}
