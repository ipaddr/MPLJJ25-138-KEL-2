import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  void sendCode() async {
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan nomor HP yang valid")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+62$phoneNumber', // Tambahkan kode negara sesuai kebutuhan
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-verify jika mungkin (di Android biasanya)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verifikasi otomatis berhasil")),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim kode: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Kode OTP telah dikirim")));
        // Navigasi ke halaman input kode OTP jika kamu punya
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F7F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Center(child: Image.asset('assets/farmer_kid.png', height: 120)),
              const SizedBox(height: 24),
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
                        controller: phoneController,
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : sendCode,
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.arrow_forward),
                  label: Text(isLoading ? "Mengirim..." : "Kirim Kode Reset"),
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
