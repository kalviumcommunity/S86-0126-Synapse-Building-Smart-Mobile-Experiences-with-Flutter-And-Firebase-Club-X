# Firestore Queries, Filters, and Ordering in Flutter

## Overview

This implementation demonstrates **efficient data retrieval** using Firestore queries with filters, ordering, and pagination. Rather than fetching entire collections, we use powerful query capabilities to retrieve only the data we need.

### Key Features

- ✅ Equality filters (where clauses)
- ✅ Comparison filters (greater than, less than, etc.)
- ✅ Array filters (arrayContains)
- ✅ Sorting with orderBy (ascending/descending)
- ✅ Pagination with limit
- ✅ Composite queries (multiple filters + sorting)
- ✅ Real-time filtered results with StreamBuilder
- ✅ Dynamic UI based on filter selection

---

## Understanding Firestore Queries

### Query Structure

A Firestore query has three main parts:

```dart
FirebaseFirestore.instance
  .collection('products')           // 1. Collection reference
  .where('inStock', isEqualTo: true) // 2. Filter (where clause)
  .orderBy('price')                  // 3. Sort order
  .limit(10);                        // 4. Limit results
```

### Why Query-Based Fetching is Better

| Approach | Data Transferred | Load Time | Battery | Cost |
|----------|------------------|-----------|---------|------|
| Fetch All | 100% | Slow | High | High |
| Query-Based | 5-10% | Fast | Low | Low |

---

## Query Types Implemented

### 1. Equality Filters (.where)

**What it does:** Fetch documents where a field matches a specific value.

```dart
// Find all products that are in stock
.where('inStock', isEqualTo: true)

// Find all tasks with high priority
.where('priority', isEqualTo: 'high')

// Find users with a specific role
.where('role', isEqualTo: 'admin')
```

**Use Cases:**
- Filter by status (active/inactive, in stock/out of stock)
- Filter by category
- Filter by role or permission level

---

### 2. Comparison Filters

**Greater Than / Less Than:**

```dart
// Find products more expensive than $100
.where('price', isGreaterThan: 100)

// Find tasks due in next 7 days
.where('dueDate', isLessThanOrEqualTo: sevenDaysFromNow)

// Find users with rating above 4.0
.where('rating', isGreaterThanOrEqualTo: 4.0)
```

**Use Cases:**
- Price ranges
- Date ranges
- Age restrictions
- Quality thresholds

---

### 3. Array Filters (.arrayContains)

**What it does:** Find documents where an array field contains a specific value.

```dart
// Find users with Flutter skill
.where('skills', arrayContains: 'Flutter')

// Find posts tagged with 'urgent'
.where('tags', arrayContains: 'urgent')

// Find products in wishlist
.where('wishlistUsers', arrayContains: currentUserId)
```

**Use Cases:**
- Multi-select filters
- Tags and categories
- User preferences
- Skill searches

---

### 4. Sorting with orderBy

**Ascending (Default):**

```dart
// Sort products by price (cheapest first)
.orderBy('price', descending: false)

// Sort tasks by due date (earliest first)
.orderBy('dueDate')
```

**Descending:**

```dart
// Sort products by price (most expensive first)
.orderBy('price', descending: true)

// Sort by rating (highest first)
.orderBy('rating', descending: true)
```

**Multiple Sorts:**

```dart
.orderBy('priority', descending: true)  // High priority first
.orderBy('dueDate')                     // Then by due date
```

---

### 5. Limiting Results (.limit)

**What it does:** Fetch only the first N documents.

```dart
// Get only the first 10 products
.limit(10)

// Get only the first 5 high-priority tasks
.limit(5)
```

**Use Cases:**
- Pagination (fetch 20 items per page)
- "Top N" listings (top 10 products)
- Initial page load optimization
- Reducing bandwidth

---

## Code Examples from Implementation

### Product Filtering Demo

```dart
// Build dynamic query based on filter selections
Query _buildQuery() {
  var query = _firestore.collection('products') as Query;

  // Status filter
  if (_selectedStatus == 'inStock') {
    query = query.where('inStock', isEqualTo: true);
  }

  // Price range
  if (_minPrice != null) {
    query = query.where('price', isGreaterThanOrEqualTo: _minPrice);
  }
  if (_maxPrice != null) {
    query = query.where('price', isLessThanOrEqualTo: _maxPrice);
  }

  // Sorting
  query = query.orderBy(_sortBy, descending: !_sortAscending);

  return query;
}

// Use in StreamBuilder
StreamBuilder<QuerySnapshot>(
  stream: _buildQuery().snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    // Build UI...
  },
)
```

### Task Query Demo

