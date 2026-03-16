import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

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
                              onPressed: () => _showShareDialog(
                                context,
                                catalog.id ?? '',
                                catalog.name ?? 'Mi Catálogo',
                                catalog.description ?? '',
                                products.length,
                              ),
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryMain.withOpacity(0.1),
                              AppColors.primaryMain.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryMain.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryMain,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.boxOpen,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Productos en este catálogo',
                                    style: APTextStyle.textSM.medium.copyWith(
                                      color: AppColors.gray80,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${products.length} producto${products.length != 1 ? 's' : ''} agregado${products.length != 1 ? 's' : ''}',
                                    style: APTextStyle.textXL.bold.copyWith(
                                      color: AppColors.primaryMain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gray50.withOpacity(0.3),
              ),
              child: const FaIcon(
                FontAwesomeIcons.boxOpen,
                size: 64,
                color: AppColors.gray80,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay productos aún',
              style: APTextStyle.textLG.bold.copyWith(
                color: AppColors.gray100,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega productos desde el catálogo principal',
              style: APTextStyle.textMD.medium.copyWith(
                color: AppColors.gray80,
              ),
              textAlign: TextAlign.center,
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

  void _showShareDialog(
    BuildContext context,
    String catalogId,
    String catalogName,
    String catalogDescription,
    int productsCount,
  ) {
    final catalogUrl = 'katalog://catalogo/$catalogId';
    final shareText = '''🛍️ $catalogName

$catalogDescription

$productsCount productos disponibles

Abre el catálogo: $catalogUrl''';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.share,
                      color: AppColors.primaryMain,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Compartir catálogo',
                    style: APTextStyle.textLG.bold.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gray50.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gray50,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enlace del catálogo:',
                                style: APTextStyle.textSM.semibold.copyWith(
                                  color: AppColors.gray100,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                catalogUrl,
                                style: APTextStyle.textSM.medium.copyWith(
                                  color: AppColors.primaryMain,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: catalogUrl),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Enlace copiado'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.copy,
                            size: 18,
                          ),
                          tooltip: 'Copiar enlace',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Compartir en:',
                style: APTextStyle.textMD.semibold.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ShareButton(
                    icon: FontAwesomeIcons.link,
                    label: 'Copiar',
                    color: AppColors.primaryMain,
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: catalogUrl),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text('Enlace copiado al portapapeles'),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.whatsapp,
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: () => _shareToWhatsApp(shareText),
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.facebookF,
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: () => _shareToFacebook(catalogUrl),
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.instagram,
                    label: 'Instagram',
                    color: const Color(0xFFE4405F),
                    onTap: () => _shareToInstagram(shareText),
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.tiktok,
                    label: 'TikTok',
                    color: const Color(0xFF000000),
                    onTap: () => _shareToTikTok(shareText),
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.xTwitter,
                    label: 'X',
                    color: const Color(0xFF000000),
                    onTap: () => _shareToTwitter(shareText),
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.telegram,
                    label: 'Telegram',
                    color: const Color(0xFF0088CC),
                    onTap: () => _shareToTelegram(shareText),
                  ),
                  _ShareButton(
                    icon: FontAwesomeIcons.ellipsis,
                    label: 'Más',
                    color: AppColors.gray80,
                    onTap: () => _shareGeneric(shareText),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareToWhatsApp(String text) async {
    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareToFacebook(String url) async {
    final fbUrl = Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}');
    if (await canLaunchUrl(fbUrl)) {
      await launchUrl(fbUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareToTwitter(String text) async {
    final url = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareToTelegram(String text) async {
    final url =
        Uri.parse('https://t.me/share/url?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareToInstagram(String text) async {
    // Instagram no permite compartir texto directamente
    // Copiar al portapapeles y abrir Instagram
    await Clipboard.setData(ClipboardData(text: text));

    final url = Uri.parse('instagram://app');
    try {
      final canLaunch = await canLaunchUrl(url);
      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Texto copiado. Pégalo en Instagram',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFE4405F),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        // Si no está instalada, abrir en navegador
        final webUrl = Uri.parse('https://www.instagram.com/');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Texto copiado al portapapeles'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Texto copiado al portapapeles'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _shareToTikTok(String text) async {
    // TikTok no permite compartir texto directamente
    // Copiar al portapapeles y abrir TikTok
    await Clipboard.setData(ClipboardData(text: text));

    // Intentar diferentes esquemas de URL para TikTok
    final urls = [
      Uri.parse('snssdk1233://'),
      Uri.parse('tiktok://'),
    ];

    bool opened = false;
    for (var url in urls) {
      try {
        final canLaunch = await canLaunchUrl(url);
        if (canLaunch) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          opened = true;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tiktok,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Texto copiado. Pégalo en TikTok',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!opened) {
      // Si no está instalada, abrir en navegador
      try {
        final webUrl = Uri.parse('https://www.tiktok.com/');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Ignorar error
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Texto copiado al portapapeles'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _shareGeneric(String text) async {
    // Copiar al portapapeles como fallback
    await Clipboard.setData(ClipboardData(text: text));
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryMain.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.gray50.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: productData?.images?.isNotEmpty == true &&
                            productData!.images!.first.isNotEmpty
                        ? Image.network(
                            productData.images!.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.gray50.withOpacity(0.3),
                                child: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: AppColors.gray80,
                                  size: 24,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          )
                        : const FaIcon(
                            FontAwesomeIcons.image,
                            color: AppColors.gray80,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              productData?.name ?? 'Producto',
                              style: APTextStyle.textMD.semibold.copyWith(
                                color: AppColors.primaryMain,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isFeatured)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.amber,
                                    Colors.orange,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.star,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Destacado',
                                    style: APTextStyle.textXS.bold.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (showPrices && product.customPrice != null)
                        Text(
                          '\$${addDotsToNumber(product.customPrice!.toInt())}',
                          style: APTextStyle.textLG.bold.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      if (product.sellerNotes != null &&
                          product.sellerNotes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          product.sellerNotes!,
                          style: APTextStyle.textSM.medium.copyWith(
                            color: AppColors.gray80,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                    size: 18,
                  ),
                  onPressed: () =>
                      _confirmDelete(context, product.productId ?? ''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
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
                '¿Eliminar Producto?',
                style: APTextStyle.textXL.bold.copyWith(
                  color: Colors.black87,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Descripción
              Text(
                'Este producto será removido del catálogo. Esta acción no se puede deshacer.',
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
                              DeleteProductFromCatalog(
                                catalogId: catalogId,
                                productId: productId,
                              ),
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

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: APTextStyle.textXS.medium.copyWith(
              color: Colors.black87,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
