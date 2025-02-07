import 'package:catatan_keuangan/components/add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_bloc.dart';
import 'components/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Keuangan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => NoteBloc(),
        child: const HomePage(),
      ),
      routes: {
        '/add': (context) => AddNotePage(),
      },
    );
  }
}


