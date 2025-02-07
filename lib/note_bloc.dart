import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteState.initial()) {
    on<AddNoteEvent>(_onAddNote);
    on<EditNoteEvent>(_onEditNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  void _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) {
    final updatedNotes = [
      ...state.notes,
      {
        ...event.noteData,
        'color': _randomColor(),
        'amount': (event.noteData['amount'] is int)
            ? (event.noteData['amount'] as int).toDouble()
            : event.noteData['amount'],
      }
    ];
    emit(NoteState(notes: updatedNotes));
  }

  void _onEditNote(EditNoteEvent event, Emitter<NoteState> emit) {
    final updatedNotes = [...state.notes];
    updatedNotes[event.index] = {
      ...event.noteData,
      'color': updatedNotes[event.index]['color'],
      'amount': (event.noteData['amount'] is int)
          ? (event.noteData['amount'] as int).toDouble()
          : event.noteData['amount'],
    };
    emit(NoteState(notes: updatedNotes));
  }

  void _onDeleteNote(DeleteNoteEvent event, Emitter<NoteState> emit) {
    final updatedNotes = [...state.notes];
    updatedNotes.removeAt(event.index);
    emit(NoteState(notes: updatedNotes));
  }

  Color _randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
