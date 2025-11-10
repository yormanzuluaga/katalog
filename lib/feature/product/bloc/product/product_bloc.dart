import 'package:api_helper/api_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState()) {
    on<ProductEvent>((event, emit) {});

    on<GetProductEvent>((event, emit) async {
      emit(state.copyWith(
          // productList: [],
          ));
    });

    on<CleanProductEvent>((event, emit) => emit(state.copyWith(
        // productList: null,
        )));
  }
}
