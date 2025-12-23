import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

/// Tarjeta de producto mejorada con ganancias destacadas
class ImprovedProductCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final double salePrice;
  final double costPrice;
  final double commission;
  final double? wholesaleCommission;
  final bool isWholesale;
  final String? discount;
  final bool showDiscount;
  final VoidCallback? onTap;
  final Widget? actionButton;
  final Widget? catalogButton;

  const ImprovedProductCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.salePrice,
    required this.costPrice,
    required this.commission,
    this.wholesaleCommission,
    this.isWholesale = false,
    this.discount,
    this.showDiscount = true,
    this.onTap,
    this.actionButton,
    this.catalogButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profit = salePrice - costPrice;
    final profitPercentage = costPrice > 0 ? ((profit / costPrice) * 100) : 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: imageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          ),
                        )
                      : _buildPlaceholder(),
                ),
                // Botón de catálogo en la esquina superior derecha
                if (catalogButton != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: catalogButton!,
                    ),
                  ),
              ],
            ),

            // Información del producto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Marca: $subtitle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const Spacer(),

                    // Precios y ganancia
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Precio',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '\$${_formatNumber(salePrice.toInt())}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryMain,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: 14,
                                      color: Colors.green[700],
                                    ),
                                    Flexible(
                                      child: Text(
                                        isWholesale ? 'Ganancia' : 'Ganancia',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isWholesale) ...[
                                      const SizedBox(width: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: const Text(
                                          'x6+',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (isWholesale &&
                                  wholesaleCommission != null) ...[
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${_formatNumber(commission.toInt())}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        '\$${_formatNumber(wholesaleCommission!.toInt())}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else
                                Text(
                                  '\$${_formatNumber(commission.toInt())}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (actionButton != null) ...[
                      const SizedBox(height: 8),
                      actionButton!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: FaIcon(
        FontAwesomeIcons.boxOpen,
        color: AppColors.primaryMain.withOpacity(0.3),
        size: 48,
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
