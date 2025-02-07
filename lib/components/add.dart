import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController(text: "Rp ");
  String _type = 'Pemasukan';
  DateTime _selectedDate = DateTime.now();

  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.1),
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 0, 25),
        content: SlideTransition(
          position: _animation,
          child: const Padding(
            // color: Colors.red,
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
      'desc': enteredDesc,
      'amount': enteredAmount,
      'date': _selectedDate,
      'type': _type,
    });
  }

  bool _isNumeric(String str) {
    // ignore: unnecessary_null_comparison
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
        title: const Text('Tambah Catatan'),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitData,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  side: WidgetStateProperty.all(const BorderSide(
                    color: Colors.blue, 
                    width: 2,
                  )),
                  shadowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
                  elevation: WidgetStateProperty.all(5),
                  backgroundColor: WidgetStateProperty.all(Colors.blue), 
                  foregroundColor: WidgetStateProperty.all(Colors.white), 
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.blue.shade700; 
                      }
                      return null; 
                    },
                  ),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
