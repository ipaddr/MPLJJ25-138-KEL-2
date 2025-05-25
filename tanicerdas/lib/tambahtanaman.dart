import 'package:flutter/material.dart';

class TambahTanamanPage extends StatelessWidget {
  const TambahTanamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController jumlahController = TextEditingController();
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController namaLahanController = TextEditingController();
    final TextEditingController catatanController = TextEditingController();

    String? tipeTanaman;
    String? lokasiDaerah;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tanaman'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFE8F5E9),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukan Informasi Tanaman',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Dropdown Tipe Tanaman
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipe',
                hintText: 'Pilih Tanaman',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Padi', child: Text('Padi')),
                DropdownMenuItem(value: 'Jagung', child: Text('Jagung')),
              ],
              onChanged: (value) {
                tipeTanaman = value;
              },
            ),
            const SizedBox(height: 16),

            // Jumlah Tanaman
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Tanaman (kg)',
                hintText: 'Masukan Jumlah',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.scale),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Tanam
            TextField(
              controller: tanggalController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Tanam',
                hintText: 'hh/bb/tttt',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  tanggalController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 16),

            // Lokasi
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                hintText: 'Pilih Daerah',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Padang', child: Text('Padang')),
                DropdownMenuItem(
                  value: 'Bukittinggi',
                  child: Text('Bukittinggi'),
                ),
              ],
              onChanged: (value) {
                lokasiDaerah = value;
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: namaLahanController,
              decoration: const InputDecoration(
                labelText: 'Nama Lahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Catatan Tambahan
            TextField(
              controller: catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Catatan Tambahan',
                hintText: 'Informasi Tambahan',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),

            // Tombol Masukkan Data
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Masukan Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Tambahkan aksi saat tombol ditekan
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
