import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;
  late String userEmail;
  bool darkMode = false;
  String favoriteGenre = 'Fantasy';

  // Example reading stats
  int totalBooks = 42;
  int booksRead = 28;
  int currentlyReading = 3;

  final _displayNameController = TextEditingController();
  final _genreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
    userName = user?.displayName ?? userEmail.split('@')[0];

    _displayNameController.text = userName;
    _genreController.text = favoriteGenre;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _updateDisplayName() async {
    final newName = _displayNameController.text.trim();
    if (newName.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(newName);
      await user.reload();
      setState(() {
        userName = newName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name updated!')),
      );
    }
  }

  void _updateFavoriteGenre() {
    setState(() {
      favoriteGenre = _genreController.text.trim().isEmpty
          ? favoriteGenre
          : _genreController.text.trim();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorite genre updated!')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Theme.of(context).primaryColor),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            )),
        subtitle:
            subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey[600])) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

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
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color.fromARGB(255, 127, 176, 143),
                      child: const Icon(Icons.person, size: 60, color: Color.fromARGB(255, 41, 66, 49)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(userName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 5),
                  Text(userEmail, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
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
                  const Text('Reading Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildProfileOption(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: userName,
                    onTap: () {
                      _displayNameController.text = userName;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Edit Display Name'),
                          content: TextField(controller: _displayNameController),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () {
                                  _updateDisplayName();
                                  Navigator.pop(context);
                                },
                                child: const Text('Save')),
                          ],
                        ),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.favorite_outline,
                    title: 'Favorite Genre',
                    subtitle: favoriteGenre,
                    onTap: () {
                      _genreController.text = favoriteGenre;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Edit Favorite Genre'),
                          content: TextField(controller: _genreController),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () {
                                  _updateFavoriteGenre();
                                  Navigator.pop(context);
                                },
                                child: const Text('Save')),
                          ],
                        ),
                      );
                    },
                  ),
                  // _buildProfileOption(
                  //   icon: Icons.notifications_outlined,
                  //   title: 'Notifications',
                  //   onTap: () {},
                  // ),
                  _buildProfileOption(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: darkMode,
                      onChanged: (value) {
                        setState(() => darkMode = value);
                      },
                    ),
                  ),
                  // _buildProfileOption(
                  //   icon: Icons.info_outline,
                  //   title: 'About',
                  //   onTap: () {},
                  // ),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: _showLogoutDialog,
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
}
