import 'package:clipboard/clipboard.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String formattedData = '';
  TextEditingController textEditingController = TextEditingController();
  TextEditingController enrollmentNoController = TextEditingController(); // Controller for Enrollment No

  List<List<TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    populateTableData(formattedData);
  }

  void updateMainTextFieldData(String value) {
    setState(() {
      formattedData = formatToSingleLine(value);
      populateTableData(formattedData); // Update table whenever data changes\

    });
  }

  // Function to convert multi-line string into a single continuous string
  String formatToSingleLine(String data) {
    return data.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Populate the table with data from the formatted string
  void populateTableData(String data) {
    const int numColumns = 6;
    List<String> dataCells = [];

    for (int i = 0; i < data.length; i += numColumns) {
      List<String> rowCells = data.substring(i, i + numColumns > data.length ? data.length : i + numColumns).split('');
      dataCells.addAll(rowCells);
    }

    const int minRows = 5;
    while (dataCells.length < minRows * numColumns) {
      dataCells.add('0');
    }

    controllers = [];
    for (int i = 0; i < dataCells.length; i += numColumns) {
      List<TextEditingController> rowControllers = [];
      for (int j = i; j < i + numColumns; j++) {
        TextEditingController controller = TextEditingController(text: dataCells[j]);
        // Add a listener to recalculate total when the value changes
        controller.addListener(() {
          setState(() {
            // Find the row index and recalculate total
            int rowIndex = i ~/ numColumns;
            calculateRowTotal(rowIndex);
          });
        });
        rowControllers.add(controller);
      }
      controllers.add(rowControllers);
    }
  }

  void calculateRowTotal(int rowIndex) {
    // This method calculates the total for the specified row index
    int total = 0;
    for (int i = 0; i < 5; i++) { // Sum columns a to e
      int value = int.tryParse(controllers[rowIndex][i].text) ?? 0;
      total += value;
    }
    // Update the total for the specific row in the EditableTable
    if (mounted) {
      EditableTableState? editableTableState = context.findAncestorStateOfType<EditableTableState>();
      editableTableState?.updateRowTotal(rowIndex, total);
    }
  }

  void calculateTotal() {
    for (int rowIndex = 0; rowIndex < controllers.length; rowIndex++) {
      calculateRowTotal(rowIndex);
    }
    setState(() {}); // Trigger a rebuild to update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.google.ar.lens',
                        iosUrlScheme: '',
                        appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                      );
                    },
                    child: const Text("Open App"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FlutterClipboard.paste().then((value) {
                        setState(() {
                          textEditingController.text = value;
                          updateMainTextFieldData(value);
                        });
                      });
                    },
                    child: const Text("Paste Data"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: enrollmentNoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Enrollment No',
                    labelText: 'Enrollment No',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: textEditingController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter data to update the table',
                  ),
                  onChanged: (String value) {
                    updateMainTextFieldData(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Flexible(child: EditableTable(controllers: controllers, formattedData: formattedData)),
              const SizedBox(height: 20),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: calculateTotal, // Call calculateTotal on press
                child: const Text("Calculate Total"),
              ),
              ElevatedButton(onPressed: () {}, child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}

class EditableTable extends StatefulWidget {
  final String formattedData;
  final List<List<TextEditingController>> controllers;

  const EditableTable({
    super.key,
    required this.formattedData,
    required this.controllers,
  });

  @override
  EditableTableState createState() => EditableTableState();
}

class EditableTableState extends State<EditableTable> {
  List<int> totals = []; // List to store totals for each row

  @override
  void initState() {
    super.initState();
    calculateInitialTotals();
  }

  void calculateInitialTotals() {
    totals = List.generate(widget.controllers.length, (index) => 0);
    for (int rowIndex = 0; rowIndex < widget.controllers.length; rowIndex++) {
      calculateRowTotal(rowIndex);
    }
  }

  void calculateRowTotal(int rowIndex) {
    int total = 0;
    for (int i = 0; i < 5; i++) { // Sum columns a to e
      int value = int.tryParse(widget.controllers[rowIndex][i].text) ?? 0;
      total += value;
    }
    totals[rowIndex] = total; // Update the total for the specific row
  }

  void updateRowTotal(int rowIndex, int total) {
    setState(() {
      totals[rowIndex] = total; // Update the total for the specific row
    });
  }

  void updateCell(int row, int column, String value) {
    setState(() {
      widget.controllers[row][column].text = value;
      calculateRowTotal(row); // Recalculate the total for the row
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(),
          children: [
            // Header row
            TableRow(
              children: [
                tableHeaderCell('Q.No'),
                tableHeaderCell('a'),
                tableHeaderCell('b'),
                tableHeaderCell('c'),
                tableHeaderCell('d'),
                tableHeaderCell('e'),
                tableHeaderCell('Total'),
              ],
            ),
            // Body rows populated with editable fields
            ...List.generate(widget.controllers.length, (rowIndex) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (rowIndex + 1).toString(), // Q.No starts from 1
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...List.generate(5, (columnIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: widget.controllers[rowIndex][columnIndex],
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          updateCell(rowIndex, columnIndex, value); // Update cell and recalculate total
                        },
                        keyboardType: TextInputType.number,
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      totals[rowIndex].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
