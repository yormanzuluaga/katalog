import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:api_helper/api_helper.dart';
import 'package:talentpitch_test/feature/wallet/widget/transaction_items.dart';
import 'package:talentpitch_test/feature/wallet/widget/withdraw_dialog.dart';
import 'package:talentpitch_test/feature/wallet/bloc/wallet_bloc.dart';
import 'package:talentpitch_test/feature/wallet/bloc/balance/balance_bloc.dart';
import 'package:talentpitch_test/injection/injection_container.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<BalanceBloc>()..add(const LoadBalance()),
        ),
        BlocProvider(
          create: (context) => sl<WalletBloc>(),
        ),
      ],
      child: Scaffold(
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
                          context.push(RoutesNames.myWithdrawals);
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
                        // WalletBalanceCard(
                        //   balance: wallet.balance,
                        //   totalEarnings: wallet.totalEarnings,
                        //   pendingEarnings: wallet.pendingEarnings,
                        //   points: wallet.points,
                        // ),
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
                                onTap: () => _showTransactionDetail(
                                    context, transaction),
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
    final balanceBloc = context.read<BalanceBloc>();
    final balanceState = balanceBloc.state;

    double availableBalance = 0.0;
    if (balanceState is BalanceLoaded) {
      availableBalance = balanceState.balance.balance.toDouble();
      print('Balance disponible: $availableBalance');
      print('Balance state: ${balanceState.balance.balance}');
    } else {
      print('Estado del balance: ${balanceState.runtimeType}');
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<WalletBloc>()),
          BlocProvider.value(value: balanceBloc),
        ],
        child: BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WithdrawalSuccess) {
              Navigator.pop(dialogContext);
              // Refresh balance after successful withdrawal
              context.read<BalanceBloc>().add(const LoadBalance());
              // Show success popup with info
              _showWithdrawalSuccessDialog(context, state.message);
            } else if (state is WithdrawalError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: WithdrawDialog(
            availableBalance: availableBalance,
            onSubmit: (request) {
              context.read<WalletBloc>().add(RequestWithdrawal(request));
            },
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(
      BuildContext context, TransactionModel transaction) {
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
              _buildDetailRow(
                  'Monto', '\$${transaction.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Estado', transaction.status),
              if (transaction.orderId != null)
                _buildDetailRow('Orden', transaction.orderId!),
              if (transaction.productName != null)
                _buildDetailRow('Producto', transaction.productName!),
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

  void _showWithdrawalSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '¡Retiro Solicitado!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'El proceso de retiro puede demorar hasta 48 horas hábiles',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Entendido',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