```dart
// Multi-filter query
Query _buildTaskQuery() {
  var query = _firestore.collection('advanced_tasks') as Query;

  // Priority filter
  if (_priorityFilter != 'all') {
    query = query.where('priority', isEqualTo: _priorityFilter);
  }

  // Completion status
  query = query.where('completed', isEqualTo: _showCompletedOnly);

  // Order by due date
  query = query.orderBy('dueDate', descending: false);

  // Limit results
  query = query.limit(_limitResults);

  return query;
}
```

### User Search Demo

```dart
// Array filter example
.where('skills', arrayContains: 'Flutter')

// Multiple field filters
.where('role', isEqualTo: _selectedRole)
.where('experience', isEqualTo: _selectedExperience)
.where('isOnline', isEqualTo: true)
```

---

## Firestore Data Structures

### Products Collection

```json
{
  "products": {
    "product1": {
      "name": "Laptop",
      "price": 999.99,
      "inStock": true,
      "rating": 4.5,
      "category": "Electronics"
    }
  }
}
```

### Tasks Collection

```json
{
  "advanced_tasks": {
    "task1": {
      "title": "Fix Database Bug",
      "priority": "high",
      "completed": false,
      "dueDate": "2025-02-06T00:00:00Z",
      "tags": ["bug", "urgent"]
    }
  }
}
```

### Users Collection

```json
{
  "users_search": {
    "user1": {
      "name": "Alice Johnson",
      "email": "alice@example.com",
      "role": "admin",
      "experience": "senior",
      "skills": ["Flutter", "Firebase", "Node.js"],
      "isOnline": true,
      "joinedAt": "2024-02-05T00:00:00Z"
    }
  }
}
```

---

## Firestore Indexing

### What is an Index?

An **index** is a database structure that speeds up queries. Firestore automatically creates indexes for:
- Single field queries
- Simple orderBy

But requires **composite indexes** for:
- where + orderBy on different fields
- Multiple where clauses

### Example That Needs Index

```dart
.where('status', isEqualTo: 'active')
.orderBy('date')  // ❌ Composite index required
```

Firestore will prompt you to create the index automatically. Just click the link!

### Index Best Practices

1. **Let Firestore auto-create indexes** when prompted
2. **Check Firebase Console** → Firestore → Indexes
3. **Keep indexes clean** - remove unused ones
4. **Monitor costs** - indexes use storage

---

## Best Practices

### ✅ DO

1. **Use `.limit()`** for pagination
   ```dart
   .limit(20)  // Fetch 20 items per page
   ```

2. **Order by timestamp** for chronological data
   ```dart
   .orderBy('createdAt', descending: true)
   ```

3. **Use where filters** to reduce data transferred
   ```dart
   .where('status', isEqualTo: 'active')
   ```

4. **Combine filters** efficiently
   ```dart
   .where('category', isEqualTo: 'electronics')
   .where('inStock', isEqualTo: true)
   ```

5. **Use FutureBuilder for one-time loads**
   ```dart
   FutureBuilder(
     future: _buildQuery().get(),
     builder: ...,
   )
   ```

### ❌ DON'T

1. **Don't fetch all documents and filter in code**
   ```dart
   // ❌ BAD: Fetches 10,000 documents
   final all = await _firestore.collection('products').get();
   final filtered = all.docs.where((doc) => 
     doc['price'] > 100
   ).toList();
   ```

2. **Don't use orderBy without an index**
   - Firestore will tell you which index is needed

3. **Don't combine too many filters**
   - Queries become complex and require more indexes
   - Limit to 3-4 filters per query

4. **Don't query unindexed fields**
   - Causes performance issues
   - Index needed for every where + orderBy combination

5. **Don't use StreamBuilder for heavy operations**
   - It rebuilds the entire widget tree on every change
   - Use `.snapshots()` wisely

---

## Real-World Use Cases

### E-Commerce Filter

```dart
.where('category', isEqualTo: 'electronics')
.where('inStock', isEqualTo: true)
.where('price', isLessThanOrEqualTo: 500)
.orderBy('rating', descending: true)
.limit(20)
```

### Social Media Feed

```dart
.where('authorId', isEqualTo: currentUserId)
.where('deleted', isEqualTo: false)
.orderBy('createdAt', descending: true)
.limit(20)
```

### Task Management

```dart
.where('assignedTo', isEqualTo: userId)
.where('completed', isEqualTo: false)
.orderBy('priority', descending: true)
.orderBy('dueDate')
.limit(10)
```

### Search Results

```dart
.where('skills', arrayContains: 'Flutter')
.where('experience', isEqualTo: 'senior')
.where('isActive', isEqualTo: true)
.orderBy('rating', descending: true)
```

---

## Common Query Mistakes & Solutions

| Mistake | Error | Solution |
|---------|-------|----------|
| orderBy without index | Index required prompt | Click the prompt link |
| where + orderBy on different fields | Index required | Create composite index |
| Filtering unindexed fields | Slow performance | Add index via Console |
| No limit on large collections | High bandwidth | Add `.limit()` |
| Querying array field incorrectly | No results | Use `.arrayContains()` |

