import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

/// Tarjeta mejorada para items del carrito con mejor visualización
class ImprovedCartItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? variantInfo;
  final String? imageUrl;
  final double price;
  final double costPrice;
  final double? wholesaleCostPrice;
  final bool isWholesale;
  final int quantity;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const ImprovedCartItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.variantInfo,
    this.imageUrl,
    required this.price,
    required this.costPrice,
    this.wholesaleCostPrice,
    this.isWholesale = false,
    required this.quantity,
    required this.onRemove,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Contenido principal
          IntrinsicHeight(
            child: Row(
              children: [
                // Imagen
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: imageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          ),
                        )
                      : _buildPlaceholder(),
                ),

                // Información del producto
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título y botón eliminar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (subtitle != null &&
                                      subtitle!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      subtitle!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                  if (variantInfo != null &&
                                      variantInfo!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        variantInfo!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.primaryMain,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: onRemove,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Precio y controles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Precio unitario
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Precio unitario',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '\$${_formatNumber(price.toInt())}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryMain,
                                  ),
                                ),
                              ],
                            ),

                            // Controles de cantidad
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryMain.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: quantity > 1
                                        ? () => onQuantityChanged(quantity - 1)
                                        : null,
                                    icon: const Icon(Icons.remove, size: 18),
                                    color: AppColors.primaryMain,
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryMain,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        onQuantityChanged(quantity + 1),
                                    icon: const Icon(Icons.add, size: 18),
                                    color: AppColors.primaryMain,
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Barra inferior con total y ganancia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ganancia
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isWholesale ? 'Ganancia por mayor:' : 'Ganancia:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (isWholesale && wholesaleCostPrice != null) ...[
                      Text(
                        '\$${_formatNumber(costPrice.toInt())}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${_formatNumber(wholesaleCostPrice!.toInt())}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ] else
                      Text(
                        '\$${_formatNumber(costPrice.toInt())}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                  ],
                ),
                // Total
                Row(
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '\$${_formatNumber(totalPrice.toInt())}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryMain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: FaIcon(
        FontAwesomeIcons.boxOpen,
        color: AppColors.primaryMain.withOpacity(0.3),
        size: 32,
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
