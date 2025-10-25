import 'package:flutter/material.dart';
import 'package:petrosafe_app/pages/page_main.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "lib/assets/images/logo_petrosafe.png",
                  height: 100,
                  width: 200,
                ),

                SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Selamat Datang Kembali!",
                        style: TextStyle(fontSize: 16),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Masuk untuk Menggunakan Aplikasi",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                PetroForm(hintText: "Masukkan Email Anda"),

                SizedBox(height: 16),

                PetroForm(hintText: "Masukkan Kata Sandi Anda"),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[Text("Lupa Kata Sandi?")],
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    ),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
