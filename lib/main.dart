import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'theme/app_theme.dart';

/// Mini Katalog Uygulaması
/// Flutter Eğitim Projesi - Haftalık Eğitim Çıktısı
///
/// Bu uygulama; widget yapısı, sayfa geçişleri, temel UI tasarımı,
/// veri modeli oluşturma ve proje klasörleme mantığını göstermektedir.
void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Named Routes tanımlaması
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/products': (context) => const ProductListScreen(),
        '/cart': (context) => const CartScreen(),
      },

      // Dinamik route (ürün detay sayfası için)
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: args['productId'] as int,
            ),
          );
        }
        return null;
      },
    );
  }
}
