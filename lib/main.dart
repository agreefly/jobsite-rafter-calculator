import 'package:flutter/material.dart';
import 'rafter_logic.dart';

void main() {
  runApp(const RafterCalculatorApp());
}

class RafterCalculatorApp extends StatelessWidget {
  const RafterCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job-Site Rafter Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.yellow,
          secondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18.0),
          headlineSmall: TextStyle(color: Colors.yellow, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: const RafterCalculatorPage(),
    );
  }
}

class RafterCalculatorPage extends StatefulWidget {
  const RafterCalculatorPage({super.key});

  @override
  State<RafterCalculatorPage> createState() => _RafterCalculatorPageState();
}

class _RafterCalculatorPageState extends State<RafterCalculatorPage> {
  final spanController = TextEditingController(text: '24.0');
  final pitchController = TextEditingController(text: '6.0');
  final ridgeController = TextEditingController(text: '1.5');
  final overhangController = TextEditingController(text: '1.0');
  final wallLengthController = TextEditingController(text: '24.0');
  final spacingController = TextEditingController(text: '16.0');
  String output = '';

  @override
  void dispose() {
    spanController.dispose();
    pitchController.dispose();
    ridgeController.dispose();
    overhangController.dispose();
    wallLengthController.dispose();
    spacingController.dispose();
    super.dispose();
  }

  void calculate() {
    final spanFeet = double.tryParse(spanController.text) ?? 0.0;
    final pitch = double.tryParse(pitchController.text) ?? 0.0;
    final ridgeThickness = double.tryParse(ridgeController.text) ?? 0.0;
    final overhangFeet = double.tryParse(overhangController.text) ?? 0.0;
    final wallLengthFeet = double.tryParse(wallLengthController.text) ?? 0.0;
    final spacingInches = double.tryParse(spacingController.text) ?? 16.0;

    final rafter = calculateRafter(spanFeet, pitch, ridgeThickness);
    final cutList = calculateCutList(
      spanFeet: spanFeet,
      pitch: pitch,
      ridgeThicknessInches: ridgeThickness,
      overhangFeet: overhangFeet,
    );
    final materialQty = estimateMaterialQuantity(
      wallLengthFeet: wallLengthFeet,
      rafterSpacingInches: spacingInches,
      rafterLengthFeet: rafter.decimalInches / 12.0,
      spanFeet: spanFeet,
    );

    setState(() {
      output = '''
Rafter length: ${rafter.formattedLength}
Run: ${rafter.actualRunInches.toStringAsFixed(2)} in
Rise: ${rafter.actualRiseInches.toStringAsFixed(2)} in
Cut list total: ${cutList.formattedTotalLength}
Overhang: ${cutList.formattedOverhangLength}
Estimated rafters: ${materialQty.raftersNeeded}
Waste adjusted rafters: ${materialQty.wasteAdjustedRafters}
Estimated board feet: ${materialQty.estimatedBoardFeet.toStringAsFixed(1)}
Sheathing sheets: ${materialQty.sheathingSheets}
''';
    });
  }

  Widget buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.yellow),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job-Site Rafter Calculator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Inputs', style: TextStyle(color: Colors.yellow, fontSize: 22.0)),
                buildNumberField('Span (ft)', spanController),
                buildNumberField('Pitch (rise per 12)', pitchController),
                buildNumberField('Ridge thickness (in)', ridgeController),
                buildNumberField('Overhang (ft)', overhangController),
                buildNumberField('Wall length (ft)', wallLengthController),
                buildNumberField('Rafter spacing (in)', spacingController),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: calculate,
                  child: const Text('CALCULATE'),
                ),
                const SizedBox(height: 16.0),
                if (output.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(output, style: const TextStyle(color: Colors.white, fontSize: 18.0)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
