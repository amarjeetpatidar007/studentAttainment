import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stud_attain_minor_pro/controller/result_provider.dart';

class EditableTable extends StatelessWidget {
  const EditableTable({super.key, required this.controllers});

  final List<List<TextEditingController>> controllers;

  @override
  Widget build(BuildContext context) {
    final resultProvider = Provider.of<ResultProvider>(context);

    return Table(
      border: TableBorder.all(),
      children: [
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
        ...List.generate(resultProvider.controllers.length, (rowIndex) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((rowIndex + 1).toString()),
              ),
              ...List.generate(5, (columnIndex) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: resultProvider.controllers[rowIndex][columnIndex],
                    onChanged: (value) {
                      resultProvider.calculateRowTotal(rowIndex);
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  resultProvider.controllers[rowIndex].toString(),
                ),
              ),
            ],
          );
        }),
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


// class EditableTable extends StatefulWidget {
//   final String formattedData;
//   final List<List<TextEditingController>> controllers;

//   const EditableTable({
//     super.key,
//     required this.formattedData,
//     required this.controllers,
//   });

//   @override
//   EditableTableState createState() => EditableTableState();
// }

// class EditableTableState extends State<EditableTable> {
//   List<int> totals = []; // List to store totals for each row

//   @override
//   void initState() {
//     super.initState();
//     calculateInitialTotals();
//   }

//   void calculateInitialTotals() {
//     totals = List.generate(widget.controllers.length, (index) => 0);
//     for (int rowIndex = 0; rowIndex < widget.controllers.length; rowIndex++) {
//       calculateRowTotal(rowIndex);
//     }
//   }

//   void calculateRowTotal(int rowIndex) {
//     int total = 0;
//     for (int i = 0; i < 5; i++) { // Sum columns a to e
//       int value = int.tryParse(widget.controllers[rowIndex][i].text) ?? 0;
//       total += value;
//     }
//     totals[rowIndex] = total; // Update the total for the specific row
//   }

//   void updateRowTotal(int rowIndex, int total) {
//     setState(() {
//       totals[rowIndex] = total; // Update the total for the specific row
//     });
//   }

//   void updateCell(int row, int column, String value) {
//     setState(() {
//       widget.controllers[row][column].text = value;
//       calculateRowTotal(row); // Recalculate the total for the row
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Table(
//           border: TableBorder.all(),
//           children: [
//             // Header row
//             TableRow(
//               children: [
//                 tableHeaderCell('Q.No'),
//                 tableHeaderCell('a'),
//                 tableHeaderCell('b'),
//                 tableHeaderCell('c'),
//                 tableHeaderCell('d'),
//                 tableHeaderCell('e'),
//                 tableHeaderCell('Total'),
//               ],
//             ),
//             // Body rows populated with editable fields
//             ...List.generate(widget.controllers.length, (rowIndex) {
//               return TableRow(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       (rowIndex + 1).toString(), // Q.No starts from 1
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   ...List.generate(5, (columnIndex) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextFormField(
//                         controller: widget.controllers[rowIndex][columnIndex],
//                         textAlign: TextAlign.center,
//                         onChanged: (value) {
//                           updateCell(rowIndex, columnIndex, value); // Update cell and recalculate total
//                         },
//                         keyboardType: TextInputType.number,
//                       ),
//                     );
//                   }),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       totals[rowIndex].toString(),
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget tableHeaderCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
