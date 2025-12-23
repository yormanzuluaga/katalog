import 'package:equatable/equatable.dart';

/// {@template withdrawal_request}
/// Model for a withdrawal request.
/// {@endtemplate}
class WithdrawalRequest extends Equatable {
  /// {@macro withdrawal_request}
  const WithdrawalRequest({
    required this.amount,
    required this.withdrawalMethod,
    required this.accountInfo,
  });

  /// The amount to withdraw
  final double amount;

  /// The withdrawal method (Bancolombia, Nequi, Daviplata)
  final String withdrawalMethod;

  /// Account information for the withdrawal
  final AccountInfo accountInfo;

  /// Converts this model to a JSON map
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'withdrawalMethod': withdrawalMethod,
        'accountInfo': accountInfo.toJson(),
      };

  @override
  List<Object?> get props => [amount, withdrawalMethod, accountInfo];
}

/// {@template account_info}
/// Model for account information in a withdrawal request.
/// {@endtemplate}
class AccountInfo extends Equatable {
  /// {@macro account_info}
  const AccountInfo({
    this.accountNumber,
    this.accountType,
    required this.accountHolder,
    required this.bank,
    required this.documentType,
    required this.documentNumber,
    required this.email,
    required this.phone,
  });

  /// Account number (required for bank transfers, not for Nequi)
  final String? accountNumber;

  /// Account type (required for bank transfers, not for Nequi)
  final String? accountType;

  /// Name of the account holder
  final String accountHolder;

  /// Bank name (Bancolombia, Nequi, Daviplata)
  final String bank;

  /// Type of identification document
  final String documentType;

  /// Document number
  final String documentNumber;

  /// Email address
  final String email;

  /// Phone number
  final String phone;

  /// Converts this model to a JSON map
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'accountHolder': accountHolder,
      'bank': bank,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'email': email,
      'phone': phone,
    };

    if (accountNumber != null) {
      json['accountNumber'] = accountNumber;
    }
    if (accountType != null) {
      json['accountType'] = accountType;
    }

    return json;
  }

  @override
  List<Object?> get props => [
        accountNumber,
        accountType,
        accountHolder,
        bank,
        documentType,
        documentNumber,
        email,
        phone,
      ];
}

/// {@template withdrawal_response}
/// Response from a withdrawal request.
/// {@endtemplate}
class WithdrawalResponse extends Equatable {
  /// {@macro withdrawal_response}
  const WithdrawalResponse({
    required this.success,
    required this.message,
    this.withdrawalId,
    this.status,
  });

  /// Creates a [WithdrawalResponse] from JSON
  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      withdrawalId: json['withdrawalId'] as String?,
      status: json['status'] as String?,
    );
  }

  /// Whether the withdrawal request was successful
  final bool success;

  /// Message from the server
  final String message;

  /// ID of the withdrawal request
  final String? withdrawalId;

  /// Status of the withdrawal
  final String? status;

  @override
  List<Object?> get props => [success, message, withdrawalId, status];
}
