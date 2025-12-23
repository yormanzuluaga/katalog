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
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;

  CategoryBloc({
    required CategoryRepository categoryRepository,
    required BrandRepository brandRepository,
  })  : _categoryRepository = categoryRepository,
        _brandRepository = brandRepository,
        super(const CategoryState()) {
    on<GetCategoryEvent>(_onGetCategory);
    on<GetSubCategoryEvent>(_onGetSubCategory);
    on<GetProductEvent>(_onGetProduct);
    on<FilterProductEvent>(_onFilterProduct);
    on<ClearFilterEvent>(_onClearFilter);
    on<LoadBrandsEvent>(_onLoadBrands);
    on<LoadProductsByBrandEvent>(_onLoadProductsByBrand);
  }

  Future<void> _onGetCategory(
    GetCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _categoryRepository.getCategory(
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      if (result.$1?.httpCode == 401) {
        rootNavigatorKey.currentContext!
            .read<AppBloc>()
            .add(const OnClearSessionEvent());
        Future.delayed(const Duration(milliseconds: 500), () {
          rootNavigatorKey.currentContext!.go(RoutesNames.login);
        });
      }
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(category: result.$2));
    } else {
      emit(state.copyWith(message: 'No se pudieron cargar las categorías'));
    }
  }

  Future<void> _onGetSubCategory(
    GetSubCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _categoryRepository.getSubCategory(
      idCategory: event.idCategory,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      if (result.$1?.httpCode == 401) {
        rootNavigatorKey.currentContext!
            .read<AppBloc>()
            .add(const OnClearSessionEvent());
        Future.delayed(const Duration(milliseconds: 500), () {
          rootNavigatorKey.currentContext!.go(RoutesNames.login);
        });
      }
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(subCategory: result.$2));
    } else {
      emit(state.copyWith(message: 'No se pudieron cargar las subcategorías'));
    }
  }

  Future<void> _onGetProduct(
    GetProductEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _categoryRepository.getProduct(
      idProduct: event.idProduct,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      if (result.$1?.httpCode == 401) {
        rootNavigatorKey.currentContext!
            .read<AppBloc>()
            .add(const OnClearSessionEvent());
        Future.delayed(const Duration(milliseconds: 500), () {
          rootNavigatorKey.currentContext!.go(RoutesNames.login);
        });
      }
      return;
    }

    if (result.$2 != null) {
      // Navegar con la información de la categoría
      rootNavigatorKey.currentContext!.go(
        RoutesNames.productList,
        extra: {
          'id': event.idProduct,
          'title': event.title ?? 'Productos',
          'info': '',
          'type': 'category',
        },
      );

      emit(state.copyWith(
        product: result.$2,
        clearFilter: true,
        currentType: 'category',
        currentBrandId: null,
      ));
    } else {
      emit(state.copyWith(message: 'No se pudieron cargar los productos'));
    }
  }

  Future<void> _onFilterProduct(
    FilterProductEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    // Guardar los filtros disponibles actuales antes de filtrar
    final currentFilters = state.product?.availableFilters;

    // Determinar el ID correcto según el tipo (brand o category)
    final idToUse = state.currentType == 'brand'
        ? state.currentBrandId ?? event.idProduct
        : event.idProduct;

    final result = await _categoryRepository.getProductByFilter(
      idProduct: idToUse,
      filter: event.filter,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      if (result.$1?.httpCode == 401) {
        rootNavigatorKey.currentContext!
            .read<AppBloc>()
            .add(const OnClearSessionEvent());
        Future.delayed(const Duration(milliseconds: 500), () {
          rootNavigatorKey.currentContext!.go(RoutesNames.login);
        });
      }
      return;
    }

    if (result.$2 != null) {
      // Mantener los filtros disponibles originales
      final updatedProduct = result.$2!.copyWith(
        availableFilters: currentFilters ?? result.$2!.availableFilters,
      );
      emit(state.copyWith(
        product: updatedProduct,
        selectedFilter: event.filter,
      ));
    } else {
      emit(state.copyWith(message: 'No se pudieron filtrar los productos'));
    }
  }

  Future<void> _onClearFilter(
    ClearFilterEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    // Si es una marca, recargar productos de marca; si no, productos de categoría
    if (state.currentType == 'brand' && state.currentBrandId != null) {
      final result = await _brandRepository.getProductsByBrand(
        brandId: state.currentBrandId!,
        headers: appState.createHeaders(),
      );

      if (result.$1 != null) {
        emit(state.copyWith(message: result.$1!.message));
        if (result.$1?.httpCode == 401) {
          rootNavigatorKey.currentContext!
              .read<AppBloc>()
              .add(const OnClearSessionEvent());
          Future.delayed(const Duration(milliseconds: 500), () {
            rootNavigatorKey.currentContext!.go(RoutesNames.login);
          });
        }
        return;
      }

      if (result.$2 != null) {
        final productModel = ProductModel(
          success: null,
          total: result.$2!.products.length,
          allProduct: result.$2!.products.length,
          product: result.$2!.products,
          availableFilters: result.$2!.availableFilters,
        );
        emit(state.copyWith(product: productModel, clearFilter: true));
      } else {
        emit(state.copyWith(message: 'No se pudieron cargar los productos'));
      }
    } else {
      // Productos de categoría
      final result = await _categoryRepository.getProduct(
        idProduct: event.idProduct,
        headers: appState.createHeaders(),
      );

      if (result.$1 != null) {
        emit(state.copyWith(message: result.$1!.message));
        if (result.$1?.httpCode == 401) {
          rootNavigatorKey.currentContext!
              .read<AppBloc>()
              .add(const OnClearSessionEvent());
          Future.delayed(const Duration(milliseconds: 500), () {
            rootNavigatorKey.currentContext!.go(RoutesNames.login);
          });
        }
        return;
      }

      if (result.$2 != null) {
        emit(state.copyWith(product: result.$2, clearFilter: true));
      } else {
        emit(state.copyWith(message: 'No se pudieron cargar los productos'));
      }
    }
  }

  Future<void> _onLoadBrands(
    LoadBrandsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _brandRepository.getBrands(
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      if (result.$1?.httpCode == 401) {
        rootNavigatorKey.currentContext!
            .read<AppBloc>()
            .add(const OnClearSessionEvent());
        Future.delayed(const Duration(milliseconds: 500), () {
          rootNavigatorKey.currentContext!.go(RoutesNames.login);
        });
      }
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        brands: result.$2!.brands,
      ));
    } else {
      emit(state.copyWith(message: 'No se pudieron cargar las marcas'));
    }
  }

  Future<void> _onLoadProductsByBrand(
    LoadProductsByBrandEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _brandRepository.getProductsByBrand(
      brandId: event.brandId,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      if (result.$1?.httpCode == 401) {
        rootNavigatorKey.currentContext!
            .read<AppBloc>()
            .add(const OnClearSessionEvent());
        Future.delayed(const Duration(milliseconds: 500), () {
          rootNavigatorKey.currentContext!.go(RoutesNames.login);
        });
      }
      return;
    }

    if (result.$2 != null) {
      // Navegar con la información de la marca
      rootNavigatorKey.currentContext!.go(
        RoutesNames.productList,
        extra: {
          'id': event.brandId,
          'title': event.brandName,
          'info': '',
          'type': 'brand',
        },
      );

      // Convertir ProductModel desde BrandProductsModel
      final productModel = ProductModel(
        success: null,
        total: result.$2!.products.length,
        allProduct: result.$2!.products.length,
        product: result.$2!.products,
        availableFilters: result.$2!.availableFilters,
      );

      emit(state.copyWith(
        product: productModel,
        clearFilter: true,
        currentBrandId: event.brandId,
        currentType: 'brand',
      ));
    } else {
      emit(state.copyWith(
          message: 'No se pudieron cargar los productos de la marca'));
    }
  }
}
