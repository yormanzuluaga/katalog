import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/feature/setting/bloc/setting_bloc.dart';
import 'package:talentpitch_test/injection/injection_container.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class SettingMobile extends StatelessWidget {
  const SettingMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTechnical,
      body: BlocProvider(
        create: (context) => sl<SettingBloc>(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 8, bottom: 12),
              child: BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            // avatar != ''
                            //     ? NetworkImage(avatar)
                            //     :
                            const NetworkImage(
                                "https://gravatar.com/avatar/8d3906acfe8aa2650ba9456258216bfd?s=400&d=mp&r=x"),
                        radius: 40,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        //  firstName != '' ? '$firstName $lastName' :
                        'Hola',
                        style: const TextStyle(
                          color: AppColors.primaryMain,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.whitePure,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: AppColors.primaryMain,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            const Text(
                              'Editar perfil',
                              style: TextStyle(color: AppColors.primaryMain),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryMain,
                        ),
                      ],
                    ),
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePages()));
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.whitePure,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.add_business_outlined,
                              color: AppColors.primaryMain,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            const Text(
                              'Mi negoció',
                              style: TextStyle(color: AppColors.primaryMain),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryMain,
                        ),
                      ],
                    ),
                    onTap: () {
                      // showModalBottomSheet(
                      //     backgroundColor: Colors.transparent,
                      //     context: context,
                      //     builder: (context) {
                      //       return const SingleMarketOptions();
                      //     });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.whitePure,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.report_gmailerrorred_outlined,
                              color: AppColors.primaryMain,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            const Text(
                              'Configuracion',
                              style: TextStyle(color: AppColors.primaryMain),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryMain,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const Configuration(),
                      //     ));
                    },
                  ),
                ),
              ),
            ),
            AppButton.teartiary(
              title: 'Cerrar sesión',
              onPressed: () {
                context.read<SettingBloc>().add(const SignOutSettingEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
