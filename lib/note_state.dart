class NoteState {
  final List<Map<String, dynamic>> notes;

  NoteState({required this.notes});

  factory NoteState.initial() {
    return NoteState(notes: []);
  }
}
