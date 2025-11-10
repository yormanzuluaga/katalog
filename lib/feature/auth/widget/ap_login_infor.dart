import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:talentpitch_test/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:talentpitch_test/flavor.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ApLoginInfor extends StatefulWidget {
  const ApLoginInfor({Key? key}) : super(key: key);

  @override
  ApLoginInforState createState() => ApLoginInforState();
}

class ApLoginInforState extends State<ApLoginInfor> {
  late String numberPhone = '';
  late String country = '';

  bool enableButton = false;
  bool enableError = false;

  bool isNum = false;

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
                    child: PhoneFormField(
                      initialValue: PhoneNumber.parse('+57'),
                      cursorColor: AppColors.secondaryDark,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: AppColors.secondaryDark,
                      ),
                      autofillHints: const [AutofillHints.telephoneNumber],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      validator: (phoneNumber) {
                        if (phoneNumber == null || !phoneNumber.isValid()) {
                          return "Número de teléfono móvil no es válido";
                        }
                        return null;
                      },
                      autofocus: false,
                      enableInteractiveSelection: false,
                      countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        countries: Flavor.instance.countries,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isValid()) {
                            if (value.nsn.length == 10 && '57' == value.countryCode) {
                              FocusScope.of(context).unfocus();
                              numberPhone = value.nsn;
                              country = value.countryCode;
                            } else if (value.nsn.length == 8 && '506' == value.countryCode) {
                              FocusScope.of(context).unfocus();
                              numberPhone = value.nsn;
                              country = value.countryCode;
                            } else if (value.nsn.length == 9 && '593' == value.countryCode) {
                              FocusScope.of(context).unfocus();
                              numberPhone = value.nsn;
                              country = value.countryCode;
                            } else if (value.nsn.length == 10 && '52' == value.countryCode) {
                              FocusScope.of(context).unfocus();
                              numberPhone = value.nsn;
                              country = value.countryCode;
                            }
                          }
                        });
                      },
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
