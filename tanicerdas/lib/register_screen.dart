import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;

  final List<String> roles = ['Petani', 'Distributor', 'Konsumen'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/top_decor.png', fit: BoxFit.cover),
              const SizedBox(height: 16),
              Image.asset('assets/logo_tanicerdas.png', height: 100),
              const SizedBox(height: 32),
              _buildTextField(
                label: "Nama",
                icon: Icons.person_outline,
                controller: nameController,
                hintText: "Masukan nama anda",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Nomor HP",
                icon: Icons.phone_outlined,
                controller: phoneController,
                hintText: "Masukan Nomor HP",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Daerah",
                icon: Icons.location_on_outlined,
                controller: regionController,
                hintText: "Masukan Daerah Anda",
              ),
              const SizedBox(height: 16),
              _buildDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Password",
                icon: Icons.lock_outline,
                controller: passwordController,
                hintText: "Buat Password",
                obscureText: true,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0, left: 8),
                  child: Text(
                    'Password setidaknya harus ada 8 karakter',
                    style: TextStyle(color: Colors.teal, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009C66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Logika daftar akun
                  },
                  child: const Text(
                    "Daftar Akun",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Kembali ke login
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Sudah Punya Akun? ',
                    children: [
                      TextSpan(
                        text: 'Login Disini',
                        style: TextStyle(
                          color: Color(0xFF009C66),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.teal),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Your Role", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.manage_accounts_rounded,
              color: Colors.teal,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.teal),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          hint: const Text("Pilih Role Anda"),
          value: selectedRole,
          onChanged: (value) {
            setState(() {
              selectedRole = value;
            });
          },
          items:
              roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
        ),
      ],
    );
  }
}
