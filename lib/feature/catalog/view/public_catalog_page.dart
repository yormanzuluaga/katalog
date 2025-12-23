import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class PublicCatalogPage extends StatelessWidget {
  const PublicCatalogPage({
    Key? key,
    required this.catalogId,
  }) : super(key: key);

  final String catalogId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront,
              size: 80,
              color: AppColors.primaryMain,
            ),
            const SizedBox(height: 24),
            Text(
              'Catálogo Público',
              style: APTextStyle.textXL.bold.copyWith(
                color: AppColors.primaryMain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ID del catálogo: $catalogId',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¡Funcionalidad de Deep Link configurada!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Este catálogo se abrirá automáticamente cuando alguien use el enlace compartido.',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aquí se mostrará la lista completa de productos del catálogo.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
