import 'package:flutter/material.dart';

class CuacaPage extends StatelessWidget {
  const CuacaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: const Text('Cuaca', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCuacaSaatIni(),
            const SizedBox(height: 24),
            const Text(
              'Peringatan Aktif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPeringatanCard(
              icon: Icons.water_drop,
              iconColor: Colors.blue,
              title: "Peringatan Hujan Lebat",
              wilayah: "Kecamatan Pauh dan sekitarnya",
              waktu: "7 Mei, 10:00 - 18:00",
              badgeLabel: "Info",
              badgeColor: Colors.blue[100]!,
              badgeTextColor: Colors.blue[900]!,
              stripColor: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildPeringatanCard(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,
              title: "Risiko Banjir",
              wilayah: "Kecamatan Lubuk Begalung",
              waktu: "7-8 Mei 2025",
              badgeLabel: "Siaga",
              badgeColor: Colors.orange[100]!,
              badgeTextColor: Colors.orange[900]!,
              stripColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuacaSaatIni() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Cuaca Saat Ini",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Kecamatan Pauh, Padang"),
                Text("Selasa, 6 Mei 2025"),
              ],
            ),
          ),
          Column(
            children: const [
              Icon(Icons.wb_sunny_rounded, size: 48, color: Colors.orange),
              SizedBox(height: 4),
              Text(
                "28°C",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeringatanCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String wilayah,
    required String waktu,
    required String badgeLabel,
    required Color badgeColor,
    required Color badgeTextColor,
    required Color stripColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 100,
            decoration: BoxDecoration(
              color: stripColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: iconColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            color: badgeTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(wilayah),
                  Text(
                    "Berlaku: $waktu",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
