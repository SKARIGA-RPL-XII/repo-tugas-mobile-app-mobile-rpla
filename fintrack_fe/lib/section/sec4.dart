import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF00244B),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// ================= FOTO PROFIL =================
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/80',
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white, // lingkaran putih
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/tambah.svg',
                            width: 25,
                            height: 25,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF00244B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ================= FULL NAME =================
              const Text(
                'Full Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _styledFormField(
                hint: 'Jane Austin Raders',
                suffixIcon: SvgPicture.asset(
                  'assets/icons/name.svg',
                  width: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ================= NICK NAME =================
              const Text(
                'Nick Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _styledFormField(
                hint: 'Jane',
                suffixIcon: SvgPicture.asset(
                  'assets/icons/name.svg',
                  width: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ================= EMAIL =================
              const Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _styledFormField(
                hint: 'janeaustin0280@gmail.com',
                suffixIcon: SvgPicture.asset(
                  'assets/icons/sms.svg',
                  width: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ================= PHONE =================
              const Text(
                'Phone',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _styledFormField(
                hint: '+62 8976 2780 8278',
                suffixIcon: SvgPicture.asset(
                  'assets/icons/call.svg',
                  width: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ================= COMPANY =================
              const Text(
                'Company',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _styledFormField(hint: 'PT INDONESIA SEJAHTERA'),

              const SizedBox(height: 32),

              /// ================= BUTTON =================
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Discard'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00244B),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 16),

              /// ================= LOG OUT =================
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/logout.svg',
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= FORM FIELD STYLE =================
  static Widget _styledFormField({required String hint, Widget? suffixIcon}) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixIcon,
                ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 16,
            minWidth: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
