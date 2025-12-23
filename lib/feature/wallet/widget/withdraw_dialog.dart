import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:api_helper/api_helper.dart';

class WithdrawDialog extends StatefulWidget {
  final double availableBalance;
  final Function(WithdrawalRequest) onSubmit;

  const WithdrawDialog({
    Key? key,
    required this.availableBalance,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedMethod = 'bancolombia';
  String _selectedAccountType = 'ahorros';
  String _selectedDocumentType = 'CC';

  final List<Map<String, String>> _withdrawalMethods = [
    {'value': 'bancolombia', 'label': 'Bancolombia'},
    {'value': 'nequi', 'label': 'Nequi'},
    {'value': 'daviplata', 'label': 'Daviplata'},
  ];

  final List<Map<String, String>> _accountTypes = [
    {'value': 'ahorros', 'label': 'Ahorros'},
    {'value': 'corriente', 'label': 'Corriente'},
  ];

  final List<Map<String, String>> _documentTypes = [
    {'value': 'CC', 'label': 'Cédula de Ciudadanía'},
    {'value': 'CE', 'label': 'Cédula de Extranjería'},
    {'value': 'NIT', 'label': 'NIT'},
    {'value': 'PA', 'label': 'Pasaporte'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    _documentNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isNequi => _selectedMethod == 'nequi';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.whiteTechnical,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solicitar Retiro',
                        style: APTextStyle.textXL.bold,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Saldo disponible: \$${widget.availableBalance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryMain,
                        ),
                      ),
                    ],
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monto
                    _buildSectionTitle('Monto a retirar'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Monto *',
                        prefixText: '\$ ',
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
                        hintText:
                            '${widget.availableBalance.toStringAsFixed(0)}',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El monto es requerido';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Ingrese un monto válido';
                        }
                        if (amount > widget.availableBalance) {
                          return 'Saldo insuficiente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Método de retiro
                    _buildSectionTitle('Método de retiro'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedMethod,
                      decoration: InputDecoration(
                        labelText: 'Método *',
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
                        filled: true,
                        fillColor: AppColors.whitePure,
                      ),
                      items: _withdrawalMethods.map((method) {
                        return DropdownMenuItem(
                          value: method['value'],
                          child: Text(method['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Información de la cuenta
                    _buildSectionTitle('Información de la cuenta'),
                    const SizedBox(height: 12),

                    if (_isNequi) ...[
                      // Para Nequi solo celular
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Número de celular *',
                          prefixIcon: const Icon(Icons.phone_android),
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
                          filled: true,
                          fillColor: AppColors.whitePure,
                          hintText: '3001234567',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El celular es requerido';
                          }
                          if (value.length != 10) {
                            return 'Ingrese un celular válido (10 dígitos)';
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      // Para bancos
                      TextFormField(
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Número de cuenta *',
                          prefixIcon: const Icon(Icons.account_balance),
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
                          filled: true,
                          fillColor: AppColors.whitePure,
                          hintText: '12345678901',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El número de cuenta es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedAccountType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de cuenta *',
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
                          filled: true,
                          fillColor: AppColors.whitePure,
                        ),
                        items: _accountTypes.map((type) {
                          return DropdownMenuItem(
                            value: type['value'],
                            child: Text(type['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Información del titular
                    TextFormField(
                      controller: _accountHolderController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del titular *',
                        prefixIcon: const Icon(Icons.person),
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
                        filled: true,
                        fillColor: AppColors.whitePure,
                        hintText: 'Juan Pérez García',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedDocumentType,
                      decoration: InputDecoration(
                        labelText: 'Tipo doc. *',
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
                        filled: true,
                        fillColor: AppColors.whitePure,
                      ),
                      items: _documentTypes.map((type) {
                        return DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDocumentType = value!;
                        });
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _documentNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Número documento*',
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
                        filled: true,
                        fillColor: AppColors.whitePure,
                        hintText: '1234567890',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El documento es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email *',
                        prefixIcon: const Icon(Icons.email),
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
                        filled: true,
                        fillColor: AppColors.whitePure,
                        hintText: 'correo@ejemplo.com',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El email es requerido';
                        }
                        if (!value.contains('@')) {
                          return 'Ingrese un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Teléfono (solo si no es Nequi)
                    if (!_isNequi)
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Teléfono *',
                          prefixIcon: const Icon(Icons.phone),
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
                          filled: true,
                          fillColor: AppColors.whitePure,
                          hintText: '3001234567',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El teléfono es requerido';
                          }
                          return null;
                        },
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
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _submitWithdrawal,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Solicitar Retiro'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: APTextStyle.textMD.bold.copyWith(
        color: AppColors.secondaryDark,
      ),
    );
  }

  void _submitWithdrawal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = WithdrawalRequest(
      amount: double.parse(_amountController.text),
      withdrawalMethod: _selectedMethod,
      accountInfo: AccountInfo(
        accountNumber: _isNequi ? null : _accountNumberController.text,
        accountType: _isNequi ? null : _selectedAccountType,
        accountHolder: _accountHolderController.text,
        bank: _selectedMethod == 'bancolombia'
            ? 'Bancolombia'
            : _selectedMethod == 'nequi'
                ? 'Nequi'
                : 'Daviplata',
        documentType: _selectedDocumentType,
        documentNumber: _documentNumberController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      ),
    );

    widget.onSubmit(request);
    Navigator.pop(context);
  }
}
