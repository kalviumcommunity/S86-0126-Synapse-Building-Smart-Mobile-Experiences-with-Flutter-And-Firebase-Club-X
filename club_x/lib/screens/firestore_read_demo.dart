import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreReadDemo extends StatefulWidget {
  const FirestoreReadDemo({super.key});

  @override
  State<FirestoreReadDemo> createState() => _FirestoreReadDemoState();
}

class _FirestoreReadDemoState extends State<FirestoreReadDemo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedTab = 'messages';

  // Method to add sample data if collection is empty
  Future<void> _addSampleData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      
      // Add sample messages
      await _firestore.collection('messages').add({
        'senderId': user?.uid ?? 'sample_user',
        'senderName': user?.displayName ?? 'Demo User',
        'senderPhotoURL': user?.photoURL,
        'text': 'Welcome to Club-X! This is a sample message.',
        'createdAt': FieldValue.serverTimestamp(),
        'editedAt': null,
        'isEdited': false,
        'reactions': {
          'likes': 5,
          'hearts': 3,
          'celebrates': 2,
        },
        'replyTo': null,
        'metadata': {
          'platform': 'flutter',
          'appVersion': '1.0.0',
        },
      });

      await _firestore.collection('messages').add({
        'senderId': user?.uid ?? 'sample_user',
        'senderName': user?.displayName ?? 'Demo User',
        'senderPhotoURL': user?.photoURL,
        'text': 'Just completed the Widget Tree demo! 🚀',
        'createdAt': FieldValue.serverTimestamp(),
        'editedAt': null,
        'isEdited': false,
        'reactions': {
          'likes': 12,
          'hearts': 8,
          'celebrates': 5,
        },
        'replyTo': null,
        'metadata': {
          'platform': 'flutter',
          'appVersion': '1.0.0',
        },
      });

      // Add sample favorites
      if (user != null) {
        await _firestore.collection('favorites').add({
          'userId': user.uid,
          'itemType': 'demo',
          'itemId': 'widget_tree_demo',
          'itemTitle': 'Widget Tree & Reactive UI',
          'description': 'Interactive demonstration of Flutter widget hierarchy',
          'tags': ['widgets', 'basics', 'ui'],
          'addedAt': FieldValue.serverTimestamp(),
          'notes': 'Great for understanding Flutter fundamentals',
        });

        await _firestore.collection('favorites').add({
          'userId': user.uid,
          'itemType': 'lesson',
          'itemId': 'firebase_auth_101',
          'itemTitle': 'Firebase Authentication',
          'description': 'Complete guide to Firebase auth in Flutter',
          'tags': ['firebase', 'authentication', 'backend'],
          'addedAt': FieldValue.serverTimestamp(),
          'notes': 'Essential for production apps',
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sample data added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding sample data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Read Operations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Sample Data',
            onPressed: _addSampleData,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Info',
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selector
          Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton('Messages', 'messages', Icons.message),
                ),
                Expanded(
                  child: _buildTabButton('Favorites', 'favorites', Icons.favorite),
                ),
                Expanded(
                  child: _buildTabButton('Single Doc', 'single', Icons.description),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: _buildSelectedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String value, IconData icon) {
    final isSelected = _selectedTab == value;
    return InkWell(
      onTap: () => setState(() => _selectedTab = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedTab) {
      case 'messages':
        return _buildMessagesStream();
      case 'favorites':
        return _buildFavoritesQuery();
      case 'single':
        return _buildSingleDocRead();
      default:
        return const Center(child: Text('Select a tab'));
    }
  }

  // StreamBuilder Example: Real-time Messages Collection
  Widget _buildMessagesStream() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              Icon(Icons.stream, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Real-Time Stream (StreamBuilder)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Updates automatically when data changes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading messages...'),
                    ],
                  ),
                );
              }

              // Handle error state
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
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
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + icon to add sample data',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Display messages
              final messages = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final data = message.data() as Map<String, dynamic>;
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          (data['senderName'] as String?)?.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        data['senderName'] ?? 'Unknown User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(data['text'] ?? ''),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildReactionChip(
                                Icons.thumb_up,
                                data['reactions']?['likes'] ?? 0,
                                Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              _buildReactionChip(
                                Icons.favorite,
                                data['reactions']?['hearts'] ?? 0,
                                Colors.red,
                              ),
                              const SizedBox(width: 8),
                              _buildReactionChip(
                                Icons.celebration,
                                data['reactions']?['celebrates'] ?? 0,
                                Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.green.shade400,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Live',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // StreamBuilder with Query Example: Filtered Favorites
  Widget _buildFavoritesQuery() {
    final user = FirebaseAuth.instance.currentUser;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.purple.shade50,
          child: Row(
            children: [
              Icon(Icons.filter_list, color: Colors.purple.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtered Query (where clause)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shows only favorites for current user',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('favorites')
                .where('userId', isEqualTo: user?.uid ?? 'no_user')
                .orderBy('addedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading favorites...'),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
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

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + icon to add sample data',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final favorites = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  final data = favorite.data() as Map<String, dynamic>;
                  final tags = (data['tags'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ?? [];
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: Icon(
                          data['itemType'] == 'demo'
                              ? Icons.widgets
                              : Icons.school,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      title: Text(
                        data['itemTitle'] ?? 'Untitled',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(data['description'] ?? ''),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: tags.map((tag) {
                              return Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                          if (data['notes'] != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.note,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    data['notes'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          data['itemType'] ?? 'unknown',
                          style: const TextStyle(fontSize: 10),
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // FutureBuilder Example: Single Document Read
  Widget _buildSingleDocRead() {
    final user = FirebaseAuth.instance.currentUser;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.document_scanner, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Single Document Read (FutureBuilder)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'One-time read, does not update automatically',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: user == null
              ? const Center(
                  child: Text('Please log in to view user profile'),
                )
              : FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(user.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading user profile...'),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red,
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

                    // Check if document exists
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'User profile not found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This demo reads from users/${user.uid}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () async {
                                // Create a sample user document
                                await _firestore
                                    .collection('users')
                                    .doc(user.uid)
                                    .set({
                                  'email': user.email,
                                  'displayName': user.displayName ?? 'Demo User',
                                  'photoURL': user.photoURL,
                                  'emailVerified': user.emailVerified,
                                  'createdAt': FieldValue.serverTimestamp(),
                                  'lastLoginAt': FieldValue.serverTimestamp(),
                                  'accountStatus': 'active',
                                  'role': 'student',
                                  'preferences': {
                                    'theme': 'system',
                                    'notifications': true,
                                    'language': 'en',
                                  },
                                });
                                setState(() {}); // Refresh the UI
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Create Profile Document'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Display document data
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data == null) {
                      return const Center(
                        child: Text('No data in document'),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Header
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.green.shade200,
                                  child: Text(
                                    (data['displayName'] as String?)
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        'U',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  data['displayName'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['email'] ?? 'No Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Chip(
                                  label: Text(data['role'] ?? 'unknown'),
                                  avatar: Icon(
                                    Icons.badge,
                                    size: 18,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Profile Details
                          _buildInfoCard('Account Status', data['accountStatus'] ?? 'N/A', Icons.verified_user),
                          _buildInfoCard(
                            'Email Verified',
                            data['emailVerified'] == true ? 'Yes' : 'No',
                            Icons.email,
                          ),
                          
                          // Preferences
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.green.shade700),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Preferences',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  _buildPreferenceRow(
                                    'Theme',
                                    data['preferences']?['theme'] ?? 'N/A',
                                  ),
                                  _buildPreferenceRow(
                                    'Notifications',
                                    data['preferences']?['notifications'] == true
                                        ? 'Enabled'
                                        : 'Disabled',
                                  ),
                                  _buildPreferenceRow(
                                    'Language',
                                    data['preferences']?['language'] ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          
                          // Document ID Info
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.key,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Document ID',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  snapshot.data!.id,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReactionChip(IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 12),
            Text('Firestore Read Operations'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This demo shows three ways to read data from Firestore:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                '1. Real-Time Stream (Messages)',
                'Uses StreamBuilder with snapshots() to listen for changes in real-time. Perfect for chat, feeds, and live data.',
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                '2. Filtered Query (Favorites)',
                'Uses where() clause to filter data. Shows only items matching specific criteria (e.g., current user\'s favorites).',
                Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                '3. Single Document (Profile)',
                'Uses FutureBuilder with get() for one-time reads. Good for data that doesn\'t change often.',
                Colors.green,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tips_and_updates, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tap the + button to add sample data if collections are empty!',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
