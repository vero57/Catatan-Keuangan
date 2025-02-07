abstract class NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final Map<String, dynamic> noteData;

  AddNoteEvent(this.noteData);
}

class EditNoteEvent extends NoteEvent {
  final Map<String, dynamic> noteData;
  final int index;

  EditNoteEvent(this.noteData, this.index);
}

class DeleteNoteEvent extends NoteEvent {
  final int index;

  DeleteNoteEvent(this.index);
}
