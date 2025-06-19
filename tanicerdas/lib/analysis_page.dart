import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'schedule_page.dart';
import 'setting_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  Map<String, double> kategoriData = {};
  List<FlSpot> timeSeriesSpots = [];
  List<String> timeLabels = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final indexSnapshot =
        await FirebaseFirestore.instance
            .collection('tanaman')
            .doc(uid)
            .collection('_index')
            .get();

    final Map<String, double> kategoriMap = {};
    final Map<String, double> timeSeriesMap = {};

    for (final doc in indexSnapshot.docs) {
      final tanamanSnapshot =
          await FirebaseFirestore.instance
              .collection('tanaman')
              .doc(uid)
              .collection(doc.id)
              .get();

      for (final tanamanDoc in tanamanSnapshot.docs) {
        final data = tanamanDoc.data();
        final jumlah = (data['jumlah'] ?? 0).toDouble();

        DateTime? tanggal;
        final tanggalString = data['tanggalTanam'];
        if (tanggalString is String) {
          try {
            tanggal = DateFormat('d/M/yyyy').parse(tanggalString);
          } catch (_) {
            tanggal = null;
          }
        }

        final jenis = doc.id;
        kategoriMap[jenis] = (kategoriMap[jenis] ?? 0) + jumlah;

        if (tanggal != null) {
          final key =
              '${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}';
          timeSeriesMap[key] = (timeSeriesMap[key] ?? 0) + jumlah;
        }
      }
    }

    kategoriMap.removeWhere((key, value) => value == 0);
    final sortedTimeKeys = timeSeriesMap.keys.toList()..sort();

    setState(() {
      kategoriData = kategoriMap;
      timeLabels = sortedTimeKeys;
      timeSeriesSpots = List.generate(
        sortedTimeKeys.length,
        (i) => FlSpot(i.toDouble(), timeSeriesMap[sortedTimeKeys[i]] ?? 0),
      );
    });
  }

  double getMaxKategoriValue() {
    if (kategoriData.isEmpty) return 10;
    return kategoriData.values.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Pertanian"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _sectionCard(
              title: "Produktivitas per Kategori",
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: _buildKategoriBarData(kategoriData),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final keys = kategoriData.keys.toList();
                            if (value.toInt() < keys.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  keys[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: getMaxKategoriValue() / 4,
                          getTitlesWidget:
                              (value, meta) => Text(value.toInt().toString()),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barTouchData: BarTouchData(enabled: true),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Tren Produktivitas Bulanan",
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: timeSeriesSpots,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < timeLabels.length &&
                                value.toInt() % 2 == 0) {
                              final label = timeLabels[value.toInt()]
                                  .replaceAll('-', '/');
                              return Transform.rotate(
                                angle: -0.4,
                                child: Text(
                                  label,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          getTitlesWidget:
                              (value, meta) => Text('${value.toInt()}'),
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SchedulePage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingPage()),
            );
          }
        },
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

  List<BarChartGroupData> _buildKategoriBarData(Map<String, double> data) {
    int index = 0;
    return data.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.green,
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
