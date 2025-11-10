import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class RegisterUser extends StatefulWidget {
  final String numberPhone;
  const RegisterUser({
    Key? key,
    required this.numberPhone,
  }) : super(key: key);

  @override
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSurname = TextEditingController();
  TextEditingController controllerNameStore = TextEditingController();

  final form = GlobalKey<FormState>();
  bool isNum = false;

  List<String> listsDrow = [
    'Tenico',
    'Negocio tecnico',
    'Otros',
  ];

  String dropdwonCurrentValue = 'Selecciona Tipo de cliente';

  bool isDispositivo = false;

  @override
  void initState() {
    isNum = false;
    super.initState();
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
              const SizedBox(height: 64),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Crea tu cuenta Wetechn',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¿Cómo te llamas?',
                    style: TextStyle(
                      color: AppColors.primaryMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: controllerName,
                  style: const TextStyle(color: AppColors.primaryMain),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    fillColor: AppColors.whitePure,
                    filled: true,
                    hintText: 'Nombre',
                    hintStyle: const TextStyle(color: AppColors.primaryMain),
                  ),
                  validator: (value) {
                    if (value == '') return 'Este campo es requerido';
                    return value!.length < 2 ? 'Minimo de 2 letra' : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: controllerSurname,
                  style: const TextStyle(color: AppColors.primaryMain),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    fillColor: AppColors.whitePure,
                    filled: true,
                    hintText: 'apellido',
                    hintStyle: const TextStyle(color: AppColors.primaryMain),
                  ),
                  validator: (value) {
                    if (value == '') return 'Este campo es requerido';
                    return value!.length < 2 ? 'Minimo de 2 letra' : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: controllerNameStore,
                  style: const TextStyle(color: AppColors.primaryMain),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    fillColor: AppColors.whitePure,
                    filled: true,
                    hintText: '¿Cómo se llamas tu negocio?',
                    hintStyle: const TextStyle(color: AppColors.primaryMain),
                  ),
                  validator: (value) {
                    if (value == '') return 'Este campo es requerido';
                    return value!.length < 2 ? 'Minimo de 2 letra' : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.whitePure,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton(
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 18,
                        ),
                        underline: Container(),
                        borderRadius: BorderRadius.circular(16),
                        items: listsDrow.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        hint: Text(
                          dropdwonCurrentValue,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 18,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            dropdwonCurrentValue = value.toString();
                            isDispositivo = true;
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              isNum
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryMain,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {});
                            if (form.currentState!.validate()) {
                              if (!isDispositivo) {
                                //showSnackBar(context, 'Debes Seleccionar un tipo de cliente');
                              } else {
                                // context.read<LoginBloc>().add(CreateUserEvent(
                                //       createUser: CreateUserModel(
                                //         firstName: controllerName.text,
                                //         lastName: controllerSurname.text,
                                //         email: '',
                                //         password: '',
                                //         countryCode: '+57',
                                //         mobile: widget.numberPhone,
                                //         collaborator: '',
                                //         rol: dropdwonCurrentValue != 'Negocio'
                                //             ? dropdwonCurrentValue != 'Otros'
                                //                 ? 'TECHNICAL_ROLE'
                                //                 : "USER_ROLE"
                                //             : 'STORE_ROLE',
                                //         avatar: '',
                                //         estado: true,
                                //         google: false,
                                //         apple: false,
                                //         facebook: false,
                                //         nameStore: controllerNameStore.text,
                                //         location: '',
                                //         date: DateTime.now().toString(),
                                //       ),
                                //       context: context,
                                //     ));
                                // isNum = true;
                              }
                            }
                          },
                          child: const Text(
                            "Continuar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
