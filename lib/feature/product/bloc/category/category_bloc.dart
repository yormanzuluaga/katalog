import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required CategoryRepository categoryRepository,
  })  : _categoryRepository = categoryRepository,
        super(CategoryState()) {
    on<CategoryEvent>((event, emit) {});

    on<GetCategoryEvent>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      final result = await _categoryRepository.getCategory(
        headers: appState.createHeaders(),
      );
      final leftResponse = result.$1;
      final rightResponse = result.$2;
      if (leftResponse != null || rightResponse == null) {
        if (leftResponse?.httpCode == 401) {
          rootNavigatorKey.currentContext!.read<AppBloc>().add(const OnClearSessionEvent());
          Future.delayed(const Duration(milliseconds: 500), () {
            rootNavigatorKey.currentContext!.go(RoutesNames.login);
          });
        }
      } else {
        emit(state.copyWith(category: rightResponse));
      }
    });

    on<GetSubCategoryEvent>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      final result = await _categoryRepository.getSubCategory(
        idCategory: event.idCategory,
        headers: appState.createHeaders(),
      );
      final leftResponse = result.$1;
      final rightResponse = result.$2;
      if (leftResponse != null || rightResponse == null) {
        if (leftResponse?.httpCode == 401) {
          rootNavigatorKey.currentContext!.read<AppBloc>().add(const OnClearSessionEvent());
          Future.delayed(const Duration(milliseconds: 500), () {
            rootNavigatorKey.currentContext!.go(RoutesNames.login);
          });
        }
      } else {
        emit(state.copyWith(subCategory: rightResponse));
      }
    });

    on<GetProductEvent>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      final result = await _categoryRepository.getProduct(
        idProduct: event.idProduct,
        headers: appState.createHeaders(),
      );
      final leftResponse = result.$1;
      final rightResponse = result.$2;
      if (leftResponse != null || rightResponse == null) {
        if (leftResponse?.httpCode == 401) {
          rootNavigatorKey.currentContext!.read<AppBloc>().add(const OnClearSessionEvent());
          Future.delayed(const Duration(milliseconds: 500), () {
            rootNavigatorKey.currentContext!.go(RoutesNames.login);
          });
        }
      } else {
        rootNavigatorKey.currentContext!.go(RoutesNames.productList);

        emit(state.copyWith(product: rightResponse));
      }
    });
  }
  final CategoryRepository _categoryRepository;
}
