import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_page.dart'; // Import home page untuk navigasi
import 'schedule_page.dart'; // Import schedule page
import 'setting_page.dart'; // Import setting page

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Pertanian"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dropdownFilter("Semua Lahan"),
                _dropdownFilter("30 Hari Terakhir"),
              ],
            ),

            const SizedBox(height: 24),

            // Produktivitas Trend
            _sectionCard(
              title: "Produktivitas Trend",
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: true),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 30),
                          FlSpot(1, 35),
                          FlSpot(2, 33),
                          FlSpot(3, 50),
                          FlSpot(4, 50),
                          FlSpot(5, 60),
                          FlSpot(6, 70),
                        ],
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Performa Lahan
            _sectionCard(
              title: "Performa Lahan",
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      _barGroup(0, 400),
                      _barGroup(1, 430),
                      _barGroup(2, 448),
                      _barGroup(3, 470),
                      _barGroup(4, 540),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                      topTitles: AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Utara");
                              case 1:
                                return const Text("Timur");
                              case 2:
                                return const Text("Barat");
                              case 3:
                                return const Text("Selatan");
                              case 4:
                                return const Text("Pusat");
                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Analisis Stok Makanan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Analisis Stok Makanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("Lihat Semua", style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            _stockItem("Gandum", "2.5M ton", Icons.local_florist),
            _stockItem("Padi", "1.8M ton", Icons.grass),
            _stockItem("Jagung", "3.2M ton", Icons.emoji_nature),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Index untuk halaman analysis
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Navigasi sesuai dengan item yang dipilih
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
          // Jika index 1 (halaman saat ini), tidak melakukan apa-apa
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

  Widget _dropdownFilter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [Text(label), const Icon(Icons.keyboard_arrow_down)],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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

  static BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.green,
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      ],
    );
  }

  Widget _stockItem(String name, String amount, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(name),
        subtitle: Text(amount),
        trailing: SizedBox(
          width: 60,
          height: 30,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 1),
                    FlSpot(1, 1.2),
                    FlSpot(2, 1.4),
                    FlSpot(3, 1.3),
                    FlSpot(4, 1.6),
                  ],
                  isCurved: true,
                  barWidth: 2,
                  color: Colors.green,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(show: false),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}
