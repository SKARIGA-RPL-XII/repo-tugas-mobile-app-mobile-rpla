import 'package:flutter/material.dart';

class ModePage extends StatefulWidget {
  const ModePage({super.key});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  String selectedMode = 'light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0B2C4D),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: const Text(
          'Mode',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _modeItem(
              icon: Icons.wb_sunny_outlined,
              title: 'Light Mode',
              mode: 'light',
              selected: selectedMode == 'light',
              onTap: () {
                setState(() => selectedMode = 'light');
              },
            ),
            const SizedBox(height: 12),
            _modeItem(
              icon: Icons.nightlight_outlined,
              title: 'Dark Mode',
              mode: 'dark',
              selected: selectedMode == 'dark',
              onTap: () {
                setState(() => selectedMode = 'dark');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeItem({
  required IconData icon,
  required String title,
  required String mode, // 'light' | 'dark'
  required bool selected,
  required VoidCallback onTap,
}) {
  const primaryColor = Color(0xFF0B2C4D);

  Color backgroundColor;
  Color contentColor;

  if (selected && mode == 'light') {
    backgroundColor = primaryColor;
    contentColor = Colors.white;
  } else if (selected && mode == 'dark') {
    backgroundColor = Colors.white;
    contentColor = primaryColor;
  } else {
    backgroundColor = Colors.white;
    contentColor = Colors.black54;
  }

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: contentColor),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: contentColor,
            ),
          ),
        ],
      ),
    ),
  );
}

}
