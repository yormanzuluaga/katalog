// ignore_for_file: must_be_immutable

part of 'catalog_bloc.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.catalogs,
    this.currentCatalog,
    this.message,
    this.isLoading = false,
  });

  final List<CatalogItem>? catalogs;
  final CatalogItem? currentCatalog;
  final String? message;
  final bool isLoading;

  CatalogState copyWith({
    List<CatalogItem>? catalogs,
    CatalogItem? currentCatalog,
    String? message,
    bool? isLoading,
  }) {
    return CatalogState(
      catalogs: catalogs ?? this.catalogs,
      currentCatalog: currentCatalog ?? this.currentCatalog,
      message: message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        catalogs,
        currentCatalog,
        message,
        isLoading,
      ];
}
