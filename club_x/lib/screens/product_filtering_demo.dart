import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFilteringDemo extends StatefulWidget {
  const ProductFilteringDemo({Key? key}) : super(key: key);

  @override
  State<ProductFilteringDemo> createState() => _ProductFilteringDemoState();
}

class _ProductFilteringDemoState extends State<ProductFilteringDemo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Filter state
  String _selectedStatus = 'all'; // all, inStock, outOfStock
  String _sortBy = 'name'; // name, price, rating
  bool _sortAscending = true;
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  // Initialize sample product data for demonstration
  void _initializeSampleData() async {
    try {
      final snapshot = await _firestore.collection('products').limit(1).get();
      if (snapshot.docs.isEmpty) {
        // Add sample data
        await _firestore.collection('products').add({
          'name': 'Laptop',
          'price': 999.99,
          'inStock': true,
          'rating': 4.5,
          'category': 'Electronics',
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _firestore.collection('products').add({
          'name': 'Mouse',
          'price': 29.99,
          'inStock': true,
          'rating': 4.2,
          'category': 'Electronics',
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _firestore.collection('products').add({
          'name': 'Keyboard',
          'price': 79.99,
          'inStock': false,
          'rating': 4.8,
          'category': 'Electronics',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  // Build dynamic query based on filters
  Query _buildQuery() {
    var query = _firestore.collection('products') as Query;

    // Apply status filter
    if (_selectedStatus == 'inStock') {
      query = query.where('inStock', isEqualTo: true);
    } else if (_selectedStatus == 'outOfStock') {
      query = query.where('inStock', isEqualTo: false);
    }

    // Apply price range filters
    if (_minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: _minPrice);
    }
    if (_maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: _maxPrice);
    }

    // Apply sorting
    query = query.orderBy(_sortBy, descending: !_sortAscending);

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Filter & Sort'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Controls Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Stock Status Filter
                  const Text(
                    'Stock Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(
                        'All',
                        'all',
                        _selectedStatus == 'all',
                        () {
                          setState(() => _selectedStatus = 'all');
                        },
                      ),
                      _buildFilterChip(
                        'In Stock',
                        'inStock',
                        _selectedStatus == 'inStock',
                        () {
                          setState(() => _selectedStatus = 'inStock');
                        },
                      ),
                      _buildFilterChip(
                        'Out of Stock',
                        'outOfStock',
                        _selectedStatus == 'outOfStock',
                        () {
                          setState(() => _selectedStatus = 'outOfStock');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sort By
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'name',
                              child: Text('Name'),
                            ),
                            DropdownMenuItem(
                              value: 'price',
                              child: Text('Price'),
                            ),
                            DropdownMenuItem(
                              value: 'rating',
                              child: Text('Rating'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _sortBy = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() => _sortAscending = !_sortAscending);
                        },
                        tooltip: _sortAscending ? 'Ascending' : 'Descending',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Results Section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Handle error state
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }

                // Handle empty state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final data = product.data() as Map<String, dynamic>;

                    return _buildProductCard(
                      data,
                      product.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    bool selected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: Colors.blue.shade200,
      side: BorderSide(
        color: selected ? Colors.blue : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data, String productId) {
    final name = data['name'] ?? 'Unknown';
    final price = data['price'] ?? 0.0;
    final inStock = data['inStock'] ?? false;
    final rating = data['rating'] ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Stock Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: inStock ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    inStock ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          inStock ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                // Rating
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Rating',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
