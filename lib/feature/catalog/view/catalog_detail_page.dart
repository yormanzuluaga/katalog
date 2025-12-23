import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_test/feature/catalog/view/add_product_to_catalog_dialog.dart';

class CatalogDetailPage extends StatefulWidget {
  final String catalogId;

  const CatalogDetailPage({
    Key? key,
    required this.catalogId,
  }) : super(key: key);

  @override
  State<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<CatalogBloc>()
        .add(LoadCatalogById(catalogId: widget.catalogId));
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

          // Recargar después de eliminar producto
          if (state.message!.contains('eliminado')) {
            context.read<CatalogBloc>().add(
                  LoadCatalogById(catalogId: widget.catalogId),
                );
          }
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.currentCatalog == null) {
          return const Center(child: Text('No se pudo cargar el catálogo'));
        }

        final catalog = state.currentCatalog!;
        final products = catalog.products ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            context.read<CatalogBloc>().add(
                  LoadCatalogById(catalogId: widget.catalogId),
                );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del catálogo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _parseColor(
                            catalog.settings?.theme?.primaryColor ?? '#FF69B4'),
                        _parseColor(catalog.settings?.theme?.secondaryColor ??
                            '#8B008B'),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catalog.name ?? 'Sin nombre',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (catalog.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          catalog.description!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.inventory_2,
                            label: '${products.length} productos',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            icon: catalog.settings?.isPublic == true
                                ? Icons.public
                                : Icons.lock,
                            label: catalog.settings?.isPublic == true
                                ? 'Público'
                                : 'Privado',
                          ),
                          const Spacer(),
                          if (catalog.settings?.isPublic == true)
                            IconButton(
                              onPressed: () {
                                // URL para compartir (puedes usar https://tudominio.com o katalog://catalogo)
                                final catalogUrl =
                                    'katalog://catalogo/${catalog.id}';
                                final text = '''
🛍️ ${catalog.name}

${catalog.description ?? ''}

${products.length} productos disponibles

Abre el catálogo: $catalogUrl
                                '''
                                    .trim();

                                // Mostrar diálogo con el enlace
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Compartir Catálogo'),
                                    content: SelectableText(text),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon:
                                  const Icon(Icons.share, color: Colors.white),
                              tooltip: 'Compartir catálogo',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Información de contacto
                if (catalog.settings?.contactInfo != null)
                  _buildContactSection(catalog.settings!.contactInfo!),

                // Lista de productos
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Productos (${products.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (products.isEmpty)
                        _buildEmptyProducts()
                      else
                        ...products.map(
                          (product) => _ProductCard(
                            product: product,
                            catalogId: widget.catalogId,
                            showPrices: catalog.settings?.showPrices ?? true,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ContactInfo contactInfo) {
    final hasContact = contactInfo.phone != null ||
        contactInfo.email != null ||
        contactInfo.whatsapp != null;

    if (!hasContact) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Contacto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (contactInfo.phone != null)
            _buildContactItem(Icons.phone, contactInfo.phone!),
          if (contactInfo.email != null)
            _buildContactItem(Icons.email, contactInfo.email!),
          if (contactInfo.whatsapp != null)
            _buildContactItem(FontAwesomeIcons.whatsapp, contactInfo.whatsapp!),
          if (contactInfo.socialMedia?.instagram != null)
            _buildContactItem(FontAwesomeIcons.instagram,
                contactInfo.socialMedia!.instagram!),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay productos en este catálogo',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.pink;
    }
  }
}

class _ProductCard extends StatelessWidget {
  final CatalogProduct product;
  final String catalogId;
  final bool showPrices;

  const _ProductCard({
    Key? key,
    required this.product,
    required this.catalogId,
    required this.showPrices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = product.product;
    final isFeatured = product.isFeatured ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            image: productData?.images?.isNotEmpty == true
                ? DecorationImage(
                    image: NetworkImage(productData!.images!.first),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: productData?.images?.isEmpty ?? true
              ? const Icon(Icons.image, color: Colors.grey)
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                productData?.name ?? 'Producto',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isFeatured)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.white),
                    SizedBox(width: 2),
                    Text(
                      'Destacado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showPrices && product.customPrice != null)
              Text(
                '\$${product.customPrice!.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            if (product.sellerNotes != null && product.sellerNotes!.isNotEmpty)
              Text(
                product.sellerNotes!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(context, product.productId ?? ''),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este producto del catálogo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<CatalogBloc>().add(
                    DeleteProductFromCatalog(
                      catalogId: catalogId,
                      productId: productId,
                    ),
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
