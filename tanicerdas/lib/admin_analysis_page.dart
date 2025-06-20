import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'chatbot_screen.dart';

class AdminAnalysisPage extends StatefulWidget {
  const AdminAnalysisPage({super.key});

  @override
  State<AdminAnalysisPage> createState() => _AdminAnalysisPageState();
}

class _AdminAnalysisPageState extends State<AdminAnalysisPage> {
  final int _selectedIndex = 2;
  List<BarChartGroupData> _barGroups = [];
  List<FlSpot> _timeSeriesSpots = [];
  List<String> _barLabels = [];
  List<String> _timeLabels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('alltamanan').get();
    final docs = snapshot.docs;

    // Bar Chart: jumlah per namaTanaman
    final Map<String, int> counts = {};
    for (var doc in docs) {
      final data = doc.data();
      final nama = data['namaTanaman'] ?? 'Unknown';
      counts[nama] = (counts[nama] ?? 0) + 1;
    }

    _barLabels = counts.keys.toList();
    _barGroups =
        counts.entries.toList().asMap().entries.map((entry) {
          int x = entry.key;
          int count = entry.value.value;
          return BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(toY: count.toDouble(), color: Colors.green),
            ],
          );
        }).toList();

    // Time Series: jumlah per bulan dari createdAt
    final Map<String, int> monthlyCounts = {};
    for (var doc in docs) {
      final data = doc.data();
      Timestamp? timestamp = data['createdAt'];
      if (timestamp != null) {
        final date = timestamp.toDate();
        final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
        monthlyCounts[key] = (monthlyCounts[key] ?? 0) + 1;
      }
    }

    final sortedKeys = monthlyCounts.keys.toList()..sort();
    _timeLabels = sortedKeys;
    _timeSeriesSpots =
        sortedKeys.asMap().entries.map((entry) {
          int index = entry.key;
          int value = monthlyCounts[entry.value]!;
          return FlSpot(index.toDouble(), value.toDouble());
        }).toList();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text(
          "Analisis Pertanian",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jumlah per Tanaman",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: _barGroups,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < _barLabels.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(_barLabels[index]),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Trend Tanaman Dibuat",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _timeSeriesSpots,
                              isCurved: true,
                              color: Colors.green,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < _timeLabels.length) {
                                    return Text(
                                      _timeLabels[index].replaceAll('-', '/'),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    // Tambahan tombol Tanya AI di sini
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatBotScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text("Tanya AI"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != _selectedIndex) {
            Navigator.pop(context);
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
}
