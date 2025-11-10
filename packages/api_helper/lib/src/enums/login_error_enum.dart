enum LoginErrorEnum {
  unknownError(
    errorId: 500,
    errorTitle: 'Error en nuestros servicios',
    errorDescription:
        'Por favor, intentá nuevamente más tarde. Ante cualquier consulta, podés escribirle a Swity, tu asistente virtual, por WhatsApp.',
    errorPrincipalButton: 'Aceptar',
    isWithTwoButtons: true,
    errorSecondButton: 'Abrir WhatsApp',
  ),
  internetError(
    errorId: null,
    errorTitle: 'Error de conexión',
    errorDescription: 'Revisá tu conexión a internet e intentá nuevamente.',
    errorPrincipalButton: 'Aceptar',
  ),
  error401(
    errorId: 401,
    errorTitle: 'Algunos datos son erróneos',
    errorDescription: 'Por favor, verificá los campos ingresados para intentar nuevamente.',
    errorPrincipalButton: 'Aceptar',
  ),
  error1005(
    errorId: 1005,
    errorTitle: 'Superaste el límite de intentos erróneos',
    errorDescription: 'Deberás recuperar tu contraseña para acceder nuevamente.',
    errorPrincipalButton: 'Recuperar contraseña',
    isWithTwoButtons: true,
    errorSecondButton: 'Cancelar',
  ),
  error1000(
    errorId: 1000,
    errorTitle: 'Aún no tenés una cuenta registrada',
    errorDescription: 'Para ingresar deberás registrarte con tus datos y número de credencial.',
    errorPrincipalButton: 'Registrar mi cuenta',
    isWithTwoButtons: true,
    errorSecondButton: 'Cancelar',
  ),
  error1001(
    errorId: 1001,
    errorTitle: 'No pudimos validar tus datos',
    errorDescription:
        'Para mayor información comunicate con nuestros ejecutivos de atención al cliente a través de Swity, tu asistente virtual, por WhatsApp.',
    errorPrincipalButton: 'Abrir WhatsApp',
    isWithTwoButtons: true,
    errorSecondButton: 'Cancelar',
  ),
  error1002(
    errorId: 1002,
    errorTitle: 'Tu cuenta se activará el día',
    errorDescription:
        'Podrás ingresar una vez que haya iniciado tu cobertura. Ante cualquier consulta, podés escribirle a Swity, tu asistente virtual, por WhatsApp.',
    errorPrincipalButton: 'Abrir WhatsApp',
    isWithTwoButtons: true,
    errorSecondButton: 'Cancelar',
  ),
  errorNoProduct(
    errorId: 1101,
    errorTitle: 'Tu cuenta no posee ningún producto vinculado',
    errorDescription: 'Para acceder deberás vincular tu cobertura de Swiss Medical Medicina Privada completando tu número credencial.',
    errorPrincipalButton: 'Vincular mi producto',
    isWithTwoButtons: true,
    errorSecondButton: 'Cancelar',
  );

  const LoginErrorEnum({
    required this.errorId,
    required this.errorTitle,
    required this.errorDescription,
    this.isWithTwoButtons = false,
    required this.errorPrincipalButton,
    this.errorSecondButton,
  });

  final int? errorId;
  final String errorTitle;
  final String errorDescription;
  final bool isWithTwoButtons;
  final String errorPrincipalButton;
  final String? errorSecondButton;
}
