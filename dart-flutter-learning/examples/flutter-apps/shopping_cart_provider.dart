// Shopping Cart Provider – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/shopping-cart-provider/
// Use as lib/main.dart after: flutter pub add provider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ---------- Data ----------
class Product {
  const Product(this.id, this.name, this.price, this.icon);
  final int id;
  final String name;
  final double price;
  final IconData icon;
}

const products = [
  Product(1, 'Coffee', 3.50, Icons.coffee),
  Product(2, 'Headphones', 59.00, Icons.headphones),
  Product(3, 'Backpack', 34.90, Icons.backpack),
  Product(4, 'Book', 12.00, Icons.menu_book),
  Product(5, 'Watch', 120.00, Icons.watch),
  Product(6, 'Camera', 249.00, Icons.photo_camera),
];

// ---------- State ----------
class CartModel extends ChangeNotifier {
  final Map<Product, int> _items = {}; // product -> quantity

  Map<Product, int> get items => Map.unmodifiable(_items);
  int get count => _items.values.fold(0, (sum, q) => sum + q);
  double get total => _items.entries.fold(0.0, (sum, e) => sum + e.key.price * e.value);
  int quantityOf(Product p) => _items[p] ?? 0;

  void add(Product p) {
    _items[p] = quantityOf(p) + 1;
    notifyListeners();
  }

  void removeOne(Product p) {
    final q = quantityOf(p);
    if (q <= 1) {
      _items.remove(p);
    } else {
      _items[p] = q - 1;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ---------- App ----------
void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => CartModel(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: const ShopPage(),
    ),
  ));
}

String money(double v) => '\$${v.toStringAsFixed(2)}';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
            icon: Badge(
              label: Text('${context.watch<CartModel>().count}'),
              isLabelVisible: context.watch<CartModel>().count > 0,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) => ProductCard(product: products[i]),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    // select: rebuild only when THIS product's quantity changes
    final qty = context.select<CartModel, int>((cart) => cart.quantityOf(product));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(child: Icon(product.icon, size: 56)),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(money(product.price)),
            const SizedBox(height: 8),
            qty == 0
                ? FilledButton(
                    onPressed: () => context.read<CartModel>().add(product),
                    child: const Text('Add'),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.outlined(
                        onPressed: () => context.read<CartModel>().removeOne(product),
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('$qty', style: const TextStyle(fontSize: 18)),
                      ),
                      IconButton.filled(
                        onPressed: () => context.read<CartModel>().add(product),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final entries = cart.items.entries.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: entries.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView(
              children: [
                for (final e in entries)
                  ListTile(
                    leading: Icon(e.key.icon),
                    title: Text(e.key.name),
                    subtitle: Text('${e.value} × ${money(e.key.price)}'),
                    trailing: Text(money(e.key.price * e.value),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Total: ${money(cart.total)}', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              FilledButton(
                onPressed: entries.isEmpty
                    ? null
                    : () {
                        cart.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Order placed! Thank you.')));
                      },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
