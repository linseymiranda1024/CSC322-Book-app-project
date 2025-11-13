import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample user data - replace with actual user data from your state management
  String userName = 'Book Lover';
  String userEmail = 'booklover@example.com';
  int totalBooks = 42;
  int booksRead = 28;
  int currentlyReading = 3;
  String favoriteGenre = 'Fantasy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // User Name
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // User Email
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Reading Statistics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reading Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('Total Books', totalBooks.toString(), Icons.library_books),
                      _buildStatCard('Books Read', booksRead.toString(), Icons.check_circle),
                      _buildStatCard('Reading', currentlyReading.toString(), Icons.menu_book),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Profile Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildProfileOption(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      // Navigate to edit profile screen
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.favorite_outline,
                    title: 'Favorite Genre',
                    subtitle: favoriteGenre,
                    onTap: () {
                      // Navigate to genre selection
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Navigate to notifications settings
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // Toggle dark mode
                      },
                    ),
                  ),
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      // Navigate to about screen
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Theme.of(context).primaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: Colors.grey[600]))
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                Navigator.pop(context);
                // Add your logout logic here
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}