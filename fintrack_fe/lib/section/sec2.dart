import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          // 🔷 HEADER
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 251.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF00244B),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 32, right: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/80',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Jane Austin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'janeaustin@gmail.com',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🔷 MENU OPTIONS
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SizedBox(
              width: 380.0,
              height: 227.0,
              child: ClipRect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                      context: context,
                      svgPath: 'assets/icons/edit_profile.svg',
                      title: 'Edit Profile',
                    ),
                    const SizedBox(height: 9),
                    _buildMenuItem(
                      context: context,
                      svgPath: 'assets/icons/password.svg',
                      title: 'Password',
                    ),
                    const SizedBox(height: 9),
                    _buildMenuItem(
                      context: context,
                      svgPath: 'assets/icons/mode.svg',
                      title: 'Mode',
                    ),
                    const SizedBox(height: 9),
                    _buildMenuItem(
                      context: context,
                      svgPath: 'assets/icons/language.svg',
                      title: 'Language',
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          Divider(
            thickness: 1,
            color: Colors.grey[300],
            indent: 24,
            endIndent: 24,
          ),

          // 🔷 LOGOUT 
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully')),
                    );
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String svgPath,
    required String title,
  }) {
    return Container(
      height: 49.75,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('You tapped $title')));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 16)),
                ),
                // 👇 Tetap pakai ikon bawaan Flutter — tidak perlu SVG
                Icon(Icons.chevron_right, color: Colors.grey[500]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
