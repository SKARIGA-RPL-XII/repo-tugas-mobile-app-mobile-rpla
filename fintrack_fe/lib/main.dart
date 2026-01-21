import 'package:flutter/material.dart';
// import 'section/sec1.dart';
// import 'section/sec2.dart';
// import 'section/sec3.dart';
// import 'section/sec4.dart';
// import 'section/sec5.dart';
import 'section/sec6.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      // home: ProfilePage(),
      // home: ChangePasswordPage(),
      // home: EditProfilePageTest(),
      // home: AddSaldoPage(),
      home: NotificationPage(),
    );
  }
}
