import '../models/product.dart';
import '../models/cart_item.dart';

/// Sepet Servisi (Cart Service)
///
/// Sepet yönetimi için basit state simülasyonu.
/// Gerçek uygulamada Provider, Riverpod veya Bloc kullanılabilir.
/// Burada eğitim amaçlı basit bir singleton pattern kullanılmaktadır.
class CartService {
  // Singleton pattern — tek bir CartService nesnesi tüm uygulamada kullanılır
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // Sepet öğeleri listesi
  final List<CartItem> _items = [];

  /// Sepetteki tüm öğeler (kopyası)
  List<CartItem> get items => List.unmodifiable(_items);

  /// Sepetteki toplam ürün adedi
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Sepetteki toplam fiyat
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Formatlı toplam fiyat
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Sepete ürün ekleme
  void addToCart(Product product) {
    // Ürün zaten sepette varsa adetini artır
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      // Yeni ürün ekle
      _items.add(CartItem(product: product));
    }
  }

  /// Sepetten ürün çıkarma
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  /// Ürün adedini güncelleme
  void updateQuantity(int productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  /// Sepeti temizleme
  void clearCart() {
    _items.clear();
  }

  /// Ürünün sepette olup olmadığını kontrol eder
  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Sepetteki ürünün adetini döndürür
  int getQuantity(int productId) {
    final item = _items.where((item) => item.product.id == productId);
    return item.isNotEmpty ? item.first.quantity : 0;
  }
}
