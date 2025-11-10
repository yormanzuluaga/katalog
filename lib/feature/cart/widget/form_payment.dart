import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_test/feature/cart/bloc/address/address_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';

class FormPayment extends StatefulWidget {
  final int totalItems;
  final int totalPriceCop;
  final Address? editingAddress; // Para editar una dirección existente
  final bool isAddingAddress; // Para saber si estamos agregando una nueva dirección

  const FormPayment({
    super.key,
    this.totalItems = 0,
    this.totalPriceCop = 0,
    this.editingAddress,
    this.isAddingAddress = false,
  });

  @override
  State<FormPayment> createState() => _FormPaymentState();
}

class _FormPaymentState extends State<FormPayment> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _neighborhoodCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _isDefault = false;

  // Departamentos de Colombia como referencia:
  // Amazonas, Antioquia, Arauca, Atlántico, Bolívar, Boyacá, Caldas, Caquetá, Casanare,
  // Cauca, Cesar, Chocó, Córdoba, Cundinamarca, Guainía, Guaviare, Huila, La Guajira,
  // Magdalena, Meta, Nariño, Norte de Santander, Putumayo, Quindío, Risaralda,
  // San Andrés y Providencia, Santander, Sucre, Tolima, Valle del Cauca, Vaupés, Vichada, Bogotá D.C.

  @override
  void initState() {
    super.initState();

    // Si estamos editando una dirección, cargar los datos
    if (widget.editingAddress != null) {
      final address = widget.editingAddress!;
      _titleCtrl.text = address.title ?? '';
      _nameCtrl.text = address.fullName ?? '';
      _phoneCtrl.text = address.phone ?? '';
      _addressCtrl.text = address.address ?? '';
      _deptCtrl.text = address.state ?? '';
      _cityCtrl.text = address.city ?? '';
      _postalCtrl.text = address.postalCode ?? '';
      _neighborhoodCtrl.text = address.neighborhood ?? '';
      _notesCtrl.text = address.instructions ?? '';
      _isDefault = address.isDefault ?? false;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _deptCtrl.dispose();
    _cityCtrl.dispose();
    _postalCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        // Escuchar cuando se crea o actualiza una dirección exitosamente
        if (!state.isLoading && state.errorMessage == null && state.addressModel != null) {
          // Solo manejar si estamos agregando/editando dirección (no en proceso de compra)
          if (widget.isAddingAddress) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.editingAddress != null
                      ? 'Dirección actualizada exitosamente'
                      : 'Dirección agregada exitosamente',
                ),
                backgroundColor: AppColors.primaryMain,
                duration: const Duration(seconds: 2),
              ),
            );
            // Regresar a la pantalla de lista de direcciones
            Navigator.of(context).pop();
          }
        } else if (state.errorMessage != null) {
          // Mostrar error si algo salió mal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.redyMain,
            ),
          );
        }
      },
      child: Column(
        children: [
          Text(
            widget.editingAddress != null ? 'Editar Dirección' : 'Datos de envío',
            style: APTextStyle.textLG.bold,
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sección: Información básica
                    _buildSectionTitle('Información de la dirección'),
                    const SizedBox(height: 16),

                    _appTextField(
                      label: 'Título de la dirección',
                      placeholder: 'Casa, Oficina, Trabajo...',
                      controller: _titleCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un título' : null,
                      prefixIcon: FontAwesomeIcons.locationDot,
                    ),
                    const SizedBox(height: 16),

                    _appTextField(
                      label: 'Nombre completo',
                      placeholder: 'Nombre del destinatario',
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().length < 3) ? 'Ingresa tu nombre' : null,
                      prefixIcon: FontAwesomeIcons.user,
                    ),
                    const SizedBox(height: 16),

                    _appTextField(
                      label: 'Número de teléfono',
                      placeholder: '3001234567',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (v) => (v == null || v.length < 7) ? 'Número inválido' : null,
                      prefixIcon: FontAwesomeIcons.phone,
                    ),
                    const SizedBox(height: 24),

                    // Sección: Ubicación
                    _buildSectionTitle('Ubicación'),
                    const SizedBox(height: 16),

                    _appTextField(
                      label: 'Dirección completa',
                      placeholder: 'Calle, número, apartamento...',
                      controller: _addressCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu dirección' : null,
                      prefixIcon: FontAwesomeIcons.house,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _appTextField(
                            label: 'Departamento',
                            placeholder: 'Ej: Cundinamarca',
                            controller: _deptCtrl,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el departamento' : null,
                            prefixIcon: FontAwesomeIcons.mapLocationDot,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _appTextField(
                            label: 'Ciudad',
                            placeholder: 'Ciudad',
                            controller: _cityCtrl,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la ciudad' : null,
                            prefixIcon: FontAwesomeIcons.city,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _appTextField(
                            label: 'Código postal',
                            placeholder: '110111',
                            controller: _postalCtrl,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: FontAwesomeIcons.mapPin,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _appTextField(
                            label: 'Barrio',
                            placeholder: 'Barrio/Localidad',
                            controller: _neighborhoodCtrl,
                            textInputAction: TextInputAction.next,
                            prefixIcon: FontAwesomeIcons.house,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sección: Información adicional (opcional)
                    _buildSectionTitle('Información adicional (opcional)'),
                    const SizedBox(height: 16),

                    if (!widget.isAddingAddress) ...[
                      _appTextField(
                        label: 'Correo electrónico',
                        placeholder: 'correo@ejemplo.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: widget.isAddingAddress
                            ? null
                            : (v) {
                                if (v == null || v.isEmpty) return 'Ingresa tu correo';
                                final ok = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$').hasMatch(v);
                                return ok ? null : 'Correo inválido';
                              },
                        prefixIcon: FontAwesomeIcons.envelope,
                      ),
                      const SizedBox(height: 16),
                    ],

                    _appTextField(
                      label: 'Instrucciones de entrega',
                      placeholder: 'Apartamento 101, portero, etc.',
                      controller: _notesCtrl,
                      maxLines: 3,
                      textInputAction: TextInputAction.newline,
                      prefixIcon: FontAwesomeIcons.noteSticky,
                    ),
                    const SizedBox(height: 24),

                    // Checkbox para dirección principal
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isDefault,
                            onChanged: (value) {
                              setState(() {
                                _isDefault = value ?? false;
                              });
                            },
                            activeColor: AppColors.primaryMain,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Establecer como dirección principal',
                              style: APTextStyle.textMD.medium.copyWith(
                                color: AppColors.secondaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    AppButton.primary(
                      onPressed: _onContinue,
                      title: widget.editingAddress != null
                          ? 'Actualizar dirección'
                          : widget.isAddingAddress
                              ? 'Guardar dirección'
                              : 'Continuar al pago',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: APTextStyle.textLG.bold.copyWith(
        color: AppColors.secondaryDark,
      ),
    );
  }

  Widget _appTextField({
    required String label,
    String? placeholder,
    required TextEditingController controller,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: APTextStyle.textMD.medium.copyWith(
            color: AppColors.secondaryDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          style: APTextStyle.textMD.regular.copyWith(
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: APTextStyle.textMD.regular.copyWith(
              color: AppColors.gray100,
            ),
            prefixIcon: prefixIcon != null
                ? Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: FaIcon(
                      prefixIcon,
                      color: AppColors.primaryMain,
                      size: 18,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.gray50),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.gray50),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryMain, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.redyMain),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.redyMain, width: 2),
            ),
            filled: true,
            fillColor: AppColors.whitePure,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa los datos requeridos.')),
      );
      return;
    }

    // Crear el modelo de dirección
    final addressUserModel = AddressUserModel(
      title: _titleCtrl.text.trim().isNotEmpty ? _titleCtrl.text.trim() : 'Casa',
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _deptCtrl.text.trim(),
      country: 'Colombia',
      postalCode: _postalCtrl.text.trim().isNotEmpty ? _postalCtrl.text.trim() : null,
      neighborhood: _neighborhoodCtrl.text.trim().isNotEmpty ? _neighborhoodCtrl.text.trim() : null,
      instructions: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      isDefault: _isDefault,
      coordinates: Coordinates(
        latitude: 0.0,
        longitude: 0.0,
      ),
    );

    if (widget.editingAddress != null) {
      // Estamos editando una dirección existente
      context.read<AddressBloc>().add(
            UpdateAddress(
              id: widget.editingAddress!.id!,
              address: addressUserModel,
            ),
          );
    } else {
      // Estamos creando una nueva dirección
      context.read<AddressBloc>().add(
            CreateAddress(address: addressUserModel),
          );
    }

    // Si estamos en el proceso de compra (no agregando dirección), continuar al pago
    if (!widget.isAddingAddress) {
      final shippingData = {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'department': _deptCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'postalCode': _postalCtrl.text.trim(),
        'notes': _notesCtrl.text.trim(),
        'totalItems': widget.totalItems,
        'totalPriceCop': widget.totalPriceCop,
      };

      context.push(RoutesNames.payment, extra: shippingData);
    }
  }
}
