import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'analysis_page.dart'; // Import halaman analysis
import 'schedule_page.dart'; // Import halaman schedule
import 'setting_page.dart'; // Import halaman setting

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman yang sesuai
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalysisPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SchedulePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
        break;
      default:
        // Untuk index 0 (Beranda), tidak perlu navigasi
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: const Text("TaniCerdas"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_placeholder.png'),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section: Total Lahan & Stok Makanan
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icon: Icons.landscape,
                    title: "Total Lahan",
                    value: "12 Petak",
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _infoCard(
                    icon: Icons.store,
                    title: "Stok Makanan",
                    value: "150 Kg",
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Akses Cepat
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Akses Cepat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickAction(LucideIcons.map, "Map Lahan"),
                _quickAction(LucideIcons.plusCircle, "Tambah Tanaman"),
                _quickAction(LucideIcons.cloudSun, "Cuaca"),
                _quickAction(LucideIcons.fileText, "Report"),
              ],
            ),

            const SizedBox(height: 24),

            // Banner atau informasi tambahan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Pastikan tanaman Anda mendapat cukup air selama musim kemarau!",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Panen Terbaru
            _sectionTitle("Panen Terbaru"),
            _listItem("Tomat", "10 kg - 2 Mei 2025"),
            _listItem("Cabai", "5 kg - 30 April 2025"),

            const SizedBox(height: 24),

            // Notifikasi
            _sectionTitle("Notifikasi"),
            _listItem("Periksa kondisi tanah di lahan 2", "1 hari lalu"),
            _listItem("Update cuaca: kemungkinan hujan besok", "2 hari lalu"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Lahan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.green),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _listItem(String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.agriculture),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
