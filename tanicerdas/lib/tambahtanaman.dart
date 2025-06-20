import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TambahTanamanPage extends StatefulWidget {
  const TambahTanamanPage({super.key});

  @override
  State<TambahTanamanPage> createState() => _TambahTanamanPageState();
}

class _TambahTanamanPageState extends State<TambahTanamanPage> {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();
  final TextEditingController tipeTanamanController = TextEditingController();

  String? tipeTanaman;
  String? namaLahan;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> lahanOptions = [];

  @override
  void initState() {
    super.initState();
    fetchLahanOptions();
  }

  Future<void> fetchLahanOptions() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('lahan')
            .doc(uid)
            .collection('items')
            .get();

    setState(() {
      lahanOptions =
          snapshot.docs.map((doc) => doc.data()['nama'] as String).toList();
    });
  }

  Future<void> submitTanaman() async {
    final namaTanaman = tipeTanaman?.trim().toLowerCase();
    if (namaTanaman == null || namaTanaman.isEmpty || namaLahan == null) return;

    final tanamanRef = FirebaseFirestore.instance
        .collection('tanaman')
        .doc(uid)
        .collection(namaTanaman);

    await tanamanRef.add({
      'jumlah': double.tryParse(jumlahController.text) ?? 0,
      'tanggalTanam': tanggalController.text,
      'catatan': catatanController.text,
      'namaLahan': namaLahan,
      'createdAt': FieldValue.serverTimestamp(),
      'uid': uid,
    });

    // Tambahkan ke koleksi _index agar bisa dibaca di halaman lain
    final indexRef = FirebaseFirestore.instance
        .collection('tanaman')
        .doc(uid)
        .collection('_index')
        .doc(namaTanaman);

    await indexRef.set({
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Simpan juga ke koleksi alltanaman (global data tanaman per user)
    final allTanamanRef = FirebaseFirestore.instance.collection('alltamanan');

    await allTanamanRef.add({
      'uid': uid,
      'namaTanaman': namaTanaman,
      'jumlah': double.tryParse(jumlahController.text) ?? 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data tanaman berhasil ditambahkan!')),
    );

    jumlahController.clear();
    tanggalController.clear();
    catatanController.clear();
    tipeTanamanController.clear();
    setState(() {
      tipeTanaman = null;
      namaLahan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Masukkan Informasi Tanaman',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Input Nama Tanaman
            TextField(
              controller: tipeTanamanController,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                hintText: 'Masukkan Nama Tanaman',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => tipeTanaman = value),
            ),
            const SizedBox(height: 16),

            // Jumlah Tanaman
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Tanaman (kg)',
                hintText: 'Masukkan Jumlah',
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

            // Nama Lahan Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Nama Lahan',
                border: OutlineInputBorder(),
              ),
              value: namaLahan,
              items:
                  lahanOptions
                      .map(
                        (lahan) =>
                            DropdownMenuItem(value: lahan, child: Text(lahan)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => namaLahan = value),
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
                label: const Text('Masukkan Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: submitTanaman,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
