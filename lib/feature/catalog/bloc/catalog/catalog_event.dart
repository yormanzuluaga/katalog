part of 'catalog_bloc.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class CreateCatalog extends CatalogEvent {
  const CreateCatalog({
    required this.request,
  });

  final CreateCatalogRequest request;

  @override
  List<Object?> get props => [request];
}

class LoadMyCatalogs extends CatalogEvent {
  const LoadMyCatalogs();
}

class LoadCatalogById extends CatalogEvent {
  const LoadCatalogById({
    required this.catalogId,
  });

  final String catalogId;

  @override
  List<Object?> get props => [catalogId];
}

class AddProductsToCatalog extends CatalogEvent {
  const AddProductsToCatalog({
    required this.catalogId,
    required this.request,
  });

  final String catalogId;
  final AddProductsRequest request;

  @override
  List<Object?> get props => [catalogId, request];
}

class DeleteProductFromCatalog extends CatalogEvent {
  const DeleteProductFromCatalog({
    required this.catalogId,
    required this.productId,
  });

  final String catalogId;
  final String productId;

  @override
  List<Object?> get props => [catalogId, productId];
}

class DeleteCatalog extends CatalogEvent {
  const DeleteCatalog({
    required this.catalogId,
  });

  final String catalogId;

  @override
  List<Object?> get props => [catalogId];
}
