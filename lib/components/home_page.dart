import 'package:catatan_keuangan/components/edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../note_bloc.dart';
import '../note_event.dart';
import '../note_state.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Keuangan')),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state.notes.isEmpty) {
            return const Center(
              child: Text('Belum ada catatan. Tambahkan catatan dengan menekan tombol +'),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: state.notes.length,
            itemBuilder: (ctx, index) {
              final note = state.notes[index];
              final color = note['type'] == 'Pemasukan'
                  ? Colors.green[100]
                  : Colors.red[100];
              final textColor = note['type'] == 'Pemasukan'
                  ? Colors.green
                  : Colors.red;

              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNotePage(
                        noteData: note,
                        noteIndex: index,
                      ),
                    ),
                  );

                  if (result != null) {
                    if (result == 'delete') {
                      context.read<NoteBloc>().add(DeleteNoteEvent(index));
                    } else {
                      context.read<NoteBloc>().add(EditNoteEvent(result, index));
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('Tanggal: ${DateFormat.yMd().format(note['date'])}'),
                      Text(
                        note['desc'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Rp ${NumberFormat("#,##0", "en_US").format(note['amount'])}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/add');
          if (result != null) {
            context.read<NoteBloc>().add(AddNoteEvent(result as Map<String, dynamic>));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


