import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/auth/widget/register_user.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CreaterUser extends StatefulWidget {
  final String numberPhone;

  const CreaterUser({
    Key? key,
    required this.numberPhone,
  }) : super(key: key);

  @override
  CreaterUserState createState() => CreaterUserState();
}

class CreaterUserState extends State<CreaterUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTechnical,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteTechnical,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_2_rounded),
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
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: constraints.maxWidth < 900
                ? RegisterUser(
                    numberPhone: widget.numberPhone,
                  )
                : Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.65),
                    },
                    children: [
                      TableRow(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryMain,
                            ),
                            child: const Center(
                                child: Text(
                              'Solicita tu servicio',
                              style: TextStyle(color: AppColors.whiteTechnical, fontWeight: FontWeight.bold, fontSize: 24),
                            )),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: RegisterUser(
                              numberPhone: widget.numberPhone,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}
