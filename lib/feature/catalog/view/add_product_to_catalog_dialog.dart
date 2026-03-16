import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AddProductToCatalogDialog extends StatefulWidget {
  final String catalogId;
  final Product? product;

  const AddProductToCatalogDialog({
    super.key,
    required this.catalogId,
    this.product,
  });

  @override
  State<AddProductToCatalogDialog> createState() =>
      _AddProductToCatalogDialogState();
}

class _AddProductToCatalogDialogState extends State<AddProductToCatalogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _customPriceController = TextEditingController();
  final _commissionController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _positionController = TextEditingController(text: '1');

  bool _isAvailable = true;
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productIdController.text = widget.product!.id ?? '';
      final price = widget.product!.pricing?.salePrice ?? 0;
      _customPriceController.text = price.toString();
      _commissionController.text = '0';
    }
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _customPriceController.dispose();
    _commissionController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasProduct = widget.product != null;

    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.message != null &&
            state.message!.contains('exitosamente') &&
            !state.isLoading) {
          Navigator.pop(context);
        }
        setState(() {
          _isLoading = state.isLoading;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.whiteTechnical,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                color: AppColors.whiteTechnical,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Agregar Producto',
                      style: APTextStyle.textXL.bold,
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

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Producto seleccionado
                      if (hasProduct) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.whitePure,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.secondary.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (widget.product!.images?.isNotEmpty == true)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    widget.product!.images!.first,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product!.name ?? 'Producto',
                                      style: APTextStyle.textMD.bold,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Precio original: \$${widget.product!.pricing?.salePrice?.toStringAsFixed(0) ?? '0'}',
                                      style:
                                          APTextStyle.textSM.regular.copyWith(
                                        color: AppColors.gray100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        TextFormField(
                          controller: _productIdController,
                          decoration: InputDecoration(
                            labelText: 'ID del Producto *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: AppColors.whitePure,
                            filled: true,
                            prefixIcon: const Icon(Icons.tag),
                            hintText: '691a1b1c2853a326a14b2b5b',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El ID del producto es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Precio personalizado
                      Text(
                        'Configuración de Precio',
                        style: APTextStyle.textMD.bold,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customPriceController,
                        decoration: InputDecoration(
                          labelText: 'Precio personalizado *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.attach_money),
                          hintText: hasProduct
                              ? widget.product!.pricing?.salePrice
                                      ?.toString() ??
                                  '0'
                              : '24000',
                          helperText: hasProduct
                              ? 'Mínimo: \$${widget.product!.pricing?.salePrice?.toStringAsFixed(0) ?? '0'}'
                              : 'Debe ser igual o mayor al precio original',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El precio es requerido';
                          }
                          final price = double.tryParse(value);
                          if (price == null) {
                            return 'Ingrese un precio válido';
                          }
                          if (hasProduct &&
                              price <
                                  (widget.product!.pricing?.salePrice ?? 0)) {
                            return 'El precio no puede ser menor al original';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Comisión
                      TextFormField(
                        controller: _commissionController,
                        decoration: InputDecoration(
                          labelText: 'Comisión del vendedor',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.monetization_on),
                          hintText: '6000',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final commission = double.tryParse(value);
                            if (commission == null) {
                              return 'Ingrese una comisión válida';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Información adicional
                      Text(
                        'Información Adicional',
                        style: APTextStyle.textMD.bold,
                      ),
                      const SizedBox(height: 12),

                      // Posición
                      TextFormField(
                        controller: _positionController,
                        decoration: InputDecoration(
                          labelText: 'Posición',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.sort),
                          hintText: '1',
                          helperText: 'Orden en que aparece el producto',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Notas
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notas del vendedor',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.note),
                          hintText: 'Promoción especial',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Tags
                      TextFormField(
                        controller: _tagsController,
                        decoration: InputDecoration(
                          labelText: 'Etiquetas (separadas por comas)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.label),
                          hintText: 'promo, oferta, destacado',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Opciones
                      Text(
                        'Opciones',
                        style: APTextStyle.textMD.bold,
                      ),
                      const SizedBox(height: 8),

                      // Switches con diseño mejorado
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.whitePure,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                'Disponible',
                                style: APTextStyle.textMD.semibold,
                              ),
                              subtitle: Text(
                                'El producto está disponible para la venta',
                                style: APTextStyle.textSM.regular.copyWith(
                                  color: AppColors.gray100,
                                ),
                              ),
                              value: _isAvailable,
                              activeColor: AppColors.secondary,
                              onChanged: (value) =>
                                  setState(() => _isAvailable = value),
                            ),
                            const Divider(height: 1),
                            SwitchListTile(
                              title: Text(
                                'Producto destacado',
                                style: APTextStyle.textMD.semibold,
                              ),
                              subtitle: Text(
                                'Aparecerá en una posición especial',
                                style: APTextStyle.textSM.regular.copyWith(
                                  color: AppColors.gray100,
                                ),
                              ),
                              value: _isFeatured,
                              activeColor: AppColors.secondary,
                              onChanged: (value) =>
                                  setState(() => _isFeatured = value),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Footer con botón
            SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.whitePure,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: MaterialButton(
                  onPressed: _isLoading ? null : _addProduct,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: AppColors.secondary,
                  disabledColor: AppColors.secondary.withOpacity(0.5),
                  height: 48.0,
                  elevation: 0,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Agregar Producto',
                          style: APTextStyle.textMD.bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final request = AddProductsRequest(
      products: [
        CatalogProduct(
          productId: _productIdController.text.trim(),
          customPrice: double.parse(_customPriceController.text.trim()),
          sellerCommission: _commissionController.text.isEmpty
              ? null
              : double.parse(_commissionController.text.trim()),
          isAvailable: _isAvailable,
          position: int.tryParse(_positionController.text.trim()) ?? 1,
          sellerNotes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          customTags: tags.isEmpty ? null : tags,
          isFeatured: _isFeatured,
        ),
      ],
    );

    context.read<CatalogBloc>().add(
          AddProductsToCatalog(
            catalogId: widget.catalogId,
            request: request,
          ),
        );
  }
}
