import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapLahanPage extends StatefulWidget {
  const MapLahanPage({super.key});

  @override
  State<MapLahanPage> createState() => _MapLahanPageState();
}

class _MapLahanPageState extends State<MapLahanPage> {
  final String uid = 'DQ6PLYeoBvOEPLVIALceLFlQqZu2';
  late CollectionReference lahanRef;
  late DocumentReference analysisRef;
  List<DocumentSnapshot> lahanList = [];

  @override
  void initState() {
    super.initState();
    lahanRef = FirebaseFirestore.instance
        .collection('lahan')
        .doc(uid)
        .collection('items');
    analysisRef = FirebaseFirestore.instance.collection('analysis').doc(uid);
    fetchLahan();
  }

  Future<void> fetchLahan() async {
    final snapshot =
        await lahanRef.orderBy('createdAt', descending: true).get();
    setState(() {
      lahanList = snapshot.docs;
    });
  }

  Future<void> updateTotalLahan() async {
    final snapshot = await lahanRef.get();
    final total = snapshot.size;

    await analysisRef.set({'totalLahan': total}, SetOptions(merge: true));
  }

  Future<void> addLahanDialog() async {
    final _formKey = GlobalKey<FormState>();
    String nama = '';
    double luas = 0;
    bool produktif = true;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Tambah Lahan"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nama Lahan"),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Wajib diisi'
                                : null,
                    onSaved: (value) => nama = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Luas (hektar)",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Wajib diisi';
                      if (double.tryParse(value) == null) return 'Harus angka';
                      return null;
                    },
                    onSaved: (value) => luas = double.parse(value!),
                  ),
                  Row(
                    children: [
                      StatefulBuilder(
                        builder:
                            (context, setStateInner) => Checkbox(
                              value: produktif,
                              onChanged:
                                  (val) => setStateInner(() {
                                    produktif = val ?? true;
                                  }),
                            ),
                      ),
                      const Text("Produktif"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  await lahanRef.add({
                    'nama': nama,
                    'luas': luas,
                    'produktif': produktif,
                    'uid': uid,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  await updateTotalLahan();

                  Navigator.pop(context);
                  fetchLahan();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteLahan(String docId) async {
    await lahanRef.doc(docId).delete();
    await updateTotalLahan();
    fetchLahan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "TaniCerdas",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: lahanList.length,
              itemBuilder: (context, index) {
                final data = lahanList[index].data() as Map<String, dynamic>;
                return _buildLahanCard(data, lahanList[index].id);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: addLahanDialog,
                    child: const Text("Tambah Lahan"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLahanCard(Map<String, dynamic> data, String docId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.agriculture, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['nama'] ?? 'Nama Lahan',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  "Luas: ${data['luas']} hektar",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        data['produktif'] == true
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data['produktif'] == true ? 'Produktif' : 'Tidak Produktif',
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          data['produktif'] == true
                              ? Colors.green
                              : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteLahan(docId),
          ),
        ],
      ),
    );
  }
}
