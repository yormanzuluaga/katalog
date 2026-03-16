import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/core/database/user_store.dart';
import 'package:talentpitch_test/feature/catalog/bloc/catalog/catalog_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CreateCatalogDialog extends StatefulWidget {
  const CreateCatalogDialog({Key? key}) : super(key: key);

  @override
  State<CreateCatalogDialog> createState() => _CreateCatalogDialogState();
}

class _CreateCatalogDialogState extends State<CreateCatalogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.message != null &&
            state.message!.contains('exitosamente') &&
            !state.isLoading) {
          Navigator.pop(context);
          context.read<CatalogBloc>().add(const LoadMyCatalogs());
        }
        setState(() {
          _isLoading = state.isLoading;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
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
              ),
              decoration: const BoxDecoration(
                color: AppColors.whiteTechnical,
                borderRadius: BorderRadius.only(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Crear Catálogo',
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
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información básica
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del catálogo *',
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
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.book),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
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
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.whitePure,
                          filled: true,
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            // Footer con botones
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: MaterialButton(
                onPressed: _isLoading ? null : _createCatalog,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppColors.secondary,
                height: 42.0,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Crear Catálogo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createCatalog() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Obtener datos del usuario almacenados
    final userStore = UserStore.instance;

    final request = CreateCatalogRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      settings: CatalogSettings(
        isPublic: true,
        showPrices: true,
        theme: CatalogTheme(
          primaryColor: '#FF69B4',
          secondaryColor: '#8B008B',
          logoUrl: userStore.avatar.isNotEmpty ? userStore.avatar : null,
        ),
        contactInfo: ContactInfo(
          phone: userStore.mobile.isNotEmpty ? userStore.mobile : null,
          email: userStore.email.isNotEmpty ? userStore.email : null,
          whatsapp: userStore.mobile.isNotEmpty ? userStore.mobile : null,
        ),
      ),
      products: [],
    );

    context.read<CatalogBloc>().add(CreateCatalog(request: request));
  }
}
