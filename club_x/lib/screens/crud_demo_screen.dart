import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Complete CRUD Demo Screen
/// Demonstrates Create, Read, Update, Delete operations with Firestore
/// Restricted to authenticated users with user-specific data
class CrudDemoScreen extends StatefulWidget {
  const CrudDemoScreen({super.key});

  @override
  State<CrudDemoScreen> createState() => _CrudDemoScreenState();
}

class _CrudDemoScreenState extends State<CrudDemoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String? _errorMessage;

  /// Get reference to user's items collection
  CollectionReference get _itemsCollection {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('items');
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    if (_auth.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Demo'),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(
          child: Text(
            'Please sign in first to use CRUD operations',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items - CRUD Demo'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'About CRUD',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : () => _openCreateDialog(),
        backgroundColor: _isLoading ? Colors.grey : Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // User info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.shade50,
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'User: ${_auth.currentUser!.email ?? "Unknown"}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Error message banner
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _errorMessage = null),
                  ),
                ],
              ),
            ),
          
          // Loading indicator
          if (_isLoading)
            const LinearProgressIndicator(),
          
          // Items list
          Expanded(
            child: _buildItemsList(),
          ),
        ],
      ),
    );
  }

  /// Build the items list with StreamBuilder for real-time updates
  Widget _buildItemsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _itemsCollection.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No items yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to create your first item',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        // Data state - display items
        final docs = snapshot.data!.docs;
        
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final itemId = doc.id;
            
            final title = data['title'] ?? 'Untitled';
            final description = data['description'] ?? '';
            final createdAt = data['createdAt'] as int?;
            final updatedAt = data['updatedAt'] as int?;
            
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    title.isNotEmpty ? title[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(description),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(updatedAt ?? createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openUpdateDialog(itemId, title, description),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(itemId, title),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                isThreeLine: description.isNotEmpty,
              ),
            );
          },
        );
      },
    );
  }

  /// CREATE OPERATION
  /// Opens dialog to create a new item
  void _openCreateDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Item'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _createItem(
                  titleController.text.trim(),
                  descController.text.trim(),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// CREATE OPERATION - Execute
  Future<void> _createItem(String title, String description) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _itemsCollection.add({
        'title': title,
        'description': description,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Created: $title'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to create item: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// UPDATE OPERATION
  /// Opens dialog to update an existing item
  void _openUpdateDialog(String itemId, String currentTitle, String currentDesc) {
    final titleController = TextEditingController(text: currentTitle);
    final descController = TextEditingController(text: currentDesc);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Item'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _updateItem(
                  itemId,
                  titleController.text.trim(),
                  descController.text.trim(),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  /// UPDATE OPERATION - Execute
  Future<void> _updateItem(String itemId, String newTitle, String newDesc) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _itemsCollection.doc(itemId).update({
        'title': newTitle,
        'description': newDesc,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Updated: $newTitle'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to update item: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// DELETE OPERATION
  /// Confirms deletion with user
  void _confirmDelete(String itemId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(itemId, title);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// DELETE OPERATION - Execute
  Future<void> _deleteItem(String itemId, String title) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _itemsCollection.doc(itemId).delete();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Deleted: $title'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to delete item: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Show info dialog explaining CRUD operations
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CRUD Operations'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This screen demonstrates:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('✓ CREATE: Add new items with + button'),
              Text('✓ READ: View items in real-time'),
              Text('✓ UPDATE: Edit items with edit icon'),
              Text('✓ DELETE: Remove items with delete icon'),
              SizedBox(height: 12),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• User-specific data (users/{uid}/items)'),
              Text('• Real-time sync with StreamBuilder'),
              Text('• Input validation'),
              Text('• Error handling'),
              Text('• Loading states'),
              Text('• Confirmation dialogs'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  /// Format timestamp for display
  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown time';
    
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
