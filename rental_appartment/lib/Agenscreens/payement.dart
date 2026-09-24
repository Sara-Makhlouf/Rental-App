import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

class RecordPaymentPage extends StatefulWidget {
  const RecordPaymentPage({super.key});

  @override
  State<RecordPaymentPage> createState() => _RecordPaymentPageState();
}

class _RecordPaymentPageState extends State<RecordPaymentPage> {
  final amount = TextEditingController();
  final note = TextEditingController();

  String? selectedTenant;
  DateTime? payDate;

  Future pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (d != null) setState(() => payDate = d);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, sp, child) {
        final isArabic = sp.locale.languageCode == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              title: Text(sp.getLocalizedText("Record Payment", "تسجيل الدفع")),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _title(
                    sp.getLocalizedText("Payment Details", "تفاصيل الدفع"),
                  ),
                  _dropdown(
                    sp.getLocalizedText("Tenant", "المستأجر"),
                    ["Ali Ahmad", "John Doe", "Sara Ibrahim"],
                    (v) => setState(() => selectedTenant = v),
                  ),
                  _field(
                    amount,
                    sp.getLocalizedText("Amount (USD)", "المبلغ (دولار)"),
                    number: true,
                  ),
                  _datePicker(
                    sp.getLocalizedText("Payment Date", "تاريخ الدفع"),
                  ),
                  _textarea(note, sp.getLocalizedText("Notes", "ملاحظات")),
                  SizedBox(height: 30),
                  _saveButton(
                    sp.getLocalizedText("Save", "حفظ"),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _datePicker(String label) => GestureDetector(
    onTap: pickDate,
    child: Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.date_range),
          SizedBox(width: 10),
          Text(
            payDate == null
                ? label
                : "${payDate!.year}-${payDate!.month}-${payDate!.day}",
          ),
        ],
      ),
    ),
  );
}

Widget _title(String text) => Align(
  alignment: Alignment.centerLeft,
  child: Text(
    text,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
);

Widget _field(TextEditingController c, String label, {bool number = false}) =>
    Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );

Widget _textarea(TextEditingController c, String label) => Padding(
  padding: EdgeInsets.only(bottom: 16),
  child: TextField(
    controller: c,
    maxLines: 4,
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
  ),
);

Widget _dropdown(
  String label,
  List<String> items,
  Function(String?) onChange,
) => Padding(
  padding: EdgeInsets.only(bottom: 16),
  child: DropdownButtonFormField(
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: onChange,
  ),
);

Widget _saveButton(String label, {Color color = Colors.blue}) => Container(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: () {},
    child: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
  ),
);
