// schedule_page.dart dengan Form Tambah Jadwal dan Firestore Integration + Hapus Jadwal
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'analysis_page.dart';
import 'setting_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedDay = DateTime.now().day;
  DateTime? selectedDate;
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  void _openAddScheduleDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Tambah Jadwal"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Kegiatan',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _jenisController,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kegiatan',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : "Pilih Tanggal",
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _judulController.clear();
                  _descController.clear();
                  _jenisController.clear();
                  selectedDate = null;
                },
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_judulController.text.isNotEmpty &&
                      selectedDate != null &&
                      uid != null) {
                    await FirebaseFirestore.instance
                        .collection('schedule')
                        .doc(uid)
                        .collection('items')
                        .add({
                          'judulKegiatan': _judulController.text,
                          'jenisKegiatan': _jenisController.text,
                          'deskripsi': _descController.text,
                          'tanggal': Timestamp.fromDate(selectedDate!),
                          'createdAt': Timestamp.now(),
                        });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Jadwal berhasil ditambahkan"),
                      ),
                    );
                    _judulController.clear();
                    _descController.clear();
                    _jenisController.clear();
                    selectedDate = null;
                    setState(() {});
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  void _deleteSchedule(String docId) async {
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(uid)
        .collection('items')
        .doc(docId)
        .delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Jadwal berhasil dihapus")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        title: const Text(
          "Jadwal Kegiatan",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDatePicker(),
            const SizedBox(height: 20),
            const Text(
              "Schedule ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            uid == null
                ? const Center(child: Text("User belum login"))
                : StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('schedule')
                          .doc(uid)
                          .collection('items')
                          .orderBy('tanggal')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!.docs;
                    return Column(
                      children:
                          data.map((doc) {
                            final tanggal =
                                (doc['tanggal'] as Timestamp).toDate();
                            return Dismissible(
                              key: Key(doc.id),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed:
                                  (direction) => _deleteSchedule(doc.id),
                              child: _buildTaskItem(
                                doc['judulKegiatan'] ?? '',
                                DateFormat('yyyy-MM-dd').format(tanggal),
                                LucideIcons.calendar,
                                Colors.green.shade100,
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScheduleDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalysisPage()),
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

  Widget _buildDatePicker() {
    final today = DateTime.now().day;
    final days = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
    final dates = List<int>.generate(30, (index) => index + 1);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final weekdayIndex = (index + 1) % 7;
          final isSelected = dates[index] == _selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = dates[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  Text(
                    days[weekdayIndex],
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.green.shade100
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dates[index].toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.green : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
