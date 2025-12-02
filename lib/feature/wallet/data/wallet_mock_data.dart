import 'package:api_helper/api_helper.dart';

/// Datos mock para testing y desarrollo del Wallet
class WalletMockData {
  /// Wallet de ejemplo con balance positivo y transacciones variadas
  static WalletModel get sampleWallet => WalletModel(
        balance: 2450.50,
        totalEarnings: 5230.75,
        pendingEarnings: 320.00,
        transactions: sampleTransactions,
      );

  /// Wallet vacío (nuevo usuario)
  static WalletModel get emptyWallet => WalletModel(
        balance: 0.0,
        totalEarnings: 0.0,
        pendingEarnings: 0.0,
        transactions: [],
      );

  /// Wallet con solo ganancias pendientes
  static WalletModel get pendingWallet => WalletModel(
        balance: 0.0,
        totalEarnings: 150.00,
        pendingEarnings: 150.00,
        transactions: [
          TransactionModel(
            id: 'pending-1',
            type: 'sale',
            amount: 150.00,
            date: DateTime.now().subtract(const Duration(hours: 2)),
            status: 'pending',
            orderId: 'ORD-PENDING-001',
            productName: 'Producto en proceso',
            description: 'Venta pendiente de confirmación',
          ),
        ],
      );

  /// Lista de transacciones de ejemplo
  static List<TransactionModel> get sampleTransactions => [
        // Venta reciente
        TransactionModel(
          id: 'txn-001',
          type: 'sale',
          amount: 150.00,
          date: DateTime.now().subtract(const Duration(hours: 2)),
          status: 'completed',
          orderId: 'ORD-001',
          productName: 'Producto Premium',
          description: 'Venta de producto',
        ),
        // Venta de ayer
        TransactionModel(
          id: 'txn-002',
          type: 'sale',
          amount: 89.99,
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'completed',
          orderId: 'ORD-002',
          productName: 'Servicio de consultoría',
          description: 'Venta de servicio',
        ),
        // Retiro pendiente
        TransactionModel(
          id: 'txn-003',
          type: 'withdrawal',
          amount: 500.00,
          date: DateTime.now().subtract(const Duration(days: 2)),
          status: 'pending',
          description: 'Retiro a cuenta bancaria',
        ),
        // Venta hace 3 días
        TransactionModel(
          id: 'txn-004',
          type: 'sale',
          amount: 225.50,
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'completed',
          orderId: 'ORD-003',
          productName: 'Curso online',
          description: 'Venta de curso',
        ),
        // Venta hace 4 días
        TransactionModel(
          id: 'txn-005',
          type: 'sale',
          amount: 75.00,
          date: DateTime.now().subtract(const Duration(days: 4)),
          status: 'completed',
          orderId: 'ORD-004',
          productName: 'Asesoría personalizada',
          description: 'Venta de asesoría',
        ),
        // Reembolso hace 5 días
        TransactionModel(
          id: 'txn-006',
          type: 'refund',
          amount: 50.00,
          date: DateTime.now().subtract(const Duration(days: 5)),
          status: 'completed',
          orderId: 'ORD-005',
          productName: 'Producto devuelto',
          description: 'Reembolso por devolución',
        ),
        // Retiro completado hace 1 semana
        TransactionModel(
          id: 'txn-007',
          type: 'withdrawal',
          amount: 1000.00,
          date: DateTime.now().subtract(const Duration(days: 7)),
          status: 'completed',
          description: 'Retiro a cuenta bancaria',
        ),
        // Venta fallida
        TransactionModel(
          id: 'txn-008',
          type: 'sale',
          amount: 120.00,
          date: DateTime.now().subtract(const Duration(days: 8)),
          status: 'failed',
          orderId: 'ORD-006',
          productName: 'Pago rechazado',
          description: 'Venta fallida - pago rechazado',
        ),
      ];

  /// Transacciones solo de ventas
  static List<TransactionModel> get salesOnly =>
      sampleTransactions.where((t) => t.type == 'sale' && t.status == 'completed').toList();

  /// Transacciones solo de retiros
  static List<TransactionModel> get withdrawalsOnly => sampleTransactions.where((t) => t.type == 'withdrawal').toList();

  /// Transacciones pendientes
  static List<TransactionModel> get pendingTransactions =>
      sampleTransactions.where((t) => t.status == 'pending').toList();

  /// Generar transacciones aleatorias
  static List<TransactionModel> generateRandomTransactions(int count) {
    final List<TransactionModel> transactions = [];
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count; i++) {
      final type = ['sale', 'withdrawal', 'refund'][(random + i) % 3];
      final status = ['completed', 'pending', 'failed'][(random + i) % 3];
      final amount = 50.0 + ((random + i) % 500);

      transactions.add(
        TransactionModel(
          id: 'txn-random-$i',
          type: type,
          amount: amount,
          date: DateTime.now().subtract(Duration(days: i)),
          status: status,
          orderId: type == 'sale' ? 'ORD-${1000 + i}' : null,
          productName: type == 'sale' ? 'Producto ${i + 1}' : null,
          description: _getDescription(type),
        ),
      );
    }

    return transactions;
  }

  static String _getDescription(String type) {
    switch (type) {
      case 'sale':
        return 'Venta de producto';
      case 'withdrawal':
        return 'Retiro a cuenta bancaria';
      case 'refund':
        return 'Reembolso por devolución';
      default:
        return 'Transacción';
    }
  }

  /// Wallet con muchas transacciones (para testing de scroll)
  static WalletModel get walletWithManyTransactions => WalletModel(
        balance: 15000.00,
        totalEarnings: 25000.00,
        pendingEarnings: 500.00,
        transactions: generateRandomTransactions(50),
      );

  /// Wallet con balance alto
  static WalletModel get richWallet => WalletModel(
        balance: 50000.00,
        totalEarnings: 100000.00,
        pendingEarnings: 2500.00,
        transactions: sampleTransactions,
      );

  /// Wallet con balance bajo
  static WalletModel get lowBalanceWallet => WalletModel(
        balance: 25.50,
        totalEarnings: 500.00,
        pendingEarnings: 0.00,
        transactions: [
          TransactionModel(
            id: 'low-1',
            type: 'withdrawal',
            amount: 450.00,
            date: DateTime.now().subtract(const Duration(hours: 1)),
            status: 'completed',
            description: 'Retiro reciente',
          ),
          TransactionModel(
            id: 'low-2',
            type: 'sale',
            amount: 25.50,
            date: DateTime.now().subtract(const Duration(hours: 3)),
            status: 'completed',
            orderId: 'ORD-LOW-001',
            productName: 'Pequeña venta',
            description: 'Venta menor',
          ),
        ],
      );
}
