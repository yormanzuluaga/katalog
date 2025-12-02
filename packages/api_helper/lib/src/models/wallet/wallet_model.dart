class WalletModel {
  final double balance;
  final double totalEarnings;
  final double pendingEarnings;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.balance,
    required this.totalEarnings,
    required this.pendingEarnings,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] ?? 0).toDouble(),
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      pendingEarnings: (json['pendingEarnings'] ?? 0).toDouble(),
      transactions: (json['transactions'] as List?)?.map((e) => TransactionModel.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'totalEarnings': totalEarnings,
      'pendingEarnings': pendingEarnings,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}

class TransactionModel {
  final String id;
  final String type; // 'sale', 'withdrawal', 'refund'
  final double amount;
  final DateTime date;
  final String status; // 'completed', 'pending', 'failed'
  final String? orderId;
  final String? productName;
  final String description;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    this.orderId,
    this.productName,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'sale',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'completed',
      orderId: json['orderId'],
      productName: json['productName'],
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'orderId': orderId,
      'productName': productName,
      'description': description,
    };
  }
}
