import 'package:api_helper/api_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Detail extends StatefulWidget {
  const Detail({
    super.key,
    this.id,
    this.title,
    this.email,
    this.phone,
    this.description,
    this.price,
    this.image,
    this.brand,
    this.model,
    this.available = true,
    required this.product, // Agregar el producto completo
  });

  final String? title;
  final String? id;
  final String? email;
  final String? phone;
  final String? description;
  final String? price;
  final String? image;
  final String? brand;
  final String? model;
  final bool available;
  final Product product; // Nuevo parámetro

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Variant? selectedVariant;

  @override
  void initState() {
    super.initState();
    // Seleccionar la primera variante disponible si el producto tiene variantes
    if (widget.product.variants != null && widget.product.variants!.isNotEmpty) {
      selectedVariant = widget.product.variants!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasVariants = widget.product.variants != null &&
        widget.product.variants!.isNotEmpty &&
        widget.product.productType != 'simple';

    return Scaffold(
      backgroundColor: AppColors.whiteTechnical,
      appBar: AppBar(
        backgroundColor: AppColors.whitePure,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryMain,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Detalle del Producto',
          style: UITextStyle.titles.title2Medium.copyWith(
            color: AppColors.primaryMain,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Acción para favoritos
            },
            icon: const FaIcon(
              FontAwesomeIcons.heart,
              color: AppColors.primaryMain,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              // Acción para compartir
            },
            icon: const FaIcon(
              FontAwesomeIcons.shareAlt,
              color: AppColors.primaryMain,
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              height: 300,
              width: double.infinity,
              color: AppColors.whitePure,
              child: widget.image != null && widget.image!.isNotEmpty
                  ? Image.network(
                      widget.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: FaIcon(
                            FontAwesomeIcons.image,
                            color: AppColors.gray100,
                            size: 80,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: FaIcon(
                        FontAwesomeIcons.image,
                        color: AppColors.gray100,
                        size: 80,
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado de disponibilidad
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: widget.available ? AppColors.secondary[300]!.withOpacity(0.2) : AppColors.redyMain[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.available ? 'Disponible' : 'No disponible',
                      style: APTextStyle.textSM.medium.copyWith(
                        color: widget.available ? AppColors.primaryMain : AppColors.redyMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Título del producto
                  Text(
                    widget.product.name ?? '',
                    style: UITextStyle.titles.title1Medium.copyWith(
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Marca y modelo
                  if (widget.product.brand != null || widget.product.model != null) ...[
                    Row(
                      children: [
                        if (widget.product.brand != null) ...[
                          const FaIcon(
                            FontAwesomeIcons.tag,
                            color: AppColors.primaryMain,
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            widget.product.brand!.name!,
                            style: APTextStyle.textMD.semibold.copyWith(
                              color: AppColors.primaryMain,
                            ),
                          ),
                        ],
                        if (widget.product.brand != null && widget.product.model != null)
                          const Text(' • ', style: TextStyle(color: AppColors.gray100)),
                        if (widget.product.model != null) ...[
                          Text(
                            'Modelo: ${widget.product.model}',
                            style: APTextStyle.textSM.regular.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Precio
                  if (widget.product.pricing?.salePrice != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.secondary[300]!.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryMain.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.dollarSign,
                            color: AppColors.primaryMain,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            widget.product.pricing?.salePrice.toString() ?? '',
                            style: UITextStyle.titles.title2Medium.copyWith(
                              color: AppColors.secondaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Información de contacto
                  // Container(
                  //   padding: const EdgeInsets.all(AppSpacing.md),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.whitePure,
                  //     borderRadius: BorderRadius.circular(12),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: AppColors.gray50.withOpacity(0.5),
                  //         blurRadius: 8,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Información de Contacto',
                  //         style: UITextStyle.titles.title3Medium.copyWith(
                  //           color: AppColors.secondaryDark,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       const SizedBox(height: AppSpacing.md),

                  //       // Email
                  //       Row(
                  //         children: [
                  //           const FaIcon(
                  //             FontAwesomeIcons.envelope,
                  //             color: AppColors.primaryMain,
                  //             size: 16,
                  //           ),
                  //           const SizedBox(width: AppSpacing.sm),
                  //           Expanded(
                  //             child: Text(
                  //               widget.product.details?.included?.first ?? '',
                  //               style: UITextStyle.paragraphs.paragraph1Regular.copyWith(
                  //                 color: AppColors.gray100,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),

                  //       const SizedBox(height: AppSpacing.sm),

                  //       // Teléfono
                  //       Row(
                  //         children: [
                  //           const FaIcon(
                  //             FontAwesomeIcons.phone,
                  //             color: AppColors.primaryMain,
                  //             size: 16,
                  //           ),
                  //           const SizedBox(width: AppSpacing.sm),
                  //           Expanded(
                  //             child: Text(
                  //               widget.phone ?? '',
                  //               style: UITextStyle.paragraphs.paragraph1Regular.copyWith(
                  //                 color: AppColors.gray100,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Descripción
                  if (widget.product.description != null && widget.product.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.whitePure,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gray50.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descripción',
                            style: UITextStyle.titles.title3Medium.copyWith(
                              color: AppColors.secondaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            widget.product.description ?? '',
                            style: UITextStyle.paragraphs.paragraph1Regular.copyWith(
                              color: AppColors.black,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  // Sección de variantes (solo si el producto las tiene)
                  if (hasVariants) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.whitePure,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gray50.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Opciones del Producto',
                            style: UITextStyle.titles.title3Medium.copyWith(
                              color: AppColors.secondaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Cada color/tamaño se agrega como producto separado al carrito',
                            style: APTextStyle.textSM.regular.copyWith(
                              color: AppColors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Lista de variantes
                          ...widget.product.variants!.map((variant) => _buildVariantOption(variant)).toList(),

                          // Información de la variante seleccionada
                          if (selectedVariant != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.secondary[300]!.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryMain.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Variante seleccionada:',
                                    style: APTextStyle.textSM.medium.copyWith(
                                      color: AppColors.gray100,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Precio: \$${selectedVariant!.pricing?.salePrice ?? widget.product.pricing?.salePrice ?? widget.price ?? '0'}',
                                        style: APTextStyle.textMD.bold.copyWith(
                                          color: AppColors.primaryMain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Botones de acción
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      return Builder(builder: (context) {
                        // Determinar el ID del producto a verificar en el carrito
                        String productIdToCheck = widget.product.id ?? '';
                        if (selectedVariant != null) {
                          productIdToCheck = _generateVariantId(widget.product.id ?? '', selectedVariant!);
                        }

                        // Verificar si este producto específico (con esta variante) está en el carrito
                        final productInCart = state.listSale?.firstWhere(
                          (cartProduct) => cartProduct.id == productIdToCheck,
                          orElse: () => Product(),
                        );

                        final isProductInCart = productInCart?.id == productIdToCheck;
                        final quantity = productInCart?.quantity ?? 1;

                        return (isProductInCart)
                            ? SizedBox(
                                height: 50,
                                child: AppCounters.normal(
                                  key: ValueKey('counter_$productIdToCheck'),
                                  initialValue: quantity,
                                  onDelete: () {
                                    context.read<CartBloc>().add(
                                          DeletedCartEvent(id: productIdToCheck),
                                        );
                                  },
                                  onChange: (value) {
                                    context.read<CartBloc>().add(
                                          CountCartEvent(
                                            id: productIdToCheck,
                                            quantity: value,
                                          ),
                                        );
                                  },
                                ),
                              )
                            : AppButton.primary(
                                onPressed: () {
                                  _addToCart();
                                },
                                title: 'Agregar al Carrito',
                              );
                      });
                    },
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.transparent : AppColors.whiteTechnical,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryMain : AppColors.gray50,
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
                color: isSelected ? AppColors.primaryMain : AppColors.whitePure,
                border: Border.all(
                  color: isSelected ? AppColors.primaryMain : AppColors.gray100,
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
            const SizedBox(width: AppSpacing.sm),

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
                          child: _getColorFromString(variant.color?.name) == Colors.white
                              ? Icon(
                                  Icons.circle_outlined,
                                  size: 12,
                                  color: AppColors.gray100,
                                )
                              : null,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            variant.color?.name ?? 'Color',
                            style: APTextStyle.textSM.medium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  // Tamaño si está disponible
                  if (variant.size != null)
                    Text(
                      'Tamaño: ${variant.size}',
                      style: APTextStyle.textSM.medium,
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
              '\$${variant.pricing?.salePrice ?? widget.product.pricing?.salePrice ?? widget.price ?? '0'}',
              style: APTextStyle.textMD.bold.copyWith(
                color: AppColors.primaryMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    Product productToAdd = widget.product;

    // Si hay variantes y una está seleccionada, usar la variante
    if (selectedVariant != null) {
      // Generar un ID único que incluya la información de la variante
      final variantId = _generateVariantId(widget.product.id ?? '', selectedVariant!);

      productToAdd = widget.product.copyWith(
        id: variantId,
        pricing: selectedVariant!.pricing ?? widget.product.pricing,
        // Mantener la referencia a las variantes para comparaciones futuras
        variants: [selectedVariant!],
      );

      print('🛒 Detail: Agregando producto con variante - ID: $variantId');
      print('🎨 Detail: Color: ${selectedVariant!.color?.name}, Tamaño: ${selectedVariant!.size}');
    } else {
      print('🛒 Detail: Agregando producto simple - ID: ${productToAdd.id}');
    }

    // Agregar al carrito usando el bloc
    context.read<CartBloc>().add(
          AddCartEvent(
            productsSalesModel: productToAdd,
          ),
        );

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} agregado al carrito'),
        backgroundColor: AppColors.primaryMain,
        action: SnackBarAction(
          label: 'Ver carrito',
          textColor: AppColors.whitePure,
          onPressed: () {
            // Navegar al carrito
            context.go('/cart');
          },
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
        return Color(int.parse(cleanColorName.substring(1), radix: 16) + 0xFF000000);
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
          return AppColors.gray100;
      }
    } catch (e) {
      // Si hay cualquier error al procesar el color, usar el por defecto
      return AppColors.gray100;
    }
  }

  /// Genera un ID único para la variante del producto
  String _generateVariantId(String baseId, Variant variant) {
    final List<String> parts = [baseId];

    // Agregar características de la variante al ID
    if (variant.color?.name != null) {
      parts.add('color_${variant.color!.name!.toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.size != null) {
      parts.add('size_${variant.size.toString().toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.sku != null) {
      parts.add('sku_${variant.sku!.toLowerCase().replaceAll(' ', '_')}');
    }

    return parts.join('_');
  }
}
