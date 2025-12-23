import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_test/feature/catalog/view/add_product_to_catalog_dialog.dart';
import 'package:talentpitch_test/feature/catalog/view/create_catalog_dialog.dart';

class CatalogSelectorDialog extends StatelessWidget {
  final Product product;

  const CatalogSelectorDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Seleccionar Catálogo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.catalogs == null || state.catalogs!.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.catalogs!.length,
                    itemBuilder: (context, index) {
                      final catalog = state.catalogs![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            catalog.settings?.isPublic == true
                                ? Icons.public
                                : Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(catalog.name ?? 'Sin nombre'),
                        subtitle: Text(
                          '${catalog.products?.length ?? 0} productos',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          _showAddProductDialog(context, catalog.id!);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCreateCatalogDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Nuevo Catálogo'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No tienes catálogos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea tu primer catálogo para comenzar',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showCreateCatalogDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Crear Catálogo'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, String catalogId) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CatalogBloc>(),
        child: AddProductToCatalogDialog(
          catalogId: catalogId,
          product: product,
        ),
      ),
    );
  }

  void _showCreateCatalogDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CatalogBloc>(),
        child: const CreateCatalogDialog(),
      ),
    );
  }
}
