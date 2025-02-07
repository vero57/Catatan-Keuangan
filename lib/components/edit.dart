import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditNotePage extends StatefulWidget {
  final Map<String, dynamic> noteData;
  final int noteIndex;

  const EditNotePage({super.key, required this.noteData, required this.noteIndex});

  @override
  // ignore: library_private_types_in_public_api
  _EditNotePageState createState() => _EditNotePageState();
}



class _EditNotePageState extends State<EditNotePage> with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descController;
  late String _type;
  late DateTime _selectedDate;

  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteData['title']);
    _descController = TextEditingController(text: widget.noteData['desc']);
    _amountController = TextEditingController(text: "Rp ${NumberFormat("#,##0", "en_US").format(widget.noteData['amount'])}");
    _type = widget.noteData['type'];
    _selectedDate = widget.noteData['date'];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _deleteNote() {
    Navigator.of(context).pop('delete');
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 200, 0),
        content: SlideTransition(
          position: _animation,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Anda ingin menghapusnya?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Apakah anda yakin ingin menghapus catatan ini? Catatan yang dihapus tidak bisa dikembalikan lagi. Pastikan anda memeriksanya kembali',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _deleteNote();
                      },
                      child: const Text(
                        'Saya Yakin',
                        style: 
                          TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    _animationController.forward(from: 0).then((_) {
      _animationController.reverse();
    });
  }



  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 0, 25),
        content: SlideTransition(
          position: _animation,
          child: Container(
            color: const Color.fromARGB(255, 255, 17, 0),
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Oops',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Silahkan lengkapi input nya :)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    _animationController.forward(from: 0).then((_) {
      _animationController.reverse();
    });
  }

  void _submitData() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty || !_isNumeric(_amountController.text.replaceAll("Rp ", "").replaceAll(",", ""))) {
      _showErrorDialog();
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredDesc = _descController.text;
    final enteredAmount = int.parse(_amountController.text.replaceAll("Rp ", "").replaceAll(",", ""));

    Navigator.of(context).pop({
      'title': enteredTitle,
      'amount': enteredAmount,
      'desc': enteredDesc,
      'date': _selectedDate,
      'type': _type,
    });
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _formatAmount(String value) {
    String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) {
      _amountController.text = "Rp ";
      return;
    }
    final formatter = NumberFormat("#,##0", "en_US");
    final formattedValue = formatter.format(int.parse(cleanValue));
    _amountController.value = TextEditingValue(
      text: "Rp $formattedValue",
      selection: TextSelection.collapsed(offset: "Rp $formattedValue".length),
    );
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    _selectedDate == null
                        ? 'Tidak ada tanggal yang dipilih!'
                        : 'Tanggal: ${DateFormat.yMd().format(_selectedDate)}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                hintText: 'Masukkan judul catatan',
              ),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Uang',
                hintText: 'Masukkan jumlah (contoh: 10,000)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              onChanged: _formatAmount,
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Deskripsi (Opsional)',
              ),
            ),
            DropdownButton<String>(
              value: _type,
              onChanged: (String? newValue) {
                setState(() {
                  _type = newValue!;
                });
              },
              items: <String>['Pemasukan', 'Pengeluaran']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showDeleteDialog, 
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    side: WidgetStateProperty.all(const BorderSide(
                      color: Colors.red, 
                      width: 2,
                    )),
                    shadowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
                    elevation: WidgetStateProperty.all(5), 
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    foregroundColor: WidgetStateProperty.all(Colors.white), 
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.red.shade700;
                        }
                        return null;
                      },
                    ),
                  ),
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    shadowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
                    elevation: WidgetStateProperty.all(5),
                    backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 0, 65, 10)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return const Color.fromARGB(128, 0, 255, 21);
                        }
                        return null;
                      },
                    ),
                  ),
                  child: const Text('Save'),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
