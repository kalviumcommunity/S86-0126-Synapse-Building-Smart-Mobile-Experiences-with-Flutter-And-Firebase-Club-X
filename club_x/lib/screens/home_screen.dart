import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_read_demo.dart';
import 'firebase_storage_upload_demo.dart';
import 'media_gallery_demo.dart';
import 'product_filtering_demo.dart';
import 'task_query_demo.dart';
import 'user_search_demo.dart';
import 'realtime_sync_demo.dart';
import 'realtime_document_sync.dart';

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
            tooltip: 'Logout',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 100),
                const SizedBox(height: 30),
                const Text(
                  'You are logged in!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                /// USER INFO CARD
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('User Information:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Divider(height: 20),

                        _infoRow(Icons.email, 'Email', user?.email ?? 'N/A'),
                        _infoRow(Icons.fingerprint, 'User ID', user?.uid ?? 'N/A'),
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

                const SizedBox(height: 40),

                _navButton(
                    context,
                    Icons.cloud_outlined,
                    'Firestore Read Demo',
                    const FirestoreReadDemo(),
                    Colors.blue),

                _navButton(
                    context,
                    Icons.upload_file,
                    'Firebase Storage Upload',
                    const FirebaseStorageUploadDemo(),
                    Colors.orange),

                _navButton(
                    context,
                    Icons.collections,
                    'Media Gallery',
                    const MediaGalleryDemo(),
                    Colors.green),

                _navButton(
                    context,
                    Icons.filter_list,
                    'Product Filtering & Sorting',
                    const ProductFilteringDemo(),
                    Colors.teal),

                _navButton(
                    context,
                    Icons.assignment,
                    'Advanced Task Queries',
                    const TaskQueryDemo(),
                    Colors.blueGrey),

                _navButton(
                    context,
                    Icons.person_search,
                    'User Search & Filters',
                    const UserSearchDemo(),
                    Colors.purple),

                _navButton(
                    context,
                    Icons.update,
                    'Real-Time Task Sync',
                    const RealtimeSyncDemo(),
                    Colors.indigo),

                _navButton(
                    context,
                    Icons.person_outline,
                    'Real-Time User Profile',
                    const RealtimeDocumentSync(),
                    Colors.redAccent),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// USER INFO ROW WIDGET
  Widget _infoRow(IconData icon, String label, String value,
      {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: TextStyle(
                        fontSize: 16,
                        color: valueColor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// NAVIGATION BUTTON WIDGET
  Widget _navButton(BuildContext context, IconData icon, String text,
      Widget page, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => page)),
          icon: Icon(icon),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            backgroundColor: color,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
