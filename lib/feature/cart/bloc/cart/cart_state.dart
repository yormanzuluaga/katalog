part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<Product>? listSale;
  final String sumTotal;

  const CartState({
    this.listSale,
    this.sumTotal = '0.0',
  });

  CartState copyWith({
    List<Product>? listSale,
    String? sumTotal,
    bool clearListSale = false,
  }) {
    return CartState(
      listSale: clearListSale ? null : (listSale ?? this.listSale),
      sumTotal: sumTotal ?? this.sumTotal,
    );
  }

  @override
  List<Object?> get props => [listSale, sumTotal];
}
