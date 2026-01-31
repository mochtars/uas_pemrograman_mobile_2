class Wisata {
  final String id;
  final String nama;
  final String deskripsi;
  final String lokasi;
  final String imageUrl;
  final double rating;
  final double hargaTiket;
  final String jamBuka;
  final String ditambahkanOleh;
  final String createdByUid;

  Wisata({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.lokasi,
    required this.imageUrl,
    required this.rating,
    required this.hargaTiket,
    required this.jamBuka,
    this.ditambahkanOleh = '',
    this.createdByUid = '',
  });

  String get formatHarga {
    if (hargaTiket == 0) return 'Gratis';
    final str = hargaTiket.toStringAsFixed(0);
    final result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        result.write('.');
      }
    }
    return 'Rp ${result.toString().split('').reversed.join('')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'imageUrl': imageUrl,
      'rating': rating,
      'hargaTiket': hargaTiket,
      'jamBuka': jamBuka,
      'ditambahkanOleh': ditambahkanOleh,
      'createdByUid': createdByUid,
    };
  }

  factory Wisata.fromJson(Map<String, dynamic> json) {
    return Wisata(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      lokasi: json['lokasi'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      hargaTiket: (json['hargaTiket'] ?? 0.0).toDouble(),
      jamBuka: json['jamBuka'] ?? '',
      ditambahkanOleh: json['ditambahkanOleh'] ?? '',
      createdByUid: json['createdByUid'] ?? '',
    );
  }
}
