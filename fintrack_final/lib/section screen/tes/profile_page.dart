import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔷 HEADER
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 251.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF00244B),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 32, right: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/80'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Jane Austin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'janeaustin@gmail.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 🔔 ICON NOTIFIKASI (Kanan Atas)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Action untuk notifikasi
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🔷 MENU OPTIONS
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
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
                    const SizedBox(height: 9),
                    _buildMenuItem(
                      context: context,
                      svgPath: 'assets/icons/history.svg',
                      title: 'History',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔷 BOTTOM NAVIGATION (3 Icons)
          Container(
            margin: const EdgeInsets.fromLTRB(80, 16, 80, 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF00244B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBottomNavItem(
                  svgPath: 'assets/icons/home.svg',
                  onTap: () {
                    // Navigate to Home
                  },
                ),
                const SizedBox(width: 8),
                _buildBottomNavItem(
                  svgPath: 'assets/icons/calender.svg',
                  onTap: () {
                    // Navigate to Calendar
                  },
                ),
                const SizedBox(width: 8),
                _buildBottomNavItem(
                  svgPath: 'assets/icons/account.svg',
                  isActive: true, // Profile sedang aktif
                  onTap: () {
                    // Already on Profile
                  },
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
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
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
                Icon(Icons.chevron_right, color: Colors.grey[500]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required String svgPath,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(
          svgPath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            isActive ? const Color(0xFF00244B) : Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}