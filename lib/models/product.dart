/// Ürün Modeli (Product Model)
///
/// JSON verisini Dart nesnesine dönüştürmek için kullanılır.
/// fromJson ve toJson metotları ile JSON serileştirme/deserileştirme yapılır.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String currency;
  final String image;
  final String category;
  final Map<String, String> specs;

  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.category,
    required this.specs,
  });

  /// JSON'dan Product nesnesi oluşturma (Deserialization)
  /// API veya yerel JSON dosyasından gelen veriyi Dart nesnesine dönüştürür.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as double),
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'Genel',
      specs: json['specs'] != null
          ? Map<String, String>.from(
              (json['specs'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
    );
  }

  /// Product nesnesini JSON'a dönüştürme (Serialization)
  /// Veriyi API'ye göndermek veya yerel olarak saklamak için kullanılır.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'category': category,
      'specs': specs,
    };
  }

  /// Fiyatı formatlı string olarak döndürür
  String get formattedPrice => '\$$price';

  @override
  String toString() => 'Product(id: $id, name: $name, price: $formattedPrice)';
}
