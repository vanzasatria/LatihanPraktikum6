import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// Menampung data hasil pemanggilan API
class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); // Constructor

  // Map dari JSON ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Menampung hasil pemanggilan API

  // URL API untuk mendapatkan aktivitas acak
  String url = "https://www.boredapi.com/api/activity";

  // Inisialisasi futureActivity dengan aktivitas kosong
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  // Fungsi untuk melakukan pemanggilan API dan mengambil data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Jika server mengembalikan 200 OK (berhasil),
      // parse JSON dan kembalikan objek Activity
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal (bukan 200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Menginisialisasi futureActivity pada awalnya
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol untuk memicu pemanggilan ulang ke API
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureActivity = fetchData(); // Memperbarui futureActivity dengan hasil pemanggilan API yang baru
                    });
                  },
                  child: Text("Saya bosan ..."),
                ),
              ),
              // Menampilkan aktivitas yang diambil dari API
              FutureBuilder<Activity>(
                future: futureActivity,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Jika data tersedia, tampilkan aktivitas dan jenisnya
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data!.aktivitas),
                          Text("Jenis: ${snapshot.data!.jenis}")
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Jika terjadi error, tampilkan pesan error
                    return Text('${snapshot.error}');
                  }
                  // Default: Tampilkan loading spinner
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}