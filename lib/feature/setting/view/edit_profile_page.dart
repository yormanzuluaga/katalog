import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/core/database/user_store.dart';
import 'package:talentpitch_test/feature/setting/bloc/profile/profile_bloc.dart';
import 'package:talentpitch_test/injection/injection_container.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    final userStore = UserStore.instance;
    _firstNameController = TextEditingController(text: userStore.firstName);
    _lastNameController = TextEditingController(text: userStore.lastName);
    _emailController = TextEditingController(text: userStore.email);
    _mobileController = TextEditingController(text: userStore.mobile);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.message != null && !state.isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.message!.contains('exitosamente')
                    ? Colors.green
                    : Colors.red,
              ),
            );

            if (state.message!.contains('exitosamente')) {
              Navigator.pop(context);
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.whitePure,
                          backgroundImage: UserStore.instance.avatar.isNotEmpty
                              ? NetworkImage(UserStore.instance.avatar)
                              : const NetworkImage(
                                  "https://gravatar.com/avatar/8d3906acfe8aa2650ba9456258216bfd?s=400&d=mp&r=x"),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryMain,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                // TODO: Implementar cambio de foto
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Funcionalidad de cambio de foto próximamente'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
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
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
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
                      labelText: 'Apellido',
                      prefixIcon: Icon(Icons.person_outline),
                      fillColor: AppColors.whitePure,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El apellido es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email (read-only)
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
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
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: AppColors.whitePure,
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  // Mobile
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
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
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '+57 300 123 4567',
                      fillColor: AppColors.whitePure,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ProfileBloc>().add(
                                    UpdateProfile(
                                      firstName:
                                          _firstNameController.text.trim(),
                                      lastName: _lastNameController.text.trim(),
                                      mobile: _mobileController.text.trim(),
                                    ),
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Guardar Cambios',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
