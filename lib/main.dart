import 'dart:convert';

void main() {
  // JSON transkrip mahasiswa
  String transkripJson = '''
  {
    "nama": "Vanza Satria Pringga Pratma",
    "nim": "22082010032",
    "program_studi": "Sistem Informasi",
    "mata_kuliah": [
      {
        "kode": "SI101",
        "nama": "Pemrograman Desktop",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode": "SI102",
        "nama": "Interaksi Manusia Komputer",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "SI103",
        "nama": "Metodologi Penelitian",
        "sks": 2,
        "nilai": "A-"
      },
      {
        "kode": "SI104",
        "nama": "Bahasa Pemrograman",
        "sks": 3,
        "nilai": "B"
      }
    ]
  }
  ''';

  // Menampilkan transkrip
  Map<String, dynamic> transkrip = json.decode(transkripJson);
  print('Transkrip Mahasiswa:');
  print('Nama: ${transkrip['nama']}');
  print('NIM: ${transkrip['nim']}');
  print('Program Studi: ${transkrip['program_studi']}');
  print('Mata Kuliah:');

  // Mengiterasi setiap mata kuliah dalam transkrip
  for (var mataKuliah in transkrip['mata_kuliah']) {
    print('  - ${mataKuliah['nama']}: ${mataKuliah['nilai']}');
  }
  print('');

  // Hitung IPK
  double ipk = hitungIPK(transkrip);
  print('IPK: $ipk');
}

// Fungsi untuk menghitung IPK dari transkrip
double hitungIPK(Map<String, dynamic> transkrip) {
  int totalSKS = 0;
  double totalNilai = 0;

  // Mengiterasi setiap mata kuliah dalam transkrip
  for (var mataKuliah in transkrip['mata_kuliah']) {
    int sks = mataKuliah['sks']; // Mendapatkan jumlah SKS dari mata kuliah
    String nilai = mataKuliah['nilai']; // Mendapatkan nilai huruf dari mata kuliah

    // Konversi nilai huruf menjadi bobot
    double bobot;
    switch (nilai) {
      case 'A':
        bobot = 4.0;
        break;
      case 'A-':
        bobot = 3.7;
        break;
      case 'B+':
        bobot = 3.3;
        break;
      case 'B':
        bobot = 3.0;
        break;
      case 'B-':
        bobot = 2.7;
        break;
      case 'C+':
        bobot = 2.3;
        break;
      case 'C':
        bobot = 2.0;
        break;
      case 'C-':
        bobot = 1.7;
        break;
      case 'D':
        bobot = 1.0;
        break;
      default:
        bobot = 0.0;
    }

    // Menambahkan total nilai dan total SKS
    totalNilai += bobot * sks;
    totalSKS += sks;
  }

  // Mengembalikan IPK
  return totalSKS == 0 ? 0 : totalNilai / totalSKS;
}