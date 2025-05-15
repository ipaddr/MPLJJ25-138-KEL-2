import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFE9F7F1,
      ), // warna latar belakang hijau muda
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Color(0xFF006241)),
                    const SizedBox(width: 4),
                    Text(
                      "Kembali kelogin",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF006241),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Ilustrasi anak bertani
              Center(
                child: Image.asset(
                  'assets/farmer_kid.png', // Ganti dengan nama file yang sesuai
                  height: 120,
                ),
              ),
              const SizedBox(height: 24),

              // Judul
              Center(
                child: Text(
                  "Lupa Password?",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Subjudul
              Center(
                child: Text(
                  "Tidak masalah, Tolong masukan nomor HP\nAnda untuk mereset password akun anda",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Input nomor HP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Nomor HP",
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Kirim
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Tambahkan aksi kirim reset kode
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Kirim Kode Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009A60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Support
              Center(
                child: Column(
                  children: [
                    Text(
                      "Butuh Bantuan? Hubungin Costumer Service",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, color: Colors.green, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "Hubungi Support",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF009A60),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
