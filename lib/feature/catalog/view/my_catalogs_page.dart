import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.primaryMain.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.bookOpen,
                size: 70,
                color: AppColors.primaryMain,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No tienes catálogos',
              style: APTextStyle.textXL.bold.copyWith(
                color: Colors.black87,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Crea tu primer catálogo personalizado\ny comparte tus productos favoritos',
              style: APTextStyle.textMD.medium.copyWith(
                color: AppColors.gray80,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String catalogId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono de advertencia
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red.shade600,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              // Título
              Text(
                '¿Eliminar Catálogo?',
                style: APTextStyle.textXL.bold.copyWith(
                  color: Colors.black87,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Descripción
              Text(
                'Esta acción eliminará permanentemente el catálogo y no se podrá recuperar.',
                style: APTextStyle.textMD.medium.copyWith(
                  color: AppColors.gray80,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: AppColors.gray50,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: APTextStyle.textMD.bold.copyWith(
                          color: AppColors.gray100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CatalogBloc>().add(
                              DeleteCatalog(catalogId: catalogId),
                            );
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Eliminar',
                        style: APTextStyle.textMD.bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gray50.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryMain,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.bookOpen,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            catalog.name ?? 'Sin nombre',
                            style: APTextStyle.textLG.bold.copyWith(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                          ),
                          if (catalog.description != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              catalog.description!,
                              style: APTextStyle.textSM.medium.copyWith(
                                color: AppColors.gray80,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.gray50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.ellipsisVertical,
                          color: AppColors.gray100,
                          size: 16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.pen, size: 16),
                              SizedBox(width: 12),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.trash,
                                  size: 16, color: Colors.red),
                              SizedBox(width: 12),
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
                Divider(
                  height: 1,
                  color: AppColors.gray50.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: FontAwesomeIcons.boxOpen,
                      label: 'producto',
                      color: AppColors.primaryMain,
                      backgroundColor: AppColors.primaryMain.withOpacity(0.1),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: isPublic
                          ? FontAwesomeIcons.globe
                          : FontAwesomeIcons.lock,
                      label: isPublic ? 'Público' : 'Privado',
                      color: isPublic
                          ? Colors.green.shade600
                          : Colors.orange.shade600,
                      backgroundColor: isPublic
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: APTextStyle.textXS.semibold.copyWith(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
