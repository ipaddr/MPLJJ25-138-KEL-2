// submit_report_page.dart (Tanpa Dropdown Nama Tanaman)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubmitReportPage extends StatefulWidget {
  const SubmitReportPage({super.key});

  @override
  State<SubmitReportPage> createState() => _SubmitReportPageState();
}

class _SubmitReportPageState extends State<SubmitReportPage> {
  String selectedCategory = 'Panen';
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _jumlahPanenController = TextEditingController();
  final TextEditingController _namaTanamanController = TextEditingController();
  String? selectedLahan;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  List<String> lahanOptions = [];
  List<Map<String, dynamic>> previousReports = [];

  @override
  void initState() {
    super.initState();
    fetchLahanOptions();
    fetchPreviousReports();
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

  Future<void> fetchPreviousReports() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(uid)
            .collection('report_user')
            .orderBy('tanggal', descending: true)
            .get();

    setState(() {
      previousReports = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> submitReport() async {
    if (selectedDate == null ||
        selectedLahan == null ||
        _judulController.text.isEmpty)
      return;

    await FirebaseFirestore.instance
        .collection('reports')
        .doc(uid)
        .collection('report_user')
        .add({
          'kategori': selectedCategory,
          'judul': _judulController.text,
          'tanggal': selectedDate,
          'lokasi': selectedLahan,
          'deskripsi': _descController.text,
          'namaTanaman': _namaTanamanController.text,
          'jumlahPanen': _jumlahPanenController.text,
          'uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Report berhasil dikirim!')));

    _judulController.clear();
    _descController.clear();
    _dateController.clear();
    _jumlahPanenController.clear();
    _namaTanamanController.clear();
    setState(() {
      selectedLahan = null;
      selectedDate = null;
    });

    fetchPreviousReports();
  }

  Widget _categoryButton(String label, IconData icon) {
    final bool isSelected = selectedCategory == label;
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, color: isSelected ? Colors.white : Colors.black),
        label: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            selectedCategory = label;
          });
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: readOnly ? const Icon(Icons.calendar_today) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildLahanDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedLahan,
      items:
          lahanOptions
              .map(
                (lahan) => DropdownMenuItem(value: lahan, child: Text(lahan)),
              )
              .toList(),
      decoration: const InputDecoration(
        labelText: 'Lokasi Lahan',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          selectedLahan = value;
        });
      },
    );
  }

  Widget _buildPreviousReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "Report Sebelumnya",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...previousReports.map((report) {
          final kategori = report['kategori'] ?? 'Tidak Diketahui';
          final isPanen = kategori == 'Panen';
          final judul = report['judul'] ?? 'Tanpa Judul';
          final lokasi = report['lokasi'] ?? 'Lokasi tidak tersedia';
          final tanggal =
              report['tanggal'] is Timestamp
                  ? DateFormat(
                    'yyyy-MM-dd',
                  ).format((report['tanggal'] as Timestamp).toDate())
                  : 'Tanggal tidak tersedia';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPanen ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    kategori,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPanen ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lokasi,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  tanggal,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Report'),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _categoryButton("Panen", Icons.local_florist),
                const SizedBox(width: 8),
                _categoryButton("Rusak", Icons.bug_report),
                const SizedBox(width: 8),
                _categoryButton("Stock", Icons.inventory),
              ],
            ),
            _buildTextField(
              "Tanggal",
              _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 12),
            _buildTextField("Judul Report", _judulController),
            const SizedBox(height: 12),
            _buildLahanDropdown(),
            _buildTextField("Nama Tanaman", _namaTanamanController),
            _buildTextField("Jumlah Panen (kg)", _jumlahPanenController),
            _buildTextField("Deskripsi", _descController, maxLines: 3),
            _buildPreviousReports(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: submitReport,
                child: const Text(
                  "Submit Report",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
