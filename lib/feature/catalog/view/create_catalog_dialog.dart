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
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _primaryColorController = TextEditingController(text: '#FF69B4');
  final _secondaryColorController = TextEditingController(text: '#8B008B');
  final _logoUrlController = TextEditingController();

  bool _isPublic = true;
  bool _showPrices = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-populate contact info from UserStore
    final userStore = UserStore.instance;
    _phoneController.text = userStore.mobile;
    _emailController.text = userStore.email;
    _whatsappController.text = userStore.mobile; // WhatsApp uses same as phone
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _logoUrlController.dispose();
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
        height: MediaQuery.of(context).size.height * 0.9,
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
                      _buildSectionTitle('Información Básica'),
                      const SizedBox(height: 16),
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
                          prefixIcon: Icon(Icons.book),
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
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Configuración
                      _buildSectionTitle('Configuración'),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Catálogo público'),
                        subtitle:
                            const Text('Cualquiera puede ver tu catálogo'),
                        value: _isPublic,
                        onChanged: (value) => setState(() => _isPublic = value),
                      ),
                      SwitchListTile(
                        title: const Text('Mostrar precios'),
                        subtitle: const Text('Los clientes verán los precios'),
                        value: _showPrices,
                        onChanged: (value) =>
                            setState(() => _showPrices = value),
                      ),
                      const SizedBox(height: 24),

                      // Información de contacto
                      _buildSectionTitle('Información de Contacto'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
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
                          prefixIcon: Icon(Icons.phone),
                          hintText: '+57 300 123 4567',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                          prefixIcon: Icon(Icons.email),
                          hintText: 'ventas@ejemplo.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _whatsappController,
                        decoration: InputDecoration(
                          labelText: 'WhatsApp',
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
                          prefixIcon: Icon(Icons.chat),
                          hintText: '+573001234567',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),

                      // Personalización
                      _buildSectionTitle('Personalización'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _primaryColorController,
                              decoration: InputDecoration(
                                labelText: 'Color primario',
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
                                hintText: '#FF69B4',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _secondaryColorController,
                              decoration: InputDecoration(
                                labelText: 'Color secundario',
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
                                hintText: '#8B008B',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _logoUrlController,
                        decoration: InputDecoration(
                          labelText: 'URL del logo',
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
                          prefixIcon: Icon(Icons.image),
                          hintText: 'https://ejemplo.com/logo.png',
                        ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  void _createCatalog() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = CreateCatalogRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      settings: CatalogSettings(
        isPublic: _isPublic,
        showPrices: _showPrices,
        theme: CatalogTheme(
          primaryColor: _primaryColorController.text.trim(),
          secondaryColor: _secondaryColorController.text.trim(),
          logoUrl: _logoUrlController.text.trim().isEmpty
              ? null
              : _logoUrlController.text.trim(),
        ),
        contactInfo: ContactInfo(
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          whatsapp: _whatsappController.text.trim().isEmpty
              ? null
              : _whatsappController.text.trim(),
        ),
      ),
      products: [],
    );

    context.read<CatalogBloc>().add(CreateCatalog(request: request));
  }
}
