import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchDemo extends StatefulWidget {
  const UserSearchDemo({Key? key}) : super(key: key);

  @override
  State<UserSearchDemo> createState() => _UserSearchDemoState();
}

class _UserSearchDemoState extends State<UserSearchDemo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _selectedRole = 'all'; // all, admin, user, moderator
  String _selectedExperience = 'all'; // all, junior, senior, lead
  bool _onlineOnly = false;

  @override
  void initState() {
    super.initState();
    _initializeSampleUsers();
  }

  void _initializeSampleUsers() async {
    try {
      final snapshot = await _firestore.collection('users_search').limit(1).get();
      if (snapshot.docs.isEmpty) {
        final sampleUsers = [
          {
            'name': 'Alice Johnson',
            'email': 'alice@example.com',
            'role': 'admin',
            'skills': ['Flutter', 'Firebase', 'Node.js'],
            'experience': 'senior',
            'isOnline': true,
            'joinedAt': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 365))),
          },
          {
            'name': 'Bob Smith',
            'email': 'bob@example.com',
            'role': 'user',
            'skills': ['React', 'TypeScript'],
            'experience': 'junior',
            'isOnline': false,
            'joinedAt': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 30))),
          },
          {
            'name': 'Carol Davis',
            'email': 'carol@example.com',
            'role': 'moderator',
            'skills': ['Python', 'Django', 'PostgreSQL'],
            'experience': 'senior',
            'isOnline': true,
            'joinedAt': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 180))),
          },
          {
            'name': 'David Lee',
            'email': 'david@example.com',
            'role': 'user',
            'skills': ['Flutter', 'Dart'],
            'experience': 'junior',
            'isOnline': true,
            'joinedAt': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 60))),
          },
          {
            'name': 'Eve Martinez',
            'email': 'eve@example.com',
            'role': 'admin',
            'skills': ['AWS', 'Docker', 'Kubernetes'],
            'experience': 'lead',
            'isOnline': false,
            'joinedAt': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 400))),
          },
        ];

        for (var user in sampleUsers) {
          await _firestore.collection('users_search').add(user);
        }
      }
    } catch (e) {
      print('Error initializing users: $e');
    }
  }

  // Build dynamic query based on filters
  Query _buildUserQuery() {
    var query = _firestore.collection('users_search') as Query;

    // Filter by role (if not 'all')
    if (_selectedRole != 'all') {
      query = query.where('role', isEqualTo: _selectedRole);
    }

    // Filter by experience (if not 'all')
    if (_selectedExperience != 'all') {
      query = query.where('experience', isEqualTo: _selectedExperience);
    }

    // Filter by online status (if enabled)
    if (_onlineOnly) {
      query = query.where('isOnline', isEqualTo: true);
    }

    // Order by join date (newest first)
    query = query.orderBy('joinedAt', descending: true);

    return query;
  }

  // Get users matching search term (this would be better with Algolia in production)
  Stream<QuerySnapshot> _getFilteredUsersStream() {
    return _buildUserQuery().snapshots();
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).round()} months ago';
    } else {
      return '${(difference.inDays / 365).round()} years ago';
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'moderator':
        return Colors.orange;
      case 'user':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Search & Filters'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple.shade50,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Filter
                  const Text(
                    'User Role',
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
                      _buildRoleChip('All', 'all'),
                      _buildRoleChip('Admin', 'admin'),
                      _buildRoleChip('Moderator', 'moderator'),
                      _buildRoleChip('User', 'user'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Experience Filter
                  const Text(
                    'Experience Level',
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
                      _buildExperienceChip('All', 'all'),
                      _buildExperienceChip('Junior', 'junior'),
                      _buildExperienceChip('Senior', 'senior'),
                      _buildExperienceChip('Lead', 'lead'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Online Status Filter
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Online Only'),
                          value: _onlineOnly,
                          onChanged: (value) {
                            setState(() => _onlineOnly = value ?? false);
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
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
              stream: _getFilteredUsersStream(),
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
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
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
                      children: const [
                        Icon(
                          Icons.person_search,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final data = user.data() as Map<String, dynamic>;
                    return _buildUserCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedRole == value,
      onSelected: (_) {
        setState(() => _selectedRole = value);
      },
      backgroundColor: Colors.white,
      selectedColor: _getRoleColor(value).withOpacity(0.3),
      side: BorderSide(
        color: _selectedRole == value
            ? _getRoleColor(value)
            : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildExperienceChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedExperience == value,
      onSelected: (_) {
        setState(() => _selectedExperience = value);
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.green.withOpacity(0.3),
      side: BorderSide(
        color: _selectedExperience == value
            ? Colors.green
            : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> data) {
    final name = data['name'] ?? 'Unknown';
    final email = data['email'] ?? '';
    final role = data['role'] ?? 'user';
    final experience = data['experience'] ?? 'junior';
    final isOnline = data['isOnline'] ?? false;
    final skills = List<String>.from(data['skills'] ?? []);
    final joinedAt = data['joinedAt'] as Timestamp?;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and online status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isOnline ? Colors.green : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isOnline
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Role and Experience Badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(role).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(role),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    experience.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Skills (Array Field)
            if (skills.isNotEmpty) ...[
              const Text(
                'Skills',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: skills
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Joined Date
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Joined ${_formatDate(joinedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
