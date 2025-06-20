import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'admin_reports_page.dart';
import 'admin_analysis_page.dart';
import 'admin_members_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  int totalUsers = 0;
  List<String> months = [];
  Map<String, List<double>> productionData = {};
  double totalStock = 0;
  List<Map<String, dynamic>> recentReports = [];

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final allTanamanSnapshot =
        await FirebaseFirestore.instance.collection('alltamanan').get();
    final allReportSnapshot =
        await FirebaseFirestore.instance
            .collection('allreport')
            .orderBy('createdAt', descending: true)
            .limit(3)
            .get();

    Map<String, List<double>> tempProd = {};
    Set<String> bulanSet = {};
    double total = 0;

    for (var doc in allTanamanSnapshot.docs) {
      final data = doc.data();
      final jenis = data['jenis']?.toString().toLowerCase() ?? 'lainnya';
      final jumlah = (data['jumlah'] ?? 0).toDouble();
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

      if (createdAt != null) {
        final key =
            "${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}";
        bulanSet.add(key);
        tempProd[jenis] ??= List.filled(6, 0);
      }
      total += jumlah;
    }

    months = bulanSet.toList().reversed.take(6).toList().reversed.toList();
    for (var key in tempProd.keys) {
      tempProd[key] = List.filled(months.length, 0);
    }

    for (var doc in allTanamanSnapshot.docs) {
      final data = doc.data();
      final jenis = data['jenis']?.toString().toLowerCase() ?? 'lainnya';
      final jumlah = (data['jumlah'] ?? 0).toDouble();
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      final key =
          createdAt != null
              ? "${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}"
              : '';
      final idx = months.indexOf(key);
      if (idx != -1) {
        tempProd[jenis]![idx] += jumlah;
      }
    }

    setState(() {
      totalUsers = usersSnapshot.docs.length;
      productionData = tempProd;
      totalStock = total;
      recentReports = allReportSnapshot.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text("Admin Dashboard"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatCard(
            "Petani Terdaftar",
            totalUsers.toString(),
            "+12 bulan ini",
            Icons.person_outline,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildProductionChart(),
          const SizedBox(height: 16),
          _buildStockStatus(),
          const SizedBox(height: 16),
          _buildRecentReports(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminReportsPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminAnalysisPage(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminMembersPage()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Laporan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analysis",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Anggota"),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(subtitle, style: TextStyle(color: color)),
            ],
          ),
          Icon(icon, color: color, size: 40),
        ],
      ),
    );
  }

  Widget _buildProductionChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Produksi Pertanian (ton)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        return idx >= 0 && idx < months.length
                            ? Text(months[idx])
                            : const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget:
                          (value, meta) => Text(value.toInt().toString()),
                    ),
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                lineBarsData:
                    productionData.entries.map((entry) {
                      final color =
                          entry.key.contains("padi")
                              ? Colors.green
                              : entry.key.contains("jagung")
                              ? Colors.amber
                              : Colors.blue;
                      return LineChartBarData(
                        spots: List.generate(
                          entry.value.length,
                          (i) => FlSpot(i.toDouble(), entry.value[i]),
                        ),
                        isCurved: true,
                        color: color,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status Stok Pangan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "${totalStock.toStringAsFixed(1)} kg tersedia",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (totalStock / 1000).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReports() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Laporan Terbaru",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...recentReports.map((report) {
            final judul = report['judul'] ?? '-';
            final kategori = report['kategori'] ?? '-';
            final lokasi = report['lokasi'] ?? '-';
            final tanggal = (report['tanggal'] as Timestamp?)?.toDate();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(judul),
                subtitle: Text("$kategori di $lokasi"),
                trailing: Text(
                  tanggal != null
                      ? "${tanggal.day}/${tanggal.month}/${tanggal.year}"
                      : "-",
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
