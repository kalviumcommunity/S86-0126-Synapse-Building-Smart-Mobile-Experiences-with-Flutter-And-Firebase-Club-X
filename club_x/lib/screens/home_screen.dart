import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Core demos
import 'firestore_read_demo.dart';

// Firestore queries & filters
import 'product_filtering_demo.dart';
import 'task_query_demo.dart';
import 'user_search_demo.dart';

// Realtime Firestore
import 'realtime_sync_demo.dart';
import 'realtime_document_sync.dart';

// Firebase Storage
import 'firebase_storage_upload_demo.dart';
import 'media_gallery_demo.dart';

// CRUD Demo
import 'crud_demo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.email ?? 'User'}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'You are logged in!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            /// USER INFO CARD
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _infoRow(Icons.email, 'Email', user?.email ?? 'N/A'),
                    _infoRow(Icons.fingerprint, 'UID', user?.uid ?? 'N/A'),
                    _infoRow(
                      Icons.verified_user,
                      'Email Verified',
                      user?.emailVerified == true ? 'Yes' : 'No',
                      valueColor: user?.emailVerified == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// DEMO BUTTONS
            _navButton(
              context,
              icon: Icons.create,
              label: 'Complete CRUD Demo',
              color: Colors.deepPurple,
              page: const CrudDemoScreen(),
            ),
            _navButton(
              context,
              icon: Icons.cloud_outlined,
              label: 'Firestore Read Demo',
              color: Colors.blue,
              page: const FirestoreReadDemo(),
            ),
            _navButton(
              context,
              icon: Icons.upload_file,
              label: 'Firebase Storage Upload',
              color: Colors.orange,
              page: const FirebaseStorageUploadDemo(),
            ),
            _navButton(
              context,
              icon: Icons.collections,
              label: 'Media Gallery',
              color: Colors.pink,
              page: const MediaGalleryDemo(),
            ),
            _navButton(
              context,
              icon: Icons.filter_list,
              label: 'Product Filtering & Sorting',
              color: Colors.teal,
              page: const ProductFilteringDemo(),
            ),
            _navButton(
              context,
              icon: Icons.assignment,
              label: 'Advanced Task Queries',
              color: Colors.green,
              page: const TaskQueryDemo(),
            ),
            _navButton(
              context,
              icon: Icons.update,
              label: 'Realtime Task Sync',
              color: Colors.indigo,
              page: const RealtimeSyncDemo(),
            ),
            _navButton(
              context,
              icon: Icons.person_search,
              label: 'User Search & Filters',
              color: Colors.purple,
              page: const UserSearchDemo(),
            ),
            _navButton(
              context,
              icon: Icons.person_outline,
              label: 'Realtime User Profile',
              color: Colors.deepPurple,
              page: const RealtimeDocumentSync(),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable UI helpers
  static Widget _navButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          },
        ),
      ),
    );
  }

  static Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: valueColor ?? Colors.black,
                    fontWeight:
                        valueColor != null ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
