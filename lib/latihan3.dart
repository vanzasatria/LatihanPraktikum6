import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model untuk merepresentasikan universitas
class University {
  String name;
  String website;

  University({required this.name, required this.website}); // Constructor

  // Konstruktor untuk mengonversi JSON menjadi objek University
  University.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        website = json['web_pages'][0]; // Ambil website pertama dari daftar website
}

// Model untuk menyimpan daftar universitas
class UniversitiesList {
  List<University> universities = [];

  // Konstruktor untuk mengonversi JSON menjadi list universitas
  UniversitiesList.fromJson(List<dynamic> json) {
    universities = json.map((university) {
      return University.fromJson(university);
    }).toList();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<UniversitiesList> futureUniversities;

  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  // Fungsi untuk mengambil data universitas dari API
  Future<UniversitiesList> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika respons berhasil, parse JSON dan kembalikan objek UniversitiesList
      return UniversitiesList.fromJson(jsonDecode(response.body));
    } else {
      // Jika respons tidak berhasil, lempar Exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchData(); // Mulai mengambil data universitas saat initState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities List',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Indonesian Universities'),
        ),
        body: Center(
          child: FutureBuilder<UniversitiesList>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia, tampilkan ListView dengan data universitas
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(), // Tambahkan garis pemisah antara item
                  itemCount: snapshot.data!.universities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.universities[index].name),
                      subtitle: Text(snapshot.data!.universities[index].website),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika terjadi error, tampilkan pesan error
                return Text('${snapshot.error}');
              }
              // Jika masih loading, tampilkan indikator loading
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}