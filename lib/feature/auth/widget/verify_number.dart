import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/auth/widget/verify_number_mobile.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class MyVerify extends StatefulWidget {
  final String numbePhone;

  const MyVerify({
    Key? key,
    required this.numbePhone,
  }) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.whiteTechnical,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: constraints.maxWidth < 900
                      ? VerifyNumberMobile(
                          numbePhone: widget.numbePhone,
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
                                  height: 100,
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
                                  child: VerifyNumberMobile(
                                    numbePhone: widget.numbePhone,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
