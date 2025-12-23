import 'package:equatable/equatable.dart';

/// {@template my_withdrawal}
/// Model for my withdrawal information.
/// {@endtemplate}
class MyWithdrawal extends Equatable {
  /// {@macro my_withdrawal}
  const MyWithdrawal({
    required this.id,
    required this.amount,
    required this.status,
    required this.withdrawalMethod,
    required this.createdAt,
    this.accountInfo,
    this.processedAt,
    this.rejectionReason,
  });

  /// Creates a [MyWithdrawal] from JSON
  factory MyWithdrawal.fromJson(Map<String, dynamic> json) {
    return MyWithdrawal(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      withdrawalMethod: json['withdrawalMethod'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      accountInfo: json['accountInfo'] != null
          ? WithdrawalAccountInfo.fromJson(
              json['accountInfo'] as Map<String, dynamic>)
          : null,
      processedAt: json['processedAt'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  /// Withdrawal ID
  final String id;

  /// Amount to withdraw
  final double amount;

  /// Status: pending, approved, cancelled
  final String status;

  /// Withdrawal method
  final String withdrawalMethod;

  /// Created date
  final String createdAt;

  /// Account information
  final WithdrawalAccountInfo? accountInfo;

  /// Processed date
  final String? processedAt;

  /// Rejection reason if cancelled
  final String? rejectionReason;

  /// Status label in Spanish
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'approved':
        return 'Aprobado';
      case 'cancelled':
      case 'rejected':
        return 'Cancelado';
      default:
        return status;
    }
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        status,
        withdrawalMethod,
        createdAt,
        accountInfo,
        processedAt,
        rejectionReason,
      ];
}

/// {@template withdrawal_account_info}
/// Account information for withdrawal.
/// {@endtemplate}
class WithdrawalAccountInfo extends Equatable {
  /// {@macro withdrawal_account_info}
  const WithdrawalAccountInfo({
    this.accountNumber,
    this.accountType,
    required this.accountHolder,
    required this.bank,
    this.documentType,
    this.documentNumber,
    this.email,
    this.phone,
  });

  /// Creates a [WithdrawalAccountInfo] from JSON
  factory WithdrawalAccountInfo.fromJson(Map<String, dynamic> json) {
    return WithdrawalAccountInfo(
      accountNumber: json['accountNumber'] as String?,
      accountType: json['accountType'] as String?,
      accountHolder: json['accountHolder'] as String? ?? '',
      bank: json['bank'] as String? ?? json['bankName'] as String? ?? '',
      documentType: json['documentType'] as String?,
      documentNumber: json['documentNumber'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  final String? accountNumber;
  final String? accountType;
  final String accountHolder;
  final String bank;
  final String? documentType;
  final String? documentNumber;
  final String? email;
  final String? phone;

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