---

## Query Examples by Use Case

### Filter by Status

```dart
.where('status', isEqualTo: 'active')
```

### Filter by Date Range

```dart
.where('createdAt', isGreaterThanOrEqualTo: startDate)
.where('createdAt', isLessThanOrEqualTo: endDate)
```

### Filter by Nested Field

```dart
.where('user.role', isEqualTo: 'admin')  // Requires flat structure
```

### Search by Array

```dart
.where('tags', arrayContains: 'flutter')
```

### Get Top N Items

```dart
.orderBy('rating', descending: true)
.limit(10)
```

### Pagination

```dart
.orderBy('createdAt', descending: true)
.limit(pageSize)
// Next page: use startAfter(lastDocument)
```

---

## Screens Implemented

### 1. Product Filtering Demo
- **File:** `product_filtering_demo.dart`
- **Features:**
  - Filter by stock status (in stock, out of stock)
  - Sort by name, price, or rating
  - Ascending/descending toggle
  - Display price, rating, and stock status

### 2. Advanced Task Queries
- **File:** `task_query_demo.dart`
- **Features:**
  - Filter by priority level (high, medium, low)
  - Show completed or pending tasks
  - Limit results with slider (5-50 items)
  - Array field support (tags)
  - Date formatting (due dates)

### 3. User Search & Filters
- **File:** `user_search_demo.dart`
- **Features:**
  - Filter by role (admin, moderator, user)
  - Filter by experience (junior, senior, lead)
  - Online status filter
  - Array field: skills
  - Timestamp formatting

---

## Testing the Implementation

### Manual Testing

1. **In Firebase Console:**
   - Go to Firestore Database
   - Add test documents to `products`, `advanced_tasks`, `users_search`
   - Modify data and watch app update

2. **In the App:**
   - Open any demo screen
   - Change filters
   - Verify results update instantly
   - Try different sorting options

3. **Test Specific Queries:**
   - Product: Filter by price range
   - Task: Filter high-priority, incomplete tasks
   - User: Find senior Flutter developers

### Verifying Indexes

1. Check Firebase Console → Firestore → Indexes
2. Look for composite indexes you created
3. Monitor index performance

---

## Key Takeaways

### Why Querying is Better Than Fetching All

| Aspect | Fetch All | Query |
|--------|-----------|-------|
| **Bandwidth** | 100% of data | Only needed data |
| **Speed** | Slow | Fast |
| **Battery** | High drain | Low drain |
| **Cost** | High (read operations) | Lower |
| **UX** | Poor (lag) | Smooth |

### Query Best Practices Summary

1. ✅ Use `.where()` to filter server-side
2. ✅ Use `.orderBy()` to sort efficiently
3. ✅ Use `.limit()` for pagination
4. ✅ Combine filters strategically
5. ✅ Let Firestore create needed indexes
6. ✅ Cache results when possible

---

## Challenges & Solutions

### Challenge: Index Not Found Error
**Solution:** Click the link in Firebase error message to create the index

### Challenge: Query Returns Empty Results
**Solution:** 
- Check field names match exactly (case-sensitive)
- Verify document structure
- Check where clause conditions

### Challenge: Too Many Read Operations
**Solution:**
- Add `.limit()` to reduce documents fetched
- Use caching
- Combine filters to be more specific

### Challenge: Query Too Complex
**Solution:**
- Split into multiple simpler queries
- Use client-side filtering for additional conditions
- Consider restructuring data

---

## Resources

- 📚 [Firestore Query Documentation](https://firebase.google.com/docs/firestore/query-data/queries)
- 📚 [FlutterFire Cloud Firestore](https://firebase.flutter.dev/docs/firestore/usage/)
- 📚 [Firestore Indexing Guide](https://firebase.google.com/docs/firestore/query-data/index-overview)
- 📚 [Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- 📚 [Query Limitations](https://firebase.google.com/docs/firestore/query-data/query-limitations)

---

## Reflection

### Why Filtering & Sorting Improves UX

1. **Faster Loading** - Users see results instantly
2. **Better Performance** - Less data transferred
3. **Smoother Experience** - No lag or freezes
4. **Lower Battery Drain** - Efficient data fetching
5. **Cost Savings** - Fewer read operations

### How Firestore Makes It Easy

- Simple, intuitive query API
- Automatic index creation
- Real-time updates with `.snapshots()`
- Scales to millions of documents

### Challenges I Faced

1. **Index Creation** - Understanding composite indexes
2. **Query Limits** - Learning Firestore doesn't support all SQL features
3. **Array Filtering** - Correctly using `.arrayContains()`
4. **Performance** - Balancing features with read operations

All solved through experimentation and testing!

---

**Created:** February 5, 2026  
**Assignment:** Firestore Queries, Filters, and Ordering  
**Status:** ✅ Complete
