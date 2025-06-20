import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String id;
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final String userId;

  Schedule({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.userId,
  });

  factory Schedule.fromMap(Map<String, dynamic> map, String docId) {
    return Schedule(
      id: docId,
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      tanggal: (map['tanggal'] as Timestamp).toDate(),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'userId': userId,
    };
  }
}
