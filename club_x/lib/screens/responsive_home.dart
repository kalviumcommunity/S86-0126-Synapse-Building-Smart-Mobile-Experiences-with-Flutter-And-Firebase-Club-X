import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

/// A responsive home screen that adapts to different screen sizes and orientations
/// Demonstrates the use of MediaQuery, LayoutBuilder, and flexible widgets
class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final orientation = MediaQuery.of(context).orientation;

    // Determine if the device is a tablet based on width
    final bool isTablet = screenWidth > 600;
    final bool isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // Header Section - AppBar with responsive title size
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Club-X Responsive Layout',
          style: TextStyle(
            fontSize: isTablet ? 24 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: isTablet ? 28 : 24,
            onPressed: () {},
          ),
          SizedBox(width: isTablet ? 16 : 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Device Info Card
              _buildInfoCard(
                context,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                isTablet: isTablet,
                isLandscape: isLandscape,
              ),

              SizedBox(height: isTablet ? 24 : 16),

              // Main Content Area - Adaptive Grid
              _buildAdaptiveGrid(context, isTablet, isLandscape),

              SizedBox(height: isTablet ? 24 : 16),

              // Feature Cards Section
              _buildFeatureCardsSection(context, isTablet, isLandscape),

              SizedBox(height: isTablet ? 24 : 16),

              // Responsive Image Section
              _buildResponsiveImageSection(context, isTablet),

              SizedBox(height: isTablet ? 24 : 16),

              // Footer/Action Section
              _buildFooterSection(context, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an information card showing current device dimensions
  Widget _buildInfoCard(
    BuildContext context, {
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
    required bool isLandscape,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoRow(
              'Screen Width',
              '${screenWidth.toStringAsFixed(1)} px',
              isTablet,
            ),
            _buildInfoRow(
              'Screen Height',
              '${screenHeight.toStringAsFixed(1)} px',
              isTablet,
            ),
            _buildInfoRow(
              'Device Type',
              isTablet ? 'Tablet' : 'Phone',
              isTablet,
            ),
            _buildInfoRow(
              'Orientation',
              isLandscape ? 'Landscape' : 'Portrait',
              isTablet,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build info rows
  Widget _buildInfoRow(String label, String value, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an adaptive grid using LayoutBuilder
  Widget _buildAdaptiveGrid(
    BuildContext context,
    bool isTablet,
    bool isLandscape,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine number of columns based on available width
        int crossAxisCount;
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 400) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adaptive Grid Layout',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: isTablet ? 16 : 12,
                mainAxisSpacing: isTablet ? 16 : 12,
                childAspectRatio: 1.2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildGridItem(index, isTablet);
              },
            ),
          ],
        );
      },
    );
  }

  /// Builds individual grid items
  Widget _buildGridItem(int index, bool isTablet) {
    final List<IconData> icons = [
      Icons.home,
      Icons.event,
      Icons.people,
      Icons.sports_soccer,
      Icons.chat,
      Icons.notifications,
    ];

    final List<String> titles = [
      'Home',
      'Events',
      'Members',
      'Sports',
      'Chat',
      'Alerts',
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[index],
              size: isTablet ? 48 : 36,
              color: Colors.deepPurple,
            ),
            SizedBox(height: isTablet ? 12 : 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                titles[index],
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds feature cards section with flexible layout
  Widget _buildFeatureCardsSection(
    BuildContext context,
    bool isTablet,
    bool isLandscape,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Content',
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),

        // Use Wrap for responsive card layout
        isTablet || isLandscape
            ? Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      'Upcoming Events',
                      Icons.calendar_today,
                      Colors.blue,
                      isTablet,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: _buildFeatureCard(
                      'New Members',
                      Icons.person_add,
                      Colors.green,
                      isTablet,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: _buildFeatureCard(
                      'Announcements',
                      Icons.campaign,
                      Colors.orange,
                      isTablet,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildFeatureCard(
                    'Upcoming Events',
                    Icons.calendar_today,
                    Colors.blue,
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  _buildFeatureCard(
                    'New Members',
                    Icons.person_add,
                    Colors.green,
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  _buildFeatureCard(
                    'Announcements',
                    Icons.campaign,
                    Colors.orange,
                    isTablet,
                  ),
                ],
              ),
      ],
    );
  }

  /// Builds individual feature card
  Widget _buildFeatureCard(
    String title,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: isTablet ? 32 : 24,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color, size: isTablet ? 32 : 24),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              'View Details',
              style: TextStyle(fontSize: isTablet ? 14 : 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds responsive image section with AspectRatio
  Widget _buildResponsiveImageSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image placeholder with AspectRatio
          AspectRatio(
            aspectRatio: isTablet ? 2.5 : 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: isTablet ? 80 : 60,
                      color: Colors.white70,
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Text(
                      'Responsive Image Area',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Text(
              'This section demonstrates responsive image handling using AspectRatio widget to maintain proportions across different screen sizes.',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds footer section with action buttons
  Widget _buildFooterSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.deepPurple,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          children: [
            Text(
              'Ready to Get Started?',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'Join Club-X and experience responsive design in action',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Responsive button layout using CustomButton
            isTablet
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CustomButton(
                          label: 'Sign In',
                          backgroundColor: Colors.white,
                          textColor: Colors.deepPurple,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: CustomButton(
                          label: 'Register',
                          backgroundColor: Colors.transparent,
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomButton(
                        label: 'Sign In',
                        backgroundColor: Colors.white,
                        textColor: Colors.deepPurple,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        label: 'Register',
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
