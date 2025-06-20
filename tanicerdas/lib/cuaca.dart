import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CuacaPage extends StatefulWidget {
  const CuacaPage({super.key});

  @override
  State<CuacaPage> createState() => _CuacaPageState();
}

class _CuacaPageState extends State<CuacaPage> {
  Map<String, dynamic>? weatherData;
  List<dynamic> forecastList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    const String apiKey =
        'f9d074ec95f06e27d8417c110d430115'; // Ganti dengan API key OpenWeatherMap kamu
    const String city = 'Padang';

    final currentUrl = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=id',
    );
    final forecastUrl = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=id',
    );

    try {
      final currentRes = await http.get(currentUrl);
      final forecastRes = await http.get(forecastUrl);

      if (currentRes.statusCode == 200 && forecastRes.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(currentRes.body);
          forecastList = jsonDecode(forecastRes.body)['list'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat data cuaca';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: const Text('Cuaca', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCuacaSaatIni(),
                    const SizedBox(height: 24),
                    const Text(
                      'Perkiraan Cuaca',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...forecastList
                        .take(4)
                        .map((item) => _buildForecastCard(item))
                        .toList(),
                  ],
                ),
              ),
    );
  }

  Widget _buildCuacaSaatIni() {
    final name = weatherData?['name'] ?? '-';
    final temp = weatherData?['main']?['temp']?.toStringAsFixed(0) ?? '--';
    final description =
        weatherData?['weather']?[0]?['description'] ?? 'Tidak tersedia';

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
              children: [
                const Text(
                  "Cuaca Saat Ini",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(name),
                Text(description),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(
                Icons.wb_sunny_rounded,
                size: 48,
                color: Colors.orange,
              ),
              const SizedBox(height: 4),
              Text(
                "$temp°C",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(dynamic item) {
    final dateTime = item['dt_txt'] ?? '';
    final temp = item['main']['temp'].toStringAsFixed(0);
    final desc = item['weather'][0]['description'];
    final iconCode = item['weather'][0]['icon'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Image.network(
          'https://openweathermap.org/img/wn/$iconCode@2x.png',
        ),
        title: Text("$desc - $temp°C"),
        subtitle: Text(dateTime),
      ),
    );
  }
}
