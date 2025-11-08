import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:petrosafe_app/pages/page_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petrosafe_app/widgets/forms/form_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> saveLoginData(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user_name', user['name'] ?? '');
    await prefs.setString('user_position', user['position'] ?? '');
    await prefs.setString('user_photo', user['photo_url'] ?? '');
  }

  Future<void> login() async {
    setState(() => isLoading = true);

    final baseUrl = dotenv.env["API_BASE_URL"];
    final url = Uri.parse("$baseUrl/api/auth/login");
    final body = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        final token = data['token'];
        final user = data['user'];

        await saveLoginData(token, user);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login berhasil, selamat datang ${user['name']}"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan koneksi: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

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

                SizedBox(height: 32),

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

                const SizedBox(height: 16),
                LoginForm(
                  hintText: "Masukkan Email Anda",
                  controller: emailController,
                ),

                const SizedBox(height: 16),
                LoginForm(
                  hintText: "Masukkan Kata Sandi Anda",
                  controller: passwordController,
                  obscureText: true,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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
