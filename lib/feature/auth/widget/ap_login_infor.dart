import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ApLoginInfor extends StatefulWidget {
  const ApLoginInfor({Key? key}) : super(key: key);

  @override
  ApLoginInforState createState() => ApLoginInforState();
}

class ApLoginInforState extends State<ApLoginInfor> {
  late String numberPhone = '';
  late String country = '57'; // Default to Colombia

  bool enableButton = false;
  bool enableError = false;
  bool isNum = false;

  final TextEditingController _phoneController = TextEditingController();
  final List<Map<String, String>> _countries = [
    {'code': '57', 'name': 'Colombia', 'flag': '🇨🇴'},
    {'code': '52', 'name': 'México', 'flag': '🇲🇽'},
    {'code': '593', 'name': 'Ecuador', 'flag': '🇪🇨'},
    {'code': '506', 'name': 'Costa Rica', 'flag': '🇨🇷'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            child: const Text(
              'Bienvenido a',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMain,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
          ),
          child: Center(
            child: SizedBox(
              child: const Text(
                'WeTechn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMain,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.whitePure,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryMain.withOpacity(.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Tu aliado para administrar tus negocios.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  const Text(
                    'Ingresar con tu número de telefono.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryMain,
                    ),
                  ),
                  SizedBox(height: 64),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        // Country selector dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.black),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: country,
                              items: _countries
                                  .map((c) => DropdownMenuItem<String>(
                                        value: c['code']!,
                                        child: Text('${c['flag']} +${c['code']}'),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  country = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Phone input field
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            cursorColor: AppColors.secondaryDark,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: AppColors.secondaryDark,
                            ),
                            autofillHints: const [AutofillHints.telephoneNumber],
                            decoration: InputDecoration(
                              hintText: '123 456 789',
                              filled: true,
                              fillColor: AppColors.gray100.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: AppColors.gray100,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.black),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.black),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.primaryMain),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.primaryMain),
                              ),
                              errorStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Número de teléfono es requerido";
                              }
                              if (value.length < 7) {
                                return "Número de teléfono no válido";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                numberPhone = value;
                                // Validate phone length based on country
                                int requiredLength;
                                switch (country) {
                                  case '57': // Colombia
                                  case '52': // Mexico
                                    requiredLength = 10;
                                    break;
                                  case '506': // Costa Rica
                                    requiredLength = 8;
                                    break;
                                  case '593': // Ecuador
                                    requiredLength = 9;
                                    break;
                                  default:
                                    requiredLength = 8;
                                }

                                if (value.length == requiredLength) {
                                  FocusScope.of(context).unfocus();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  isNum
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryMain,
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryMain,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            onPressed: numberPhone.length > 6
                                ? () async {
                                    setState(() {
                                      // isNum = true;
                                    });
                                    context.read<AuthBloc>().add(
                                          VerificationEvent(
                                            mobile: numberPhone,
                                            code: country,
                                            context: context,
                                          ),
                                        );
                                  }
                                : null,
                            child: const Text(
                              "Enviar codigo",
                            ),
                          ),
                        ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
