// ignore_for_file: public_member_api_docs

part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.selectedInstitution,
    this.firstBiometric = true,
    this.legalNotificationModal = false,
    this.mustShowQualtrics,
    this.token,
    this.userSession,
    this.userName,
    this.signIn = false,
  });

  final String? selectedInstitution;
  final bool legalNotificationModal;
  final bool firstBiometric;
  final bool? mustShowQualtrics;

  final String? token;
  final String? userName;

  final User? userSession;
  final bool signIn;

  @override
  List<Object?> get props => [
        firstBiometric,
        selectedInstitution,
        legalNotificationModal,
        mustShowQualtrics,
        token,
        userName,
        userSession,
        signIn,
      ];

  AppState copyWith({
    bool? firstBiometric,
    String? selectedInstitution,
    bool? legalNotificationModal,
    bool? mustShowQualtrics,
    String? token,
    String? userName,
    User? userSession,
    bool? signIn,
  }) {
    return AppState(
      firstBiometric: firstBiometric ?? this.firstBiometric,
      selectedInstitution: selectedInstitution ?? this.selectedInstitution,
      legalNotificationModal: legalNotificationModal ?? this.legalNotificationModal,
      mustShowQualtrics: mustShowQualtrics ?? this.mustShowQualtrics,
      token: token ?? this.token,
      userName: userName ?? this.userName,
      userSession: userSession ?? this.userSession,
      signIn: signIn ?? this.signIn,
    );
  }

  Map<String, String> createHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };
  }
}
