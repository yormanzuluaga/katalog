import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:api_helper/api_helper.dart';
import 'package:talentpitch_test/feature/wallet/widget/wallet_balance_card.dart';
import 'package:talentpitch_test/feature/wallet/widget/transaction_items.dart';

class WalletMobile extends StatefulWidget {
  const WalletMobile({Key? key}) : super(key: key);

  @override
  State<WalletMobile> createState() => _WalletMobileState();
}

class _WalletMobileState extends State<WalletMobile> {
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
    ],
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Recargar datos
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            WalletBalanceCard(
              balance: wallet.balance,
              totalEarnings: wallet.totalEarnings,
              pendingEarnings: wallet.pendingEarnings,
            ),
            const SizedBox(height: 24),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Retirar',
                    color: const Color(0xFF667eea),
                    onTap: () => _showWithdrawDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.shopping_bag,
                    label: 'Pedidos',
                    color: const Color(0xFF764ba2),
                    onTap: () {
                      // Navegar a pedidos
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Lista de transacciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Movimientos Recientes',
                  style: TextStyle(
                    fontSize: 20,
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
            const SizedBox(height: 16),

            if (wallet.transactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 64,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
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

  void _showWithdrawDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Retirar Ganancias',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance disponible: \$${wallet.balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 8),
            Text(
              'Nota: El retiro puede tardar 2-3 días hábiles',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Procesar retiro
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitud de retiro enviada'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retirar'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalle de Transacción',
              style: TextStyle(
                fontSize: 20,
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
