
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BantwaraScreen extends StatefulWidget {
  const BantwaraScreen({super.key});

  @override
  State<BantwaraScreen> createState() => _BantwaraScreenState();
}

class _BantwaraScreenState extends State<BantwaraScreen> {
  final _formKey = GlobalKey<FormState>();
  final districtController = TextEditingController(text: 'Sawai Madhopur');
  final tehsilController = TextEditingController(text: 'Bamanwas');
  final villageController = TextEditingController(text: 'Bantwara');
  final khasraController = TextEditingController();
  final party1Controller = TextEditingController();
  final party2Controller = TextEditingController();
  final rakbaController = TextEditingController();
  String bantwaraType = 'आपसी सहमति से';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft Seva - बंटवारा'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _field('जिला', districtController),
                      _field('तहसील', tehsilController),
                      _field('गांव', villageController),
                      _field('खसरा नंबर', khasraController, hint: 'जैसे 123, 124/1'),
                      _field('कुल रकबा', rakbaController, hint: 'जैसे 2.5 बीघा'),
                      DropdownButtonFormField(
                        value: bantwaraType,
                        decoration: const InputDecoration(labelText: 'बंटवारे का प्रकार'),
                        items: ['आपसी सहमति से', 'परिवारिक बंटवारा', 'खातेदारी बंटवारा'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => bantwaraType = v!),
                      ),
                      _field('पक्ष-1 (नाम पिता सहित)', party1Controller),
                      _field('पक्ष-2 (नाम पिता सहित)', party2Controller),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('बंटवारा Draft PDF बनाओ', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _generatePdf();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
        validator: (v) => v == null || v.isEmpty ? 'जरूरी है' : null,
      ),
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text('बंटवारा नामा (Draft)', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 20),
              pw.Text('जिला: ${districtController.text}  तहसील: ${tehsilController.text}  गांव: ${villageController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('खसरा नंबर: ${khasraController.text}   रकबा: ${rakbaController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('बंटवारे का प्रकार: $bantwaraType'),
              pw.SizedBox(height: 20),
              pw.Text('आज दिनांक ........................... को हम पक्षकारान :-'),
              pw.SizedBox(height: 10),
              pw.Text('1. ${party1Controller.text} (प्रथम पक्ष)'),
              pw.Text('2. ${party2Controller.text} (द्वितीय पक्ष)'),
              pw.SizedBox(height: 20),
              pw.Text(
                'ने आपसी सहमति से उक्त भूमि का बंटवारा निम्न प्रकार तय किया है कि खसरा नंबर ${khasraController.text} रकबा ${rakbaController.text} में से आधा-आधा हिस्सा दोनों पक्षों के कब्जे में रहेगा। भविष्य में कोई पक्ष इस बंटवारे से मुकरेगा नहीं। यह बंटवारा दोनों पक्षों की रजामंदी से किया गया है।',
                style: const pw.TextStyle(lineSpacing: 5),
              ),
              pw.SizedBox(height: 40),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Column(children: [pw.Text('हस्ताक्षर'), pw.Text('प्रथम पक्ष')]),
                pw.Column(children: [pw.Text('हस्ताक्षर'), pw.Text('द्वितीय पक्ष')]),
                pw.Column(children: [pw.Text('गवाह'), pw.Text('................')]),
              ]),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
