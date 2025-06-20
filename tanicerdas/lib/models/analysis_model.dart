class Analysis {
  final String id;
  final int totalLahan;
  final int totalPanen;
  final Map<String, int> jenisTanamanPerBulan;
  final Map<String, double> panenPerBulan;
  final String userId;

  Analysis({
    required this.id,
    required this.totalLahan,
    required this.totalPanen,
    required this.jenisTanamanPerBulan,
    required this.panenPerBulan,
    required this.userId,
  });

  factory Analysis.fromMap(Map<String, dynamic> map, String docId) {
    return Analysis(
      id: docId,
      totalLahan: map['totalLahan'],
      totalPanen: map['totalPanen'],
      jenisTanamanPerBulan: Map<String, int>.from(map['jenisTanamanPerBulan']),
      panenPerBulan: Map<String, double>.from(map['panenPerBulan']),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalLahan': totalLahan,
      'totalPanen': totalPanen,
      'jenisTanamanPerBulan': jenisTanamanPerBulan,
      'panenPerBulan': panenPerBulan,
      'userId': userId,
    };
  }
}
