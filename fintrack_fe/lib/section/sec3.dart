import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
          ), // sesuaikan posisi horizontal
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF00244B),
              shape: BoxShape
                  .circle, // atau borderRadius: BorderRadius.circular(120)
            ),
            child: IconButton(
              padding: EdgeInsets.zero, // hapus padding default IconButton
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              alignment: Alignment.center,
            ),
          ),
        ),
        title: const Text(
          'Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Montserrat',
            height: 1.0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Deskripsi
              SizedBox(
                width: 380,
                height: 30,
                child: Text(
                  'Password anda saat ini harus paling tidak 6 karakter dan harus menyertakan kombinasi angka, huruf',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black,
                    height: 1.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 24),

              // Field 1: Password Saat Ini
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Password saat ini ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    TextSpan(
                      text: '(Diperbarui 05/01/2026)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Input Here...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                cursorColor: Colors.black,
              ),

              const SizedBox(height: 16),

              // Field 2: Password Baru
              const Text(
                'Password baru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '••••••',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Field 3: Tulis Ulang Password Baru
              const Text(
                'Tulis ulang password baru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '••••••',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 24),

              // Link Lupa Password
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Tambahkan logika lupa password
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Fitur lupa password belum tersedia'),
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(color: Color(0xFF3840F7), fontSize: 14),
                  ),
                ),
              ),

              const Spacer(),

              // Button Change Password
              SizedBox(
                width: 380,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2C4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // Tambahkan logika ubah password
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password berhasil diubah')),
                    );
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Monserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
