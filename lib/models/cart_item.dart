import 'product.dart';

/// Sepet Öğesi Modeli (Cart Item Model)
///
/// Bir ürünün sepetteki durumunu temsil eder.
/// Ürün bilgisi ve adet sayısını içerir.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Toplam fiyat (adet × birim fiyat)
  double get totalPrice => product.price * quantity;

  /// Formatlı toplam fiyat
  String get formattedTotal => '\$${totalPrice.toStringAsFixed(2)}';
}
