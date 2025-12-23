import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';

class AddProductToCatalogDialog extends StatefulWidget {
  final String catalogId;
  final Product? product;

  const AddProductToCatalogDialog({
    Key? key,
    required this.catalogId,
    this.product,
  }) : super(key: key);

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
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Agregar Producto',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Producto seleccionado
                    if (hasProduct) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (widget.product!.images?.isNotEmpty == true)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  widget.product!.images!.first,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product!.name ?? 'Producto',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Precio original: \$${widget.product!.pricing?.salePrice?.toStringAsFixed(0) ?? '0'}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
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
                        decoration: const InputDecoration(
                          labelText: 'ID del Producto *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.tag),
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
                    TextFormField(
                      controller: _customPriceController,
                      decoration: InputDecoration(
                        labelText: 'Precio personalizado *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.attach_money),
                        hintText: hasProduct
                            ? widget.product!.pricing?.salePrice?.toString() ??
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
                            price < (widget.product!.pricing?.salePrice ?? 0)) {
                          return 'El precio no puede ser menor al original';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Comisión
                    TextFormField(
                      controller: _commissionController,
                      decoration: const InputDecoration(
                        labelText: 'Comisión del vendedor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on),
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
                    const SizedBox(height: 16),

                    // Posición
                    TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        labelText: 'Posición',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.sort),
                        hintText: '1',
                        helperText: 'Orden en que aparece el producto',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Notas
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notas del vendedor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                        hintText: 'Promoción especial',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Etiquetas (separadas por comas)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label),
                        hintText: 'promo, oferta, destacado',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Switches
                    SwitchListTile(
                      title: const Text('Disponible'),
                      subtitle: const Text(
                          'El producto está disponible para la venta'),
                      value: _isAvailable,
                      onChanged: (value) =>
                          setState(() => _isAvailable = value),
                    ),
                    SwitchListTile(
                      title: const Text('Producto destacado'),
                      subtitle:
                          const Text('Aparecerá en una posición especial'),
                      value: _isFeatured,
                      onChanged: (value) => setState(() => _isFeatured = value),
                    ),
                    const SizedBox(height: 24),

                    // Botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _addProduct,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Agregar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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
