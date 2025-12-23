import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_helper/api_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/wallet/widget/wallet_balance_card.dart';
import 'package:talentpitch_test/feature/wallet/widget/withdraw_dialog.dart';
import 'package:talentpitch_test/feature/wallet/bloc/balance/balance_bloc.dart';
import 'package:talentpitch_test/feature/wallet/bloc/shipping_orders/shipping_orders_bloc.dart';
import 'package:talentpitch_test/feature/wallet/bloc/wallet_bloc.dart';
import 'package:talentpitch_test/injection/injection_container.dart';
import 'package:intl/intl.dart';

class WalletMobile extends StatefulWidget {
  const WalletMobile({Key? key}) : super(key: key);

  @override
  State<WalletMobile> createState() => _WalletMobileState();
}

class _WalletMobileState extends State<WalletMobile> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<BalanceBloc>()..add(const LoadBalance()),
        ),
        BlocProvider(
          create: (context) =>
              sl<ShippingOrdersBloc>()..add(const LoadMyOrders()),
        ),
        BlocProvider(
          create: (context) => sl<WalletBloc>(),
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<BalanceBloc>().add(const LoadBalance());
          context.read<ShippingOrdersBloc>().add(const LoadMyOrders());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card - Consumiendo API real
              BlocBuilder<BalanceBloc, BalanceState>(
                builder: (context, state) {
                  if (state is BalanceLoading) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  if (state is BalanceError) {
                    return Container(
                      height: 200,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (state is BalanceLoaded) {
                    final balance = state.balance;
                    return WalletBalanceCard(
                      balance: balance.balance,
                      totalEarnings: balance.totalEarned,
                      pendingEarnings: balance.pendingBalance,
                      points: balance.points,
                    );
                  }

                  return const SizedBox();
                },
              ),
              const SizedBox(height: 24),

              // Botones de acción
              BlocBuilder<BalanceBloc, BalanceState>(
                builder: (context, state) {
                  if (state is BalanceLoaded) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.account_balance_wallet,
                            label: 'Retirar',
                            color: const Color(0xFF667eea),
                            onTap: () => _showWithdrawDialog(context,
                                balance: state.balance.balance.toDouble()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.shopping_bag,
                            label: 'Ver Retiros',
                            color: const Color(0xFF764ba2),
                            onTap: () {
                              context.push(RoutesNames.myWithdrawals);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 32),

              // Lista de pedidos - Consumiendo API real
              const Text(
                'Mis Pedidos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              BlocBuilder<ShippingOrdersBloc, ShippingOrdersState>(
                builder: (context, state) {
                  if (state is ShippingOrdersLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is ShippingOrdersError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline,
                                size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ShippingOrdersLoaded) {
                    if (state.orders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay pedidos aún',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: state.orders
                          .map((order) => _buildOrderCard(order))
                          .toList(),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(ShippingOrder order) {
    final formatter = DateFormat('dd/MM/yyyy');
    final dateStr = order.createdAt.isNotEmpty
        ? formatter.format(DateTime.parse(order.createdAt))
        : 'N/A';

    Color statusColor;
    switch (order.status) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderDetail(context, order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${order.items.length} producto(s)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${_formatNumber(order.totalAmount.toInt())}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667eea),
                    ),
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              if (order.commission.amount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.attach_money,
                        size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Comisión: \$${_formatNumber(order.commission.amount.toInt())}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.stars, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${order.commission.points} pts',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
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

  void _showWithdrawDialog(BuildContext context, {required double balance}) {
    double availableBalance = 0.0;
    availableBalance = balance;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<WalletBloc>()),
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

  void _showOrderDetail(BuildContext context, ShippingOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              const SizedBox(height: 20),
              Text(
                'Pedido ${order.orderNumber}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                order.statusLabel,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Productos:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: item.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.image!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              )
                            : null,
                        title: Text(item.name),
                        subtitle: Text('Cantidad: ${item.quantity}'),
                        trailing: Text(
                          '\$${_formatNumber(item.totalPrice.toInt())}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${_formatNumber(order.totalAmount.toInt())}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667eea),
                          ),
                        ),
                      ],
                    ),
                    if (order.commission.amount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tu comisión:'),
                          Text(
                            '\$${_formatNumber(order.commission.amount.toInt())}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Retiro Solicitado!',
                style: TextStyle(
                  fontSize: 24,
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
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'El proceso de retiro puede demorar hasta 48 horas hábiles',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
