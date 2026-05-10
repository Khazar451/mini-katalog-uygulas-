import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final CartService _cartService = CartService();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final products = await ProductService.loadProducts();
    final categories = await ProductService.getCategories();

    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _categories = categories;
      _isLoading = false;
    });

    _fadeController.forward();
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesCategory = _selectedCategory == 'Tümü' || product.category == _selectedCategory;
        final matchesSearch = _searchQuery.isEmpty ||
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.tagline.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _addToCart(Product product) {
    _cartService.addToCart(product);
    setState(() {}); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi!'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Header (Discover)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Discover',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Find your perfect device.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            // Cart Icon
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/cart').then((_) => setState(() {}));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightBackground,
                                  border: Border.all(color: AppTheme.borderColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Badge(
                                  isLabelVisible: _cartService.totalItems > 0,
                                  label: Text('${_cartService.totalItems}'),
                                  backgroundColor: AppTheme.primaryColor,
                                  child: const Icon(Icons.shopping_bag_outlined, color: AppTheme.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _searchQuery = value;
                            _filterProducts();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search products',
                            prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                    ),

                    // Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/banner.png',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 100,
                              color: AppTheme.lightSurface,
                              child: const Center(child: Text('GIFT STORE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppTheme.secondaryColor))),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Categories (Optional, hidden in mockup but keeping functionally small)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return ChoiceChip(
                              label: Text(category),
                              selected: _selectedCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _filterProducts();
                              },
                              backgroundColor: AppTheme.lightSurface,
                              selectedColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                color: _selectedCategory == category ? Colors.white : AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: BorderSide.none,
                            );
                          },
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Product Grid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.68,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = _filteredProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/product-detail',
                                  arguments: {'productId': product.id},
                                ).then((_) => setState(() {}));
                              },
                              onAddToCart: () => _addToCart(product),
                            );
                          },
                          childCount: _filteredProducts.length,
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
              ),
            ),
    );
  }
}

