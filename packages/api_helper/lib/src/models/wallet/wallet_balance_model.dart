import 'package:equatable/equatable.dart';

/// {@template wallet_balance_response}
/// Model for wallet balance API response
/// {@endtemplate}
class WalletBalanceResponse extends Equatable {
  /// {@macro wallet_balance_response}
  const WalletBalanceResponse({
    required this.ok,
    required this.balance,
    required this.pendingBalance,
    required this.points,
    required this.totalCommissionsEarned,
    required this.totalEarned,
    required this.totalPointsEarned,
    required this.settings,
    required this.stats,
    required this.user,
  });

  /// Creates a [WalletBalanceResponse] from a JSON object
  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      ok: json['ok'] as bool? ?? false,
      balance: (json['balance'] as num?) ?? 0.0,
      pendingBalance: (json['pendingBalance'] as num?) ?? 0.0,
      points: json['points'] as int? ?? 0,
      totalCommissionsEarned: (json['totalCommissionsEarned'] as num?) ?? 0.0,
      totalEarned: (json['totalEarned'] as num?) ?? 0.0,
      totalPointsEarned: json['totalPointsEarned'] as int? ?? 0,
      settings: json['settings'] != null
          ? WalletSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : const WalletSettings(
              bankInfo: {},
              notifications: WalletNotifications(
                emailOnCommission: false,
                emailOnWithdrawal: false,
                smsOnCommission: false,
              ),
              minimumWithdrawal: 0,
              preferredPaymentMethod: '',
            ),
      stats: json['stats'] != null
          ? WalletStats.fromJson(json['stats'] as Map<String, dynamic>)
          : const WalletStats(
              totalSales: 0,
              totalProducts: 0,
              averageCommissionPerSale: 0,
              salesThisMonth: 0,
              commissionsThisMonth: 0,
            ),
      user: json['user'] != null
          ? WalletUser.fromJson(json['user'] as Map<String, dynamic>)
          : const WalletUser(
              id: '', name: '', email: '', phone: '', avatar: ''),
    );
  }

  /// Whether the request was successful
  final bool ok;

  /// Available balance
  final num balance;

  /// Pending balance
  final num pendingBalance;

  /// Points
  final int points;

  /// Total commissions earned
  final num totalCommissionsEarned;

  /// Total earned
  final num totalEarned;

  /// Total points earned
  final int totalPointsEarned;

  /// Wallet settings
  final WalletSettings settings;

  /// Wallet statistics
  final WalletStats stats;

  /// User information
  final WalletUser user;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'balance': balance,
      'pendingBalance': pendingBalance,
      'points': points,
      'totalCommissionsEarned': totalCommissionsEarned,
      'totalEarned': totalEarned,
      'totalPointsEarned': totalPointsEarned,
      'settings': settings.toJson(),
      'stats': stats.toJson(),
      'user': user.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        ok,
        balance,
        pendingBalance,
        points,
        totalCommissionsEarned,
        totalEarned,
        totalPointsEarned,
        settings,
        stats,
        user,
      ];
}

/// {@template wallet_settings}
/// Model for wallet settings
/// {@endtemplate}
class WalletSettings extends Equatable {
  /// {@macro wallet_settings}
  const WalletSettings({
    required this.bankInfo,
    required this.notifications,
    required this.minimumWithdrawal,
    required this.preferredPaymentMethod,
  });

  /// Creates a [WalletSettings] from a JSON object
  factory WalletSettings.fromJson(Map<String, dynamic> json) {
    return WalletSettings(
      bankInfo: json['bankInfo'] as Map<String, dynamic>? ?? {},
      notifications: json['notifications'] != null
          ? WalletNotifications.fromJson(
              json['notifications'] as Map<String, dynamic>)
          : const WalletNotifications(
              emailOnCommission: false,
              emailOnWithdrawal: false,
              smsOnCommission: false,
            ),
      minimumWithdrawal: (json['minimumWithdrawal'] as num?) ?? 0.0,
      preferredPaymentMethod: json['preferredPaymentMethod'] as String? ?? '',
    );
  }

  final Map<String, dynamic> bankInfo;
  final WalletNotifications notifications;
  final num minimumWithdrawal;
  final String preferredPaymentMethod;

  Map<String, dynamic> toJson() {
    return {
      'bankInfo': bankInfo,
      'notifications': notifications.toJson(),
      'minimumWithdrawal': minimumWithdrawal,
      'preferredPaymentMethod': preferredPaymentMethod,
    };
  }

  @override
  List<Object?> get props =>
      [bankInfo, notifications, minimumWithdrawal, preferredPaymentMethod];
}

/// {@template wallet_notifications}
/// Model for wallet notifications settings
/// {@endtemplate}
class WalletNotifications extends Equatable {
  /// {@macro wallet_notifications}
  const WalletNotifications({
    required this.emailOnCommission,
    required this.emailOnWithdrawal,
    required this.smsOnCommission,
  });

  /// Creates a [WalletNotifications] from a JSON object
  factory WalletNotifications.fromJson(Map<String, dynamic> json) {
    return WalletNotifications(
      emailOnCommission: json['emailOnCommission'] as bool? ?? false,
      emailOnWithdrawal: json['emailOnWithdrawal'] as bool? ?? false,
      smsOnCommission: json['smsOnCommission'] as bool? ?? false,
    );
  }

  final bool emailOnCommission;
  final bool emailOnWithdrawal;
  final bool smsOnCommission;

  Map<String, dynamic> toJson() {
    return {
      'emailOnCommission': emailOnCommission,
      'emailOnWithdrawal': emailOnWithdrawal,
      'smsOnCommission': smsOnCommission,
    };
  }

  @override
  List<Object?> get props =>
      [emailOnCommission, emailOnWithdrawal, smsOnCommission];
}

/// {@template wallet_stats}
/// Model for wallet statistics
/// {@endtemplate}
class WalletStats extends Equatable {
  /// {@macro wallet_stats}
  const WalletStats({
    required this.totalSales,
    required this.totalProducts,
    required this.averageCommissionPerSale,
    required this.salesThisMonth,
    required this.commissionsThisMonth,
  });

  /// Creates a [WalletStats] from a JSON object
  factory WalletStats.fromJson(Map<String, dynamic> json) {
    return WalletStats(
      totalSales: json['totalSales'] as int? ?? 0,
      totalProducts: json['totalProducts'] as int? ?? 0,
      averageCommissionPerSale:
          (json['averageCommissionPerSale'] as num?) ?? 0.0,
      salesThisMonth: json['salesThisMonth'] as int? ?? 0,
      commissionsThisMonth: (json['commissionsThisMonth'] as num?) ?? 0.0,
    );
  }

  final int totalSales;
  final int totalProducts;
  final num averageCommissionPerSale;
  final int salesThisMonth;
  final num commissionsThisMonth;

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalProducts': totalProducts,
      'averageCommissionPerSale': averageCommissionPerSale,
      'salesThisMonth': salesThisMonth,
      'commissionsThisMonth': commissionsThisMonth,
    };
  }

  @override
  List<Object?> get props => [
        totalSales,
        totalProducts,
        averageCommissionPerSale,
        salesThisMonth,
        commissionsThisMonth,
      ];
}

/// {@template wallet_user}
/// Model for wallet user information
/// {@endtemplate}
class WalletUser extends Equatable {
  /// {@macro wallet_user}
  const WalletUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  /// Creates a [WalletUser] from a JSON object
  factory WalletUser.fromJson(Map<String, dynamic> json) {
    return WalletUser(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }

  @override
  List<Object?> get props => [id, name, email, phone, avatar];
}
