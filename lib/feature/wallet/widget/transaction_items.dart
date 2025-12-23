import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:api_helper/api_helper.dart';

class TransactionItems extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionItems({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (transaction.productName != null)
                    Text(
                      transaction.productName!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm')
                            .format(transaction.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${transaction.type == 'withdrawal' ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: transaction.type == 'withdrawal'
                    ? Colors.red[600]
                    : Colors.green[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color color;

    switch (transaction.type) {
      case 'sale':
        icon = Icons.shopping_bag;
        color = Colors.green;
        break;
      case 'withdrawal':
        icon = Icons.account_balance_wallet;
        color = Colors.blue;
        break;
      case 'refund':
        icon = Icons.replay;
        color = Colors.orange;
        break;
      default:
        icon = Icons.attach_money;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;

    switch (transaction.status) {
      case 'completed':
        color = Colors.green;
        text = 'Completado';
        break;
      case 'pending':
        color = Colors.orange;
        text = 'Pendiente';
        break;
      case 'failed':
        color = Colors.red;
        text = 'Fallido';
        break;
      default:
        color = Colors.grey;
        text = transaction.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
