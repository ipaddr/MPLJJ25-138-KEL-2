import 'package:cloud_firestore/cloud_firestore.dart';

class Tanaman {
  final String id;
  final String tipe;
  final int jumlah;
  final DateTime tanggalTanam;
  final String daerah;
  final String namaLahan;
  final String catatan;
  final String userId;

  Tanaman({
    required this.id,
    required this.tipe,
    required this.jumlah,
    required this.tanggalTanam,
    required this.daerah,
    required this.namaLahan,
    required this.catatan,
    required this.userId,
  });

  factory Tanaman.fromMap(Map<String, dynamic> map, String docId) {
    return Tanaman(
      id: docId,
      tipe: map['tipe'],
      jumlah: map['jumlah'],
      tanggalTanam: (map['tanggalTanam'] as Timestamp).toDate(),
      daerah: map['daerah'],
      namaLahan: map['namaLahan'],
      catatan: map['catatan'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipe': tipe,
      'jumlah': jumlah,
      'tanggalTanam': tanggalTanam,
      'daerah': daerah,
      'namaLahan': namaLahan,
      'catatan': catatan,
      'userId': userId,
    };
  }
}
