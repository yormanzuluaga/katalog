import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/routes.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({
    required CatalogRepository catalogRepository,
  })  : _catalogRepository = catalogRepository,
        super(const CatalogState()) {
    on<CreateCatalog>(_onCreateCatalog);
    on<LoadMyCatalogs>(_onLoadMyCatalogs);
    on<LoadCatalogById>(_onLoadCatalogById);
    on<AddProductsToCatalog>(_onAddProductsToCatalog);
    on<DeleteProductFromCatalog>(_onDeleteProductFromCatalog);
    on<DeleteCatalog>(_onDeleteCatalog);
  }

  final CatalogRepository _catalogRepository;

  Future<void> _onCreateCatalog(
    CreateCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(message: null, isLoading: true));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _catalogRepository.createCatalog(
      request: event.request,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(
        message: result.$1!.message,
        isLoading: false,
      ));
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        currentCatalog: result.$2!.catalog,
        message: result.$2!.message ?? 'Catálogo creado exitosamente',
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        message: 'No se pudo crear el catálogo',
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadMyCatalogs(
    LoadMyCatalogs event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(message: null, isLoading: true));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _catalogRepository.getMyCatalogs(
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(
        message: result.$1!.message,
        isLoading: false,
      ));
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        catalogs: result.$2!.catalogs,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        message: 'No se pudieron cargar los catálogos',
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadCatalogById(
    LoadCatalogById event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(message: null, isLoading: true));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _catalogRepository.getCatalogById(
      catalogId: event.catalogId,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(
        message: result.$1!.message,
        isLoading: false,
      ));
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        currentCatalog: result.$2!.catalog,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        message: 'No se pudo cargar el catálogo',
        isLoading: false,
      ));
    }
  }

  Future<void> _onAddProductsToCatalog(
    AddProductsToCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(message: null, isLoading: true));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _catalogRepository.addProducts(
      catalogId: event.catalogId,
      request: event.request,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(
        message: result.$1!.message,
        isLoading: false,
      ));
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        currentCatalog: result.$2!.catalog,
        message: result.$2!.message ?? 'Productos agregados exitosamente',
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        message: 'No se pudieron agregar los productos',
        isLoading: false,
      ));
    }
  }

  Future<void> _onDeleteProductFromCatalog(
    DeleteProductFromCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(message: null, isLoading: true));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _catalogRepository.deleteProduct(
      catalogId: event.catalogId,
      productId: event.productId,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(
        message: result.$1!.message,
        isLoading: false,
      ));
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        currentCatalog: result.$2!.catalog,
        message: result.$2!.message ?? 'Producto eliminado exitosamente',
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        message: 'No se pudo eliminar el producto',
        isLoading: false,
      ));
    }
  }

  Future<void> _onDeleteCatalog(
    DeleteCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(message: null, isLoading: true));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _catalogRepository.deleteCatalog(
      catalogId: event.catalogId,
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(
        message: result.$1!.message,
        isLoading: false,
      ));
      return;
    }

    if (result.$2 != null) {
      // Remove the deleted catalog from the list
      final updatedCatalogs = state.catalogs
          ?.where((catalog) => catalog.id != event.catalogId)
          .toList();

      emit(state.copyWith(
        catalogs: updatedCatalogs,
        currentCatalog: null,
        message: result.$2!.message ?? 'Catálogo eliminado exitosamente',
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        message: 'No se pudo eliminar el catálogo',
        isLoading: false,
      ));
    }
  }
}
