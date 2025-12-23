import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_test/feature/catalog/view/catalog_selector_dialog.dart';

class AddToCatalogButton extends StatelessWidget {
  final Product product;

  const AddToCatalogButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.bookmark_border,
        size: 20,
      ),
      color: Colors.blue,
      tooltip: 'Agregar a catálogo',
      onPressed: () => _showCatalogSelector(context),
    );
  }

  void _showCatalogSelector(BuildContext context) {
    // Primero cargar los catálogos
    context.read<CatalogBloc>().add(const LoadMyCatalogs());

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CatalogBloc>(),
        child: CatalogSelectorDialog(product: product),
      ),
    );
  }
}
