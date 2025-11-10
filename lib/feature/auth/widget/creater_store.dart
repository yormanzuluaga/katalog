import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CreaterStore extends StatefulWidget {
  const CreaterStore({Key? key}) : super(key: key);

  @override
  CreaterStoreState createState() => CreaterStoreState();
}

class CreaterStoreState extends State<CreaterStore> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSurname = TextEditingController();
  TextEditingController controllerNameStore = TextEditingController();

  final form = GlobalKey<FormState>();
  bool isNum = false;

  bool isDispositivo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteTechnical,
        leading: const Icon(
          Icons.add_business_outlined,
          color: AppColors.primaryMain,
        ),
        actions: [
          // IconButton(
          //   onPressed: () async => await AppUtils.instance.launchWhatsApp(context),
          //   icon: const Icon(Icons.support_agent_outlined),
          //   color: AppColors.primaryMain,
          // ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
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
                        'Crea tu negocio en Wetechn',
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
                          '¿Cómo se llamas tu negocio?',
                          style: TextStyle(
                            color: AppColors.primaryMain,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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
                          hintText: 'Nombre de negocio',
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
                                  // if (form.currentState!.validate()) {
                                  //   context.read<LoginBloc>().add(CreateStoreEvent(
                                  //         context: context,
                                  //         location: '',
                                  //         nameStore: controllerNameStore.text,
                                  //         login: 'login',
                                  //       ));
                                  //   isNum = true;
                                  // }
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
          ),
        ),
      ),
    );
  }
}
