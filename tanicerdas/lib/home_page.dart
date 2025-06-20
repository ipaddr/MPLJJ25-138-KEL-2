// Modified home_page.dart with Firebase UID filtering and dynamic data loading
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'analysis_page.dart';
import 'schedule_page.dart';
import 'setting_page.dart';
import 'maplahan.dart';
import 'tambahtanaman.dart';
import 'cuaca.dart';
import 'submitreport.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? uid;
  int totalLahan = 0;
  double totalPanen = 0;
  List<Map<String, dynamic>> panenTerbaru = [];
  List<Map<String, dynamic>> notifikasi = [];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    print("UID yang sedang login: $uid");
    if (uid != null) _loadData();
  }

  Future<void> _loadData() async {
    final analysisDoc =
        await FirebaseFirestore.instance.collection('analysis').doc(uid).get();

    // Hitung totalPanen dari semua subkoleksi tanaman
    double totalPanenBaru = 0;
    final indexSnapshot =
        await FirebaseFirestore.instance
            .collection('tanaman')
            .doc(uid)
            .collection('_index')
            .get();

    for (final doc in indexSnapshot.docs) {
      final subcollectionSnapshot =
          await FirebaseFirestore.instance
              .collection('tanaman')
              .doc(uid)
              .collection(doc.id)
              .get();

      for (final tanamanDoc in subcollectionSnapshot.docs) {
        final data = tanamanDoc.data();
        totalPanenBaru += (data['jumlah'] ?? 0).toDouble();
      }
    }

    final laporanSnapshot =
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(uid)
            .collection('report_user')
            .orderBy('tanggal', descending: true)
            .limit(1)
            .get();

    final scheduleSnapshot =
        await FirebaseFirestore.instance
            .collection('schedule')
            .doc(uid)
            .collection('items')
            .limit(2)
            .get();

    if (analysisDoc.exists) {
      final data = analysisDoc.data();
      setState(() {
        totalLahan = data?['totalLahan'] ?? 0;
      });
    } else {
      setState(() {
        totalLahan = 0;
      });
    }

    setState(() {
      totalPanen = totalPanenBaru;
    });

    if (laporanSnapshot.docs.isNotEmpty) {
      final data = laporanSnapshot.docs.first.data();

      setState(() {
        panenTerbaru = [
          {
            'namaTanaman': data['namaTanaman'],
            'jumlahPanen': data['jumlahPanen'],
            'tanggalPanen': DateFormat(
              'dd MMM yyyy',
            ).format((data['tanggal'] as Timestamp).toDate()),
            'lokasi': data['lokasi'],
          },
        ];
      });

      print("Isi panenTerbaru: $panenTerbaru");
    } else {
      print("Tidak ada laporan panen ditemukan.");
    }

    setState(() {
      notifikasi =
          scheduleSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'judul': data['judulKegiatan'] ?? '-',
              'deskripsi':
                  '${data['jenisKegiatan']} - ${DateFormat('dd MMM yyyy').format((data['tanggal'] as Timestamp).toDate())}',
            };
          }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnalysisPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SchedulePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingPage()),
        );
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
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
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icon: Icons.landscape,
                    title: "Total Lahan",
                    value: "$totalLahan Petak",
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _infoCard(
                    icon: Icons.store,
                    title: "Stok Makanan",
                    value: "$totalPanen Kg",
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                _quickAction(
                  LucideIcons.map,
                  "Map Lahan",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapLahanPage()),
                  ),
                ),
                _quickAction(
                  LucideIcons.plusCircle,
                  "Tambah Tanaman",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TambahTanamanPage(),
                    ),
                  ),
                ),
                _quickAction(
                  LucideIcons.cloudSun,
                  "Cuaca",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CuacaPage()),
                  ),
                ),
                _quickAction(
                  LucideIcons.fileText,
                  "Report",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SubmitReportPage()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
            _sectionTitle("Panen Terbaru"),
            panenTerbaru.isEmpty
                ? const Text("Masih kosong")
                : Column(
                  children:
                      panenTerbaru
                          .map(
                            (item) => _listItem(
                              item['namaTanaman'] ?? '-',
                              "${item['jumlahPanen']} kg - ${item['tanggalPanen'] ?? ''} - Lokasi: ${item['lokasi'] ?? 'Tidak ada'}",
                            ),
                          )
                          .toList(),
                ),
            const SizedBox(height: 24),
            _sectionTitle("Notifikasi"),
            notifikasi.isEmpty
                ? const Text("Masih kosong")
                : Column(
                  children:
                      notifikasi
                          .map(
                            (item) => _listItem(
                              item['judul'] ?? '-',
                              item['deskripsi'] ?? '-',
                            ),
                          )
                          .toList(),
                ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analisis',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Jadwal'),
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

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
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
      ),
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
