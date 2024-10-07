import 'package:clipboard/clipboard.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stud_attain_minor_pro/controller/result_provider.dart';
import 'package:stud_attain_minor_pro/model/result_model.dart';
import 'package:stud_attain_minor_pro/objectbox.g.dart';
import 'package:stud_attain_minor_pro/pages/editable_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final resultProvider = Provider.of<ResultProvider>(context);

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
                         resultProvider.updateFormattedData(value);
                        });
                      });
                    },
                    child: const Text("Paste Data"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      resultProvider.calculateTotal();
                    },
                    child: const Text("Calculate Total"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Submit"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Table of data
              EditableTable(controllers: resultProvider.controllers),
            ],
          ),
        ),
      ),
    );
  }
}




// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   String formattedData = '';
//   TextEditingController textEditingController = TextEditingController();
//   TextEditingController enrollmentNoController = TextEditingController(); // Controller for Enrollment No
//   late final Box<Result> _resultBox;

//   List<List<TextEditingController>> controllers = [];

//   @override
//   void initState() {
//     super.initState();
//     populateTableData(formattedData);
//     _resultBox = objectbox.store.box<Result>();
//   }

//   void updateMainTextFieldData(String value) {
//     setState(() {
//       formattedData = formatToSingleLine(value);
//       populateTableData(formattedData); // Update table whenever data changes\

//     });
//   }

//   // Function to convert multi-line string into a single continuous string
//   String formatToSingleLine(String data) {
//     return data.replaceAll(RegExp(r'[^0-9]'), '');
//   }

//   // Populate the table with data from the formatted string
//   void populateTableData(String data) {
//     const int numColumns = 6;
//     List<String> dataCells = [];

//     for (int i = 0; i < data.length; i += numColumns) {
//       List<String> rowCells = data.substring(i, i + numColumns > data.length ? data.length : i + numColumns).split('');
//       dataCells.addAll(rowCells);
//     }

//     const int minRows = 5;
//     while (dataCells.length < minRows * numColumns) {
//       dataCells.add('0');
//     }

//     controllers = [];
//     for (int i = 0; i < dataCells.length; i += numColumns) {
//       List<TextEditingController> rowControllers = [];
//       for (int j = i; j < i + numColumns; j++) {
//         TextEditingController controller = TextEditingController(text: dataCells[j]);
//         // Add a listener to recalculate total when the value changes
//         controller.addListener(() {
//           setState(() {
//             // Find the row index and recalculate total
//             int rowIndex = i ~/ numColumns;
//             calculateRowTotal(rowIndex);
//           });
//         });
//         rowControllers.add(controller);
//       }
//       controllers.add(rowControllers);
//     }
//   }

//   void calculateRowTotal(int rowIndex) {
//     // This method calculates the total for the specified row index
//     int total = 0;
//     for (int i = 0; i < 5; i++) { // Sum columns a to e
//       int value = int.tryParse(controllers[rowIndex][i].text) ?? 0;
//       total += value;
//     }
//     // Update the total for the specific row in the EditableTable
//     if (mounted) {
//       EditableTableState? editableTableState = context.findAncestorStateOfType<EditableTableState>();
//       editableTableState?.updateRowTotal(rowIndex, total);
//     }
//   }

//   void calculateTotal() {
//     for (int rowIndex = 0; rowIndex < controllers.length; rowIndex++) {
//       calculateRowTotal(rowIndex);
//     }
//     setState(() {}); // Trigger a rebuild to update the UI
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Page"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       await LaunchApp.openApp(
//                         androidPackageName: 'com.google.ar.lens',
//                         iosUrlScheme: '',
//                         appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
//                       );
//                     },
//                     child: const Text("Open App"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       FlutterClipboard.paste().then((value) {
//                         setState(() {
//                           textEditingController.text = value;
//                           updateMainTextFieldData(value);
//                         });
//                       });
//                     },
//                     child: const Text("Paste Data"),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: TextFormField(
//                   controller: enrollmentNoController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter Enrollment No',
//                     labelText: 'Enrollment No',
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: TextFormField(
//                   controller: textEditingController,
//                   maxLines: 4,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter data to update the table',
//                   ),
//                   onChanged: (String value) {
//                     updateMainTextFieldData(value);
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Flexible(child: EditableTable(controllers: controllers, formattedData: formattedData)),
//               const SizedBox(height: 20),
//               SizedBox(height: 20,),
//               ElevatedButton(
//                 onPressed: calculateTotal, // Call calculateTotal on press
//                 child: const Text("Calculate Total"),
//               ),
//               ElevatedButton(onPressed: () {}, child: const Text("Submit"))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

