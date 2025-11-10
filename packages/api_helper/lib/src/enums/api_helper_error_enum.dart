enum ApiHelperErrorEnum {
  decodeError(
    errorId: 1200,
    errorDescription: {
      "data": {"errNumber": "1200", "errMessage": "DECODE_ERROR_FAILURE"}
    },
  ),
  noConnnection(
    errorId: 1100,
    errorDescription: {
      "data": {"errNumber": "1100", "errMessage": "CONNECTION_INTERNET_FAIL"}
    },
  ),
  noInformationError(
    errorId: 1300,
    errorDescription: {
      "data": {"errNumber": "1300", "errMessage": "NO_INFORMATION_FOUND"}
    },
  ),
  unauthorizedError(
    errorId: 401,
    errorDescription: {
      "data": {"errNumber": "401", "errMessage": "USER_NOT_AUTHORIZED"}
    },
  ),

  unexpectedError(
    errorId: 500,
    errorDescription: {
      "data": {"errNumber": "500", "errMessage": "Unexpected Error"}
    },
  );

  const ApiHelperErrorEnum({
    required this.errorId,
    required this.errorDescription,
  });

  final int errorId;
  final Map<String, dynamic> errorDescription;
}
