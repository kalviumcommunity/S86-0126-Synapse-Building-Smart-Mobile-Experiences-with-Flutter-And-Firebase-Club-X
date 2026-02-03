import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import '../widgets/like_button.dart';

class CustomWidgetsDemo extends StatelessWidget {
  const CustomWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reusable Custom Widgets'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Custom Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Primary Action',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Primary button tapped!')),
                );
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: 'Secondary Action',
              backgroundColor: Colors.orange,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Secondary button tapped!')),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Info Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InfoCard(
              title: 'Profile',
              subtitle: 'View your account details',
              icon: Icons.person,
              iconColor: Colors.blue,
            ),
            InfoCard(
              title: 'Settings',
              subtitle: 'Customize your preferences',
              icon: Icons.settings,
              iconColor: Colors.purple,
            ),
            InfoCard(
              title: 'Notifications',
              subtitle: 'Manage your alerts',
              icon: Icons.notifications,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Like Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeButton(
                  onLike: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Liked!')));
                  },
                ),
                LikeButton(
                  onLike: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Liked!')));
                  },
                ),
                LikeButton(
                  onLike: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Liked!')));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
