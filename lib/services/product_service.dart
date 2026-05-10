import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

/// Ürün Servisi (Product Service)
///
/// JSON verisini okuyup Product listesine dönüştürür.
/// Gerçek projede bu servis HTTP istekleri yapabilir,
/// burada eğitim amaçlı yerel JSON dosyasından veri okunmaktadır.
class ProductService {
  /// Tüm ürünleri yerel JSON dosyasından yükler
  static Future<List<Product>> loadProducts() async {
    try {
      // assets/data/products.json dosyasını oku
      final String jsonString =
          await rootBundle.loadString('assets/data/products.json');

      // JSON string'i Map'e çevir
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // 'data' anahtarından ürün listesini al
      final List<dynamic> productsJson = jsonData['data'] as List<dynamic>;

      // Her JSON nesnesini Product modeline dönüştür
      return productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Hata durumunda boş liste döndür
      print('Ürünler yüklenirken hata oluştu: $e');
      return [];
    }
  }

  /// Belirli bir kategoriye ait ürünleri filtreler
  static Future<List<Product>> getProductsByCategory(String category) async {
    final allProducts = await loadProducts();
    if (category == 'Tümü') return allProducts;
    return allProducts.where((p) => p.category == category).toList();
  }

  /// Ürün adına göre arama yapar
  static Future<List<Product>> searchProducts(String query) async {
    final allProducts = await loadProducts();
    final lowerQuery = query.toLowerCase();
    return allProducts
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.tagline.toLowerCase().contains(lowerQuery) ||
            p.category.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// ID'ye göre tek ürün getirir
  static Future<Product?> getProductById(int id) async {
    final allProducts = await loadProducts();
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mevcut kategorilerin listesini döndürür
  static Future<List<String>> getCategories() async {
    final allProducts = await loadProducts();
    final categories = allProducts.map((p) => p.category).toSet().toList();
    categories.insert(0, 'Tümü');
    return categories;
  }
}
