import 'package:api_helper/api_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<CartEvent>((event, emit) {});

    on<AddCartEvent>((event, emit) async {
      List<Product> listSale = [];
      List sumList = [];
      double sum = 0;

      if (state.listSale == null || state.listSale!.isEmpty) {
        // Primer producto en el carrito
        final productWithQuantity = event.productsSalesModel.copyWith(quantity: 1);
        final total = (productWithQuantity.pricing?.salePrice ?? 0) * 1;

        listSale.add(productWithQuantity);

        emit(state.copyWith(
          listSale: listSale,
          sumTotal: '$total',
        ));
      } else {
        // Ya hay productos en el carrito
        listSale.addAll(state.listSale!);

        // Verificar si el producto exacto (incluyendo variante) ya existe en el carrito
        final existingIndex = listSale.indexWhere((element) => element.id == event.productsSalesModel.id);

        if (existingIndex != -1) {
          // El producto exacto ya existe (mismo ID = misma variante), incrementar cantidad
          final existingProduct = listSale[existingIndex];
          final newQuantity = (existingProduct.quantity ?? 0) + 1;
          listSale[existingIndex] = existingProduct.copyWith(quantity: newQuantity);
          print(
              '🔄 CartBloc: Incrementando cantidad del producto ${existingProduct.name} - ID: ${existingProduct.id} - Nueva cantidad: $newQuantity');
        } else {
          // Producto nuevo o diferente variante (ID diferente), agregar con cantidad 1
          final productWithQuantity = event.productsSalesModel.copyWith(quantity: 1);
          listSale.add(productWithQuantity);
          print(
              '➕ CartBloc: Agregando nuevo producto/variante: ${productWithQuantity.name} - ID: ${productWithQuantity.id}');
        }

        // Calcular total
        for (var i = 0; i < listSale.length; i++) {
          final data = (listSale[i].pricing?.salePrice ?? 0) * (listSale[i].quantity ?? 1);
          sumList.add(data);
        }
        for (var e in sumList) {
          sum += e;
        }

        emit(state.copyWith(
          listSale: listSale,
          sumTotal: '$sum',
        ));
      }
    });

    on<DeletedCartEvent>((event, emit) async {
      final List<Product> listSale = [];
      final List sumList = [];
      double sum = 0;

      listSale.addAll(state.listSale!);

      var index = listSale.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        listSale.removeAt(index);

        for (var i = 0; i < listSale.length; i++) {
          final data = (listSale[i].pricing?.salePrice ?? 0) * (listSale[i].quantity ?? 1);
          sumList.add(data);
        }
        for (var e in sumList) {
          sum += e;
        }

        final data = listSale.isNotEmpty ? listSale : null;

        if (listSale.isEmpty) {
          // Lista vacía, limpiar completamente el carrito
          emit(state.copyWith(
            clearListSale: true,
            sumTotal: '0.0',
          ));
        } else {
          // Aún hay productos, actualizar la lista
          emit(state.copyWith(
            listSale: data,
            sumTotal: '$sum',
          ));
        }
      }
    });

    on<CountCartEvent>((event, emit) async {
      final List<Product> listSale = [];
      final List sumList = [];
      double sum = 0;

      listSale.addAll(state.listSale!);

      var index = listSale.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        listSale[index] = listSale[index].copyWith(quantity: event.quantity);

        for (var i = 0; i < listSale.length; i++) {
          final data = (listSale[i].pricing?.salePrice ?? 0) * (listSale[i].quantity ?? 1);
          sumList.add(data);
        }
        for (var e in sumList) {
          sum += e;
        }

        emit(state.copyWith(
          listSale: listSale,
          sumTotal: '$sum',
        ));
      }
    });

    on<FinalSalesEvent>((event, emit) async {
      emit(state.copyWith(
        clearListSale: true,
        sumTotal: '0.0',
      ));
    });
  }
}
