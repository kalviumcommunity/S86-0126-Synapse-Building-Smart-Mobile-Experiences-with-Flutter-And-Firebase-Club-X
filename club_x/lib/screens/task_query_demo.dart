import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskQueryDemo extends StatefulWidget {
  const TaskQueryDemo({Key? key}) : super(key: key);

  @override
  State<TaskQueryDemo> createState() => _TaskQueryDemoState();
}

class _TaskQueryDemoState extends State<TaskQueryDemo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Query state
  String _priorityFilter = 'all'; // all, high, medium, low
  bool _showCompletedOnly = false;
  int _limitResults = 10;

  @override
  void initState() {
    super.initState();
    _initializeSampleTasks();
  }

  void _initializeSampleTasks() async {
    try {
      final snapshot = await _firestore.collection('advanced_tasks').limit(1).get();
      if (snapshot.docs.isEmpty) {
        // Add sample data
        final sampleTasks = [
          {
            'title': 'Urgent: Fix Database Bug',
            'priority': 'high',
            'completed': false,
            'dueDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
            'tags': ['bug', 'urgent'],
          },
          {
            'title': 'Design Wireframes',
            'priority': 'high',
            'completed': true,
            'dueDate': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))),
            'tags': ['design', 'ui'],
          },
          {
            'title': 'Code Review',
            'priority': 'medium',
            'completed': false,
            'dueDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 3))),
            'tags': ['review', 'code'],
          },
          {
            'title': 'Update Documentation',
            'priority': 'low',
            'completed': false,
            'dueDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
            'tags': ['docs'],
          },
          {
            'title': 'Meeting with Client',
            'priority': 'high',
            'completed': true,
            'dueDate': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
            'tags': ['meeting', 'client'],
          },
        ];

        for (var task in sampleTasks) {
          await _firestore.collection('advanced_tasks').add(task);
        }
      }
    } catch (e) {
      print('Error initializing tasks: $e');
    }
  }

  // Build dynamic query based on filters
  Query _buildTaskQuery() {
    var query = _firestore.collection('advanced_tasks') as Query;

    // Filter by priority (if not 'all')
    if (_priorityFilter != 'all') {
      query = query.where('priority', isEqualTo: _priorityFilter);
    }

    // Filter by completion status
    if (_showCompletedOnly) {
      query = query.where('completed', isEqualTo: true);
    } else {
      query = query.where('completed', isEqualTo: false);
    }

    // Order by due date (ascending - nearest first)
    query = query.orderBy('dueDate', descending: false);

    // Limit results
    query = query.limit(_limitResults);

    return query;
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 0) {
      return '${difference.inDays.abs()} days ago';
    } else {
      return 'In ${difference.inDays} days';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Task Queries'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Query Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Priority Filter
                  const Text(
                    'Priority Level',
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
                      _buildPriorityChip('All', 'all'),
                      _buildPriorityChip('High', 'high'),
                      _buildPriorityChip('Medium', 'medium'),
                      _buildPriorityChip('Low', 'low'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Completion Status Filter
                  const Text(
                    'Status',
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
                        child: CheckboxListTile(
                          title: const Text('Show Completed Only'),
                          value: _showCompletedOnly,
                          onChanged: (value) {
                            setState(() => _showCompletedOnly = value ?? false);
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Results Limit
                  const Text(
                    'Limit Results',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _limitResults.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 9,
                    label: '$_limitResults',
                    onChanged: (value) {
                      setState(() => _limitResults = value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ),

          // Results Section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildTaskQuery().snapshots(),
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
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No tasks match your filters',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final data = task.data() as Map<String, dynamic>;
                    return _buildTaskCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _priorityFilter == value,
      onSelected: (_) {
        setState(() => _priorityFilter = value);
      },
      backgroundColor: Colors.white,
      selectedColor: _getPriorityColor(value).withOpacity(0.3),
      side: BorderSide(
        color: _priorityFilter == value
            ? _getPriorityColor(value)
            : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> data) {
    final title = data['title'] ?? 'Untitled';
    final priority = data['priority'] ?? 'low';
    final completed = data['completed'] ?? false;
    final dueDate = data['dueDate'] as Timestamp?;
    final tags = List<String>.from(data['tags'] ?? []);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: completed,
              onChanged: (value) {
                // In a real app, you would update the database here
              },
              checkColor: Colors.white,
              activeColor: Colors.green,
            ),
            title: Text(
              title,
              style: TextStyle(
                decoration: completed ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priority.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(priority),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Due Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Due: ${_formatDate(dueDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
