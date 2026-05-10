import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final items = _cartService.items;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.lightBackground,
        title: const Text('Cart'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppTheme.textPrimary),
              SizedBox(width: 4),
            ],
          ),
        ),
        leadingWidth: 80,
      ),
      body: items.isEmpty ? _buildEmptyCart() : _buildCartContent(items),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 24),
          const Text('Your cart is empty', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(List items) {
    return Column(
      children: [
        // Items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;
              return Row(
                children: [
                  // Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.tagline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Quantity or Remove Button (as seen in mockup, a minus icon)
                  GestureDetector(
                    onTap: () {
                      _cartService.removeFromCart(product.id);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: const Icon(Icons.remove, size: 20, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        // Bottom Area (Checkout)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.lightBackground,
            border: Border(top: BorderSide(color: AppTheme.borderColor)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                    Text(_cartService.formattedTotalPrice, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _cartService.clearCart();
                      setState(() {});
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Your checkout simulation was successful.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                          ],
                        ),
                      );
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
