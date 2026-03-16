import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class RegisterUser extends StatefulWidget {
  final String numberPhone;
  const RegisterUser({
    super.key,
    required this.numberPhone,
  });

  @override
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerSurname = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();

  final FocusNode focusName = FocusNode();
  final FocusNode focusSurname = FocusNode();
  final FocusNode focusEmail = FocusNode();

  final form = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerSurname.dispose();
    controllerEmail.dispose();
    focusName.dispose();
    focusSurname.dispose();
    focusEmail.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length < 2) {
      return 'Mínimo 2 caracteres';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: form,
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Crea tu cuenta Wetechn',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Número: ${widget.numberPhone}',
                  style: const TextStyle(
                    color: AppColors.primaryMain,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: controllerName,
                  focusNode: focusName,
                  style: const TextStyle(
                    color: AppColors.primaryMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingresa tu nombre',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.primaryMain,
                    ),
                    labelStyle: const TextStyle(
                      color: AppColors.primaryMain,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.primaryMain.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryMain,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.primaryMain.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    fillColor: AppColors.whitePure,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusSurname);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: controllerSurname,
                  focusNode: focusSurname,
                  style: const TextStyle(
                    color: AppColors.primaryMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    hintText: 'Ingresa tu apellido',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.primaryMain,
                    ),
                    labelStyle: const TextStyle(
                      color: AppColors.primaryMain,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.primaryMain.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryMain,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.primaryMain.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    fillColor: AppColors.whitePure,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusEmail);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: controllerEmail,
                  focusNode: focusEmail,
                  style: const TextStyle(
                    color: AppColors.primaryMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email (opcional)',
                    hintText: 'correo@ejemplo.com',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.primaryMain,
                    ),
                    labelStyle: const TextStyle(
                      color: AppColors.primaryMain,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.primaryMain.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryMain,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.primaryMain.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    fillColor: AppColors.whitePure,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    focusEmail.unfocus();
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (form.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            context.read<AuthBloc>().add(
                                  CreateUserEvent(
                                    firstName: controllerName.text.trim(),
                                    lastName: controllerSurname.text.trim(),
                                    mobile: widget.numberPhone,
                                    countryCode: '+57',
                                    email: controllerEmail.text.trim().isEmpty
                                        ? null
                                        : controllerEmail.text.trim(),
                                    context: context,
                                  ),
                                );

                            // Reset loading state after a delay
                            await Future.delayed(const Duration(seconds: 2));
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.whitePure,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Crear cuenta",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
