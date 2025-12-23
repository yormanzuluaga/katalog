import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_test/feature/catalog/view/create_catalog_dialog.dart';
import 'package:talentpitch_test/feature/catalog/view/catalog_detail_page.dart';

class MyCatalogsPage extends StatefulWidget {
  const MyCatalogsPage({Key? key}) : super(key: key);

  @override
  State<MyCatalogsPage> createState() => _MyCatalogsPageState();
}

class _MyCatalogsPageState extends State<MyCatalogsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(const LoadMyCatalogs());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.message != null && !state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.message!.contains('exitosamente')
                  ? Colors.green
                  : Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.catalogs == null || state.catalogs!.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<CatalogBloc>().add(const LoadMyCatalogs());
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.catalogs!.length,
            itemBuilder: (context, index) {
              final catalog = state.catalogs![index];
              return _CatalogCard(
                catalog: catalog,
                onTap: () {
                  context
                      .read<CatalogBloc>()
                      .add(LoadCatalogById(catalogId: catalog.id!));
                  context.push(RoutesNames.catalogDetail, extra: catalog.id!);
                },
                onDelete: () => _confirmDelete(context, catalog.id!),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.bookOpen,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes catálogos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer catálogo personalizado',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
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

  void _confirmDelete(BuildContext context, String catalogId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Catálogo'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este catálogo? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<CatalogBloc>().add(
                    DeleteCatalog(catalogId: catalogId),
                  );
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final dynamic catalog;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CatalogCard({
    Key? key,
    required this.catalog,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsCount = catalog.products?.length ?? 0;
    final isPublic = catalog.settings?.isPublic ?? false;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          catalog.name ?? 'Sin nombre',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (catalog.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            catalog.description!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDelete();
                      } else if (value == 'edit') {
                        onTap();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.inventory_2,
                    label: '$productsCount productos',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: isPublic ? Icons.public : Icons.lock,
                    label: isPublic ? 'Público' : 'Privado',
                    color: isPublic ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
