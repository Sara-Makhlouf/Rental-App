import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

class AddTenantPage extends StatefulWidget {
  const AddTenantPage({super.key});

  @override
  State<AddTenantPage> createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final rent = TextEditingController();
  final notes = TextEditingController();

  DateTime? startDate;
  String? selectedUnit;

  Future pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (d != null) setState(() => startDate = d);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (BuildContext context, value, Widget? child) {
        final isArabic = value.locale.languageCode == 'ar';
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              title: Text(value.getLocalizedText('Add Tenant', 'إضافة مستأجر')),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),

              child: Column(
                children: [
                  title(
                    value.getLocalizedText(
                      "Tenant Information",
                      'معلومات المستأجر',
                    ),
                  ),

                  field(
                    name,
                    value.getLocalizedText('Full Name', 'الاسم الكامل'),
                  ),
                  field(
                    phone,
                    value.getLocalizedText("Phone Number", 'رقم الهاتف'),
                  ),
                  field(
                    email,
                    value.getLocalizedText("Email", 'البريد لإلكتروني'),
                  ),

                  dropdown(
                    value.getLocalizedText("Select Unit", 'اختر الوحدة'),
                    [
                      value.getLocalizedText("Unit 101", "الوحدة 101"),
                      value.getLocalizedText("Unit 101", "الوحدة 201"),
                      value.getLocalizedText("Unit 101", "الوحدة 305"),
                    ],
                    (v) => setState(() => selectedUnit = v),
                  ),

                  datePicker(
                    value.getLocalizedText(
                      "Contract Start Date",
                      "اختر فترة الحجز",
                    ),
                  ),

                  field(
                    rent,
                    value.getLocalizedText("Monthly Rent (USD)", 'الأجور'),
                    number: true,
                  ),
                  _textarea(
                    notes,
                    value.getLocalizedText("Notes", "الملاحظات"),
                  ),

                  SizedBox(height: 30),
                  saveButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget datePicker(String label) => GestureDetector(
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
            startDate == null
                ? label
                : "${startDate!.year}-${startDate!.month}-${startDate!.day}",
          ),
        ],
      ),
    ),
  );
}

Widget title(String text) => Align(
  alignment: Alignment.centerLeft,
  child: Text(
    text,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
);

Widget field(TextEditingController c, String label, {bool number = false}) =>
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

Widget dropdown(String label, List<String> items, Function(String?) onChange) =>
    Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChange,
      ),
    );

Widget saveButton({Color color = Colors.blue}) => Consumer<SettingsProvider>(
  builder: (BuildContext context, value, Widget? child) {
    final isArabic = value.locale.languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          child: Text(
            value.getLocalizedText('Save', 'حفظ'),
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  },
);
