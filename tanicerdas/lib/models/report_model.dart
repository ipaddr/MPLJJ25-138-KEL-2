import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String idReport;
  final String tipeReport; // panen, rusak, stock
  final DateTime tanggal;
  final String lokasi;
  final String deskripsi;
  final String fotoLahan;
  final List<String> historiReport;
  final String filePdf;
  final String userId;

  Report({
    required this.id,
    required this.idReport,
    required this.tipeReport,
    required this.tanggal,
    required this.lokasi,
    required this.deskripsi,
    required this.fotoLahan,
    required this.historiReport,
    required this.filePdf,
    required this.userId,
  });

  factory Report.fromMap(Map<String, dynamic> map, String docId) {
    return Report(
      id: docId,
      idReport: map['idReport'],
      tipeReport: map['tipeReport'],
      tanggal: (map['tanggal'] as Timestamp).toDate(),
      lokasi: map['lokasi'],
      deskripsi: map['deskripsi'],
      fotoLahan: map['fotoLahan'],
      historiReport: List<String>.from(map['historiReport']),
      filePdf: map['filePdf'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idReport': idReport,
      'tipeReport': tipeReport,
      'tanggal': tanggal,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'fotoLahan': fotoLahan,
      'historiReport': historiReport,
      'filePdf': filePdf,
      'userId': userId,
    };
  }
}
