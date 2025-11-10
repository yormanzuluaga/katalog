import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:talentpitch_test/feature/auth/widget/creater_user.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class VerifyNumberMobile extends StatefulWidget {
  final String numbePhone;

  const VerifyNumberMobile({
    Key? key,
    required this.numbePhone,
  }) : super(key: key);

  @override
  VerifyNumberMobileState createState() => VerifyNumberMobileState();
}

class VerifyNumberMobileState extends State<VerifyNumberMobile> {
  TextEditingController controller = TextEditingController();
  PageController controllerSlides = PageController(initialPage: 0);

  late String smsCode = '';
  bool enableButton = false;
  Duration duration = const Duration(seconds: 120);
  int currentPageSlideImages = 0;
  int currentPage = 0;
  Timer? timer;

  bool isNum = false;

  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    // Calcular los segundos iniciales a partir de 2:00
    int initialSeconds = 2 * 60;
    _secondsRemaining = initialSeconds;

    // Actualizar la interfaz gráfica con el tiempo inicial
    setState(() {});

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          context.read<AuthBloc>().add(AuthInforEvent(
                indexScreen: 'login',
              ));
          //Navigator.pop(context, false);
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthInforEvent(
                      indexScreen: 'login',
                    ));
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.primaryMain,
              ),
            ),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'Ingresar código recibido.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryMain,
                    ),
                  ),
                  SizedBox(height: 32),
                  Pinput(
                    defaultPinTheme: PinTheme(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(color: AppColors.gray80, borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    length: 6,
                    showCursor: true,
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 6) {
                          smsCode = value;
                          enableButton = true;
                        } else {
                          smsCode = value;
                          enableButton = false;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 16),
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
                                backgroundColor: AppColors.primaryMain,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: enableButton
                                  ? () async {
                                      context.read<AuthBloc>().login(
                                        context,
                                        code: smsCode,
                                        onSuccess: (value) async {
                                          BlocProvider.of<AppBloc>(context).add(
                                            SetUserData(
                                              token: value.token ?? '',
                                              userName: value.userName ?? '',
                                              userSession: value.userSession,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  : null,
                              child: const Text(
                                "Verificación el numero",
                                style: TextStyle(
                                  color: AppColors.whitePure,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text(
                            "¿Editar el numero?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryMain,
                            ),
                          )),
                      Text(
                        formatTime(_secondsRemaining).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryMain,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
