import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class Appdrawer extends StatefulWidget {
  const Appdrawer({super.key});

  @override
  AppdrawerState createState() => AppdrawerState();
}

class AppdrawerState extends State<Appdrawer> {
  bool isNum = false;

  @override
  void initState() {
    isNum = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isNum
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.whitePure,
            ),
          )
        : Drawer(
            backgroundColor: AppColors.whitePure,
            surfaceTintColor: AppColors.whitePure,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8, bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            // avatar != ''
                            //     ? NetworkImage(avatar)
                            //     :
                            const NetworkImage("https://gravatar.com/avatar/8d3906acfe8aa2650ba9456258216bfd?s=400&d=mp&r=x"),
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
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                const Divider(
                  height: 0,
                  indent: 1,
                  thickness: 1,
                  color: AppColors.primaryMain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
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
                const Divider(
                  height: 0,
                  indent: 1,
                  thickness: 1,
                  color: AppColors.primaryMain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                const Divider(
                  height: 0,
                  indent: 1,
                  thickness: 1,
                  color: AppColors.primaryMain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                const Divider(
                  height: 0,
                  indent: 1,
                  thickness: 1,
                  color: AppColors.primaryMain,
                ),
              ],
            ),
          );
  }
}
