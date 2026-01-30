class Wisata {
  final String id;
  final String nama;
  final String deskripsi;
  final String lokasi;
  final String imageUrl;
  final double rating;
  final double hargaTiket;
  final String jamBuka;

  Wisata({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.lokasi,
    required this.imageUrl,
    required this.rating,
    required this.hargaTiket,
    required this.jamBuka,
  });

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
    );
  }
}
