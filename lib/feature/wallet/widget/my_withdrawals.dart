import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/wallet/bloc/my_withdrawals/my_withdrawals_bloc.dart';
import 'package:talentpitch_test/injection/injection_container.dart';
import 'package:intl/intl.dart';
import 'package:api_helper/api_helper.dart';

class MyWithdrawals extends StatelessWidget {
  const MyWithdrawals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MyWithdrawalsBloc>()..add(const LoadMyWithdrawals()),
      child: BlocBuilder<MyWithdrawalsBloc, MyWithdrawalsState>(
        builder: (context, state) {
          if (state is MyWithdrawalsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MyWithdrawalsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<MyWithdrawalsBloc>()
                            .add(const RefreshMyWithdrawals());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MyWithdrawalsLoaded) {
            if (state.withdrawals.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No tienes retiros',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aún no has solicitado ningún retiro',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<MyWithdrawalsBloc>()
                    .add(const RefreshMyWithdrawals());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.withdrawals.length,
                itemBuilder: (context, index) {
                  final withdrawal = state.withdrawals[index];
                  return _WithdrawalCard(withdrawal: withdrawal);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _WithdrawalCard extends StatelessWidget {
  final MyWithdrawal withdrawal;

  const _WithdrawalCard({required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final dateStr = withdrawal.createdAt.isNotEmpty
        ? formatter.format(DateTime.parse(withdrawal.createdAt))
        : 'N/A';

    Color statusColor;
    IconData statusIcon;

    switch (withdrawal.status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'pending':
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showWithdrawalDetail(context, withdrawal),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFF667eea),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                withdrawal.withdrawalMethod.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateStr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          withdrawal.statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Monto',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${_formatNumber(withdrawal.amount.toInt())}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF667eea),
                    ),
                  ),
                ],
              ),
              if (withdrawal.accountInfo != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.account_balance,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        withdrawal.accountInfo!.accountHolder,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
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

  void _showWithdrawalDetail(BuildContext context, MyWithdrawal withdrawal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
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
              const Text(
                'Detalle del Retiro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Monto',
                        '\$${_formatNumber(withdrawal.amount.toInt())}'),
                    _buildDetailRow('Estado', withdrawal.statusLabel),
                    _buildDetailRow(
                        'Método', withdrawal.withdrawalMethod.toUpperCase()),
                    _buildDetailRow(
                      'Fecha de solicitud',
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(withdrawal.createdAt)),
                    ),
                    if (withdrawal.accountInfo != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Información de la cuenta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          'Titular', withdrawal.accountInfo!.accountHolder),
                      _buildDetailRow('Banco', withdrawal.accountInfo!.bank),
                      if (withdrawal.accountInfo!.accountNumber != null)
                        _buildDetailRow('Número de cuenta',
                            withdrawal.accountInfo!.accountNumber!),
                      if (withdrawal.accountInfo!.accountType != null)
                        _buildDetailRow('Tipo de cuenta',
                            withdrawal.accountInfo!.accountType!),
                      if (withdrawal.accountInfo!.phone != null)
                        _buildDetailRow(
                            'Teléfono', withdrawal.accountInfo!.phone!),
                    ],
                    if (withdrawal.rejectionReason != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Motivo de cancelación',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              withdrawal.rejectionReason!,
                              style: TextStyle(color: Colors.red[900]),
                            ),
                          ],
                        ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
