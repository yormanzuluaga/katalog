import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/bloc/address/address_bloc.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AddressSelectionScreen extends StatefulWidget {
  final int totalItems;
  final int totalPriceCop;

  const AddressSelectionScreen({
    super.key,
    required this.totalItems,
    required this.totalPriceCop,
  });

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las direcciones del usuario al inicializar
    context.read<AddressBloc>().add(LoadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryMain,
            ),
          );
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.redyMain,
                ),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage!,
                  style: APTextStyle.textMD.medium.copyWith(
                    color: AppColors.redyMain,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AppButton.primary(
                  onPressed: () {
                    context.read<AddressBloc>().add(LoadAddresses());
                  },
                  title: 'Reintentar',
                ),
              ],
            ),
          );
        }

        final addresses = state.addressModel?.addresses ?? [];

        // Si no hay direcciones, mostrar opción para crear una nueva
        if (addresses.isEmpty) {
          return _buildNoAddressesView();
        }

        // Si hay direcciones, mostrar lista para seleccionar
        return _buildAddressListView(addresses, state.selectedAddress);
      },
    );
  }

  Widget _buildNoAddressesView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 100,
            color: AppColors.primaryMain.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes direcciones guardadas',
            style: APTextStyle.textXL.bold.copyWith(
              color: AppColors.secondaryDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Agrega tu primera dirección de envío para continuar con tu pedido',
            style: APTextStyle.textMD.regular.copyWith(
              color: AppColors.gray100,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppButton.primary(
            onPressed: () {
              _navigateToAddAddress();
            },
            title: 'Agregar Dirección',
          ),
        ],
      ),
    );
  }

  Widget _buildAddressListView(List<Address> addresses, Address? selectedAddress) {
    return Column(
      children: [
        // Resumen del pedido
        _buildOrderSummary(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecciona una dirección:',
                  style: APTextStyle.textLG.bold.copyWith(
                    color: AppColors.secondaryDark,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: ListView.separated(
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isSelected = selectedAddress?.id == address.id;

                      return _buildAddressCard(address, isSelected);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Botón para agregar nueva dirección
                OutlinedButton.icon(
                  onPressed: () {
                    _navigateToAddAddress();
                  },
                  icon: const Icon(Icons.add, color: AppColors.primaryMain),
                  label: Text(
                    'Agregar nueva dirección',
                    style: APTextStyle.textMD.medium.copyWith(
                      color: AppColors.primaryMain,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryMain),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón continuar (solo si hay dirección seleccionada)
                if (selectedAddress != null)
                  AppButton.primary(
                    onPressed: () {
                      _continueWithSelectedAddress(selectedAddress);
                    },
                    title: 'Continuar con esta dirección',
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu pedido',
                style: APTextStyle.textSM.medium.copyWith(
                  color: AppColors.gray100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.totalItems} ${widget.totalItems == 1 ? 'artículo' : 'artículos'}',
                style: APTextStyle.textLG.bold.copyWith(
                  color: AppColors.secondaryDark,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: APTextStyle.textSM.medium.copyWith(
                  color: AppColors.gray100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${addDotsToNumber(widget.totalPriceCop)}',
                style: APTextStyle.textXL.bold.copyWith(
                  color: AppColors.primaryMain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Address address, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<AddressBloc>().add(SelectAddress(address: address));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whitePure,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryMain : AppColors.gray50,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryMain.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            else
              BoxShadow(
                color: AppColors.gray50.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          children: [
            // Icono de selección
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryMain : AppColors.whitePure,
                border: Border.all(
                  color: isSelected ? AppColors.primaryMain : AppColors.gray100,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.whitePure,
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Información de la dirección
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (address.title != null) ...[
                    Text(
                      address.title!,
                      style: APTextStyle.textMD.bold.copyWith(
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (address.fullName != null) ...[
                    Text(
                      address.fullName!,
                      style: APTextStyle.textSM.medium.copyWith(
                        color: AppColors.gray100,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  if (address.address != null) ...[
                    Text(
                      address.address!,
                      style: APTextStyle.textSM.regular.copyWith(
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Row(
                    children: [
                      if (address.city != null) ...[
                        Text(
                          address.city!,
                          style: APTextStyle.textSM.regular.copyWith(
                            color: AppColors.gray100,
                          ),
                        ),
                        if (address.state != null) ...[
                          Text(
                            ', ${address.state}',
                            style: APTextStyle.textSM.regular.copyWith(
                              color: AppColors.gray100,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                  if (address.phone != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Tel: ${address.phone}',
                      style: APTextStyle.textXS.regular.copyWith(
                        color: AppColors.gray100,
                      ),
                    ),
                  ],
                  if (address.isDefault == true) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryMain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Dirección principal',
                        style: APTextStyle.textXS.medium.copyWith(
                          color: AppColors.primaryMain,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Botón de opciones
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.gray100,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: AppColors.primaryMain, size: 20),
                      const SizedBox(width: 8),
                      Text('Editar', style: APTextStyle.textSM.medium),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: AppColors.redyMain, size: 20),
                      const SizedBox(width: 8),
                      Text('Eliminar', style: APTextStyle.textSM.medium),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _navigateToEditAddress(address);
                    break;
                  case 'delete':
                    _showDeleteConfirmation(address);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddAddress() {
    // Implementar navegación para agregar nueva dirección
    // Por ahora, podemos usar el formulario existente
    context.push('/form-payment', extra: {
      'totalItems': widget.totalItems,
      'totalPriceCop': widget.totalPriceCop,
      'isAddingAddress': true,
    });
  }

  void _navigateToEditAddress(Address address) {
    // Implementar navegación para editar dirección existente
    context.push('/form-payment', extra: {
      'totalItems': widget.totalItems,
      'totalPriceCop': widget.totalPriceCop,
      'editingAddress': address,
    });
  }

  void _continueWithSelectedAddress(Address address) {
    // Obtener los items del carrito
    final cartState = context.read<CartBloc>().state;
    final cartItems = cartState.listSale ?? [];

    print('🛒 Items del carrito para transacción: ${cartItems.length}');

    // Continuar al proceso de pago con Wompi
    context.push(RoutesNames.wompiPayment, extra: {
      'selectedAddress': address,
      'totalItems': widget.totalItems,
      'totalPriceCop': widget.totalPriceCop.toDouble(),
      'customerEmail': 'customer@example.com', // TODO: obtener del usuario loggeado
      'customerName': 'Cliente', // TODO: obtener del usuario loggeado
      'customerPhone': '3001234567', // TODO: obtener del usuario loggeado
      'shippingAddressId': address.id ?? '',
      'cartItems': cartItems,
    });
  }

  void _showDeleteConfirmation(Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar Dirección',
            style: APTextStyle.textLG.bold,
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar esta dirección?',
            style: APTextStyle.textMD.regular,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: APTextStyle.textMD.medium.copyWith(
                  color: AppColors.gray100,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AddressBloc>().add(DeleteAddress(id: address.id!));
              },
              child: Text(
                'Eliminar',
                style: APTextStyle.textMD.bold.copyWith(
                  color: AppColors.redyMain,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
