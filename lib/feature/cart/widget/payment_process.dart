import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class PaymentProcess extends StatefulWidget {
  final int totalItems;
  final int totalPriceCop;

  const PaymentProcess({
    super.key,
    this.totalItems = 0,
    this.totalPriceCop = 0,
  });

  @override
  State<PaymentProcess> createState() => _PaymentProcessState();
}

class _PaymentProcessState extends State<PaymentProcess> {
  String? selectedMethod;

  final _methods = const <_Method>[
    _Method('Tarjeta de crédito / débito', Icons.credit_card),
    _Method('Cuentas bancarias (PSE)', Icons.account_balance),
    _Method('Billetera digital', Icons.account_balance_wallet_outlined),
    _Method('Efectivo', Icons.payments_outlined),
    _Method('SafetyPay', Icons.shield_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.secondary,
        title: Text('Proceso de pago', style: APTextStyle.textLG.bold),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Carrito', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.totalItems} ${widget.totalItems == 1 ? 'ítem' : 'ítems'}',
                          style: APTextStyle.textLG.bold,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text(
                        currency.format(widget.totalPriceCop),
                        style: APTextStyle.textXL.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- Título métodos ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Selecciona el método de pago', style: APTextStyle.textMD.semibold),
            ),
          ),

          // --- Lista de métodos ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _methods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final m = _methods[i];
                final active = m.name == selectedMethod;

                return InkWell(
                  onTap: () => setState(() => selectedMethod = m.name),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: active ? AppColors.secondary : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(m.icon, size: 28, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(m.name, style: TextStyle()),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Footer con total + botón ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Total', style: TextStyle(color: Colors.grey[700])),
                    const Spacer(),
                    Text(
                      currency.format(widget.totalPriceCop),
                      style: APTextStyle.textLG.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minWidth: double.infinity,
                  elevation: 0,
                  height: 56,
                  color: AppColors.secondary,
                  onPressed: selectedMethod == null
                      ? null
                      : () {
                          // aquí inicia el flujo real (ePayco/lo que uses).
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Método: $selectedMethod — ${currency.format(widget.totalPriceCop)}'),
                            ),
                          );
                        },
                  child: Text(
                    selectedMethod == null ? 'Selecciona un método' : 'Continuar',
                    style: APTextStyle.textMD.bold.copyWith(color: AppColors.whitePure),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Method {
  final String name;
  final IconData icon;
  const _Method(this.name, this.icon);
}
