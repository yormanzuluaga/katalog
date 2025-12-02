import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:api_helper/api_helper.dart';
import 'package:talentpitch_test/feature/wallet/widget/wallet_balance_card.dart';
import 'package:talentpitch_test/feature/wallet/widget/transaction_items.dart';

class WalletDesktop extends StatefulWidget {
  const WalletDesktop({Key? key}) : super(key: key);

  @override
  State<WalletDesktop> createState() => _WalletDesktopState();
}

class _WalletDesktopState extends State<WalletDesktop> {
  // Datos de ejemplo - reemplaza con datos reales de tu API
  final WalletModel wallet = WalletModel(
    balance: 2450.50,
    totalEarnings: 5230.75,
    pendingEarnings: 320.00,
    transactions: [
      TransactionModel(
        id: '1',
        type: 'sale',
        amount: 150.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'completed',
        orderId: 'ORD-001',
        productName: 'Producto Premium',
        description: 'Venta de producto',
      ),
      TransactionModel(
        id: '2',
        type: 'sale',
        amount: 89.99,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
        orderId: 'ORD-002',
        productName: 'Servicio de consultoría',
        description: 'Venta de servicio',
      ),
      TransactionModel(
        id: '3',
        type: 'withdrawal',
        amount: 500.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'pending',
        description: 'Retiro a cuenta bancaria',
      ),
      TransactionModel(
        id: '4',
        type: 'sale',
        amount: 225.50,
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: 'completed',
        orderId: 'ORD-003',
        productName: 'Curso online',
        description: 'Venta de curso',
      ),
      TransactionModel(
        id: '5',
        type: 'sale',
        amount: 75.00,
        date: DateTime.now().subtract(const Duration(days: 4)),
        status: 'completed',
        orderId: 'ORD-004',
        productName: 'Asesoría personalizada',
        description: 'Venta de asesoría',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTechnical,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mi Wallet',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Ver historial
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('Historial'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Recargar
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Actualizar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Balance and Actions
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Balance Card
                      WalletBalanceCard(
                        balance: wallet.balance,
                        totalEarnings: wallet.totalEarnings,
                        pendingEarnings: wallet.pendingEarnings,
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.account_balance_wallet,
                              label: 'Retirar Ganancias',
                              color: const Color(0xFF667eea),
                              onTap: () => _showWithdrawDialog(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.shopping_bag,
                              label: 'Ver Mis Pedidos',
                              color: const Color(0xFF764ba2),
                              onTap: () {
                                // Navegar a pedidos
                                Navigator.pushNamed(context, '/orders');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Statistics Card
                      _buildStatisticsCard(),
                    ],
                  ),
                ),

                const SizedBox(width: 32),

                // Right Column - Transactions
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Movimientos Recientes',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Ver todos
                              },
                              child: const Text('Ver todo'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (wallet.transactions.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(48),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay movimientos aún',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...wallet.transactions.map(
                            (transaction) => TransactionItems(
                              transaction: transaction,
                              onTap: () => _showTransactionDetail(context, transaction),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatRow(
            'Ventas completadas',
            '${wallet.transactions.where((t) => t.type == 'sale' && t.status == 'completed').length}',
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Retiros pendientes',
            '${wallet.transactions.where((t) => t.type == 'withdrawal' && t.status == 'pending').length}',
            Icons.pending,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Total transacciones',
            '${wallet.transactions.length}',
            Icons.receipt,
            const Color(0xFF667eea),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Retirar Ganancias',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Balance disponible: \$${wallet.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monto a retirar',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'El retiro puede tardar 2-3 días hábiles en procesarse',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Procesar retiro
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Solicitud de retiro enviada exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirmar Retiro'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detalle de Transacción',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('ID', transaction.id),
              _buildDetailRow('Tipo', transaction.type),
              _buildDetailRow('Monto', '\$${transaction.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Estado', transaction.status),
              if (transaction.orderId != null) _buildDetailRow('Orden', transaction.orderId!),
              if (transaction.productName != null) _buildDetailRow('Producto', transaction.productName!),
              _buildDetailRow('Descripción', transaction.description),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
