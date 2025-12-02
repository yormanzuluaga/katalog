import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:talentpitch_test/feature/auth/widget/ap_login_infor.dart';
import 'package:talentpitch_test/feature/auth/widget/register_user.dart';
import 'package:talentpitch_test/feature/auth/widget/verify_number_mobile.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTechnical,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: state.indexScreen == 'login'
                          ? const ApLoginInfor()
                          : state.indexScreen != 'register'
                              ? const VerifyNumberMobile(
                                  numbePhone: '',
                                )
                              : RegisterUser(numberPhone: state.numberPhone.toString()),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
