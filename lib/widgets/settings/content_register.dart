import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'package:petrosafe_app/widgets/forms/form_login.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent({super.key});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final emailPengguna = TextEditingController();
  final kataSandi = TextEditingController();
  final namaPengguna = TextEditingController();
  final posisiPengguna = TextEditingController();

  bool _loading = false;

  Future<void> _registerUser() async {
    final email = emailPengguna.text.trim();
    final password = kataSandi.text.trim();
    final name = namaPengguna.text.trim();
    final position = posisiPengguna.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || position.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:3000/api"));

      final response = await dio.post(
        "/auth/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "position": position,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pengguna berhasil didaftarkan!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // ✅ langsung balik ke halaman sebelumnya
      } else {
        throw Exception("Gagal daftar (${response.statusCode})");
      }
    } on DioException catch (e) {
      debugPrint("Register error: ${e.response?.data ?? e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data?['message'] ??
                "Gagal mendaftarkan pengguna. Coba lagi nanti.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint("Error umum: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pengguna Baru",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              PetroForm(
                hintText: "Masukkan Email Pengguna",
                controller: emailPengguna,
              ),
              const SizedBox(height: 16),
              LoginForm(
                hintText: "Masukkan Kata Sandi Pengguna",
                controller: kataSandi,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              PetroForm(
                hintText: "Masukkan Nama Pengguna",
                controller: namaPengguna,
              ),
              const SizedBox(height: 16),
              PetroForm(
                hintText: "Masukkan Posisi Pengguna",
                controller: posisiPengguna,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _loading ? null : _registerUser,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Tambah",
                            style: TextStyle(color: Colors.white),
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
