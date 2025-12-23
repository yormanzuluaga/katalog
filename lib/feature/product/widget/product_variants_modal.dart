import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ProductVariantsModal extends StatefulWidget {
  final Product product;
  final Function(Variant) onVariantSelected;

  const ProductVariantsModal({
    super.key,
    required this.product,
    required this.onVariantSelected,
  });

  @override
  State<ProductVariantsModal> createState() => _ProductVariantsModalState();
}

class _ProductVariantsModalState extends State<ProductVariantsModal> {
  Variant? selectedVariant;

  @override
  void initState() {
    super.initState();
    // Seleccionar la primera variante disponible por defecto
    if (widget.product.variants != null &&
        widget.product.variants!.isNotEmpty) {
      selectedVariant = widget.product.variants!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants ?? [];

    if (variants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No hay variantes disponibles',
              style: APTextStyle.textLG.semibold,
            ),
            const SizedBox(height: 16),
            AppButton.primary(
              title: 'Cerrar',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return _buildModalContent(context, variants, cartState);
      },
    );
  }

  Widget _buildModalContent(
      BuildContext context, List<Variant> variants, CartState cartState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whitePure,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selecciona opciones para:',
                  style: APTextStyle.textMD.medium.copyWith(
                    color: AppColors.black,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.black,
                    ))
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.product.name ?? 'Producto',
              style: APTextStyle.textLG.bold.copyWith(
                color: AppColors.primaryMain,
              ),
            ),
            const SizedBox(height: 20),

            // Lista de variantes
            ...variants.map((variant) => _buildVariantOption(variant)).toList(),

            const SizedBox(height: 24),

            // Botones - Mostrar contador si ya está en el carrito, sino botón agregar
            _buildActionButton(context, cartState),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, CartState cartState) {
    if (selectedVariant == null) {
      return AppButton.primary(
        title: 'Selecciona una opción',
        onPressed: null,
      );
    }

    // Generar el ID de la variante seleccionada
    final variantId =
        _generateVariantId(widget.product.id ?? '', selectedVariant!);

    // Buscar si este producto con variante específica está en el carrito
    final productInCart = cartState.listSale?.firstWhere(
      (cartProduct) => cartProduct.id == variantId,
      orElse: () => Product(),
    );

    final isProductInCart = productInCart?.id == variantId;
    final quantity = productInCart?.quantity ?? 1;

    if (isProductInCart) {
      return Column(
        children: [
          Text(
            'Este producto ya está en tu carrito',
            style: APTextStyle.textSM.medium.copyWith(
              color: AppColors.gray80,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          AppCounters.normal(
            key: ValueKey('counter_modal_$variantId'),
            initialValue: quantity,
            onDelete: () {
              context.read<CartBloc>().add(
                    DeletedCartEvent(id: variantId),
                  );
              Navigator.of(context).pop();
            },
            onChange: (value) {
              context.read<CartBloc>().add(
                    CountCartEvent(
                      id: variantId,
                      quantity: value,
                    ),
                  );
            },
          ),
        ],
      );
    }

    return AppButton.primary(
      title: 'Agregar al carrito',
      onPressed: () => widget.onVariantSelected(selectedVariant!),
    );
  }

  String _generateVariantId(String baseId, Variant variant) {
    final List<String> parts = [baseId];

    if (variant.color?.name != null) {
      parts.add(
          'color_${variant.color!.name!.toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.size != null) {
      parts.add(
          'size_${variant.size.toString().toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.sku != null) {
      parts.add('sku_${variant.sku!.toLowerCase().replaceAll(' ', '_')}');
    }

    return parts.join('_');
  }

  Widget _buildVariantOption(Variant variant) {
    final isSelected = selectedVariant?.id == variant.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVariant = variant;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.transparent : AppColors.whitePure,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.gray50,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Indicador de selección
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.secondary : AppColors.whitePure,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.gray100,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: AppColors.whitePure,
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Información de la variante
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color si está disponible
                  if (variant.color != null)
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _getColorFromString(variant.color?.name),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.gray100,
                              width: 1,
                            ),
                          ),
                          child: _getColorFromString(variant.color?.name) ==
                                  Colors.white
                              ? Icon(
                                  Icons.circle_outlined,
                                  size: 12,
                                  color: AppColors.gray100,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            variant.color?.name ?? 'Color',
                            style: APTextStyle.textSM.medium.copyWith(
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  // Tamaño si está disponible
                  if (variant.size != null)
                    Text(
                      'Tamaño: ${variant.size}',
                      style: APTextStyle.textSM.medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                  // SKU si está disponible
                  if (variant.sku != null)
                    Text(
                      'SKU: ${variant.sku}',
                      style: APTextStyle.textXS.regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                ],
              ),
            ),

            // Precio
            Text(
              '\$${variant.pricing?.salePrice ?? widget.product.pricing?.salePrice ?? 0}',
              style: APTextStyle.textMD.bold.copyWith(
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromString(String? colorName) {
    // Retornar color por defecto si es null o vacío
    if (colorName == null || colorName.trim().isEmpty) {
      return AppColors.gray100;
    }

    try {
      final cleanColorName = colorName.toLowerCase().trim();

      // Si es un color hexadecimal
      if (cleanColorName.startsWith('#')) {
        return Color(
            int.parse(cleanColorName.substring(1), radix: 16) + 0xFF000000);
      }

      // Si es rgb o rgba, intentar parsearlo
      if (cleanColorName.startsWith('rgb')) {
        // Esto es más complejo, por ahora usar color por defecto
        return AppColors.gray100;
      }

      // Mapeo de colores por nombre
      switch (cleanColorName) {
        // Rojos
        case 'rojo':
        case 'red':
        case 'colorado':
        case 'bermejo':
          return Colors.red;

        // Azules
        case 'azul':
        case 'blue':
        case 'celeste':
        case 'añil':
        case 'marino':
        case 'navy':
          return Colors.blue;

        // Verdes
        case 'verde':
        case 'green':
        case 'esmeralda':
        case 'lime':
        case 'oliva':
          return Colors.green;

        // Amarillos
        case 'amarillo':
        case 'yellow':
        case 'dorado':
        case 'oro':
        case 'gold':
          return Colors.yellow;

        // Negros y grises
        case 'negro':
        case 'black':
          return Colors.black;
        case 'gris':
        case 'gray':
        case 'grey':
        case 'plata':
        case 'silver':
          return Colors.grey;

        // Blancos
        case 'blanco':
        case 'white':
        case 'crema':
        case 'marfil':
          return Colors.white;

        // Morados/Violetas
        case 'morado':
        case 'purple':
        case 'violeta':
        case 'violet':
        case 'lila':
          return Colors.purple;

        // Naranjas
        case 'naranja':
        case 'orange':
        case 'anaranjado':
          return Colors.orange;

        // Rosas
        case 'rosa':
        case 'pink':
        case 'rosado':
          return Colors.pink;

        // Marrones
        case 'marrón':
        case 'marron':
        case 'brown':
        case 'café':
        case 'castaño':
          return Colors.brown;

        // Colores adicionales
        case 'beige':
        case 'caqui':
          return const Color(0xFFF5F5DC);
        case 'turquesa':
        case 'cyan':
          return Colors.cyan;

        default:
          // Si no encontramos el color, usar gris por defecto
          print(
              '⚠️ Color no reconocido: "$colorName", usando color por defecto');
          return AppColors.gray100;
      }
    } catch (e) {
      // Si hay cualquier error al procesar el color, usar el por defecto
      return AppColors.gray100;
    }
  }
}
