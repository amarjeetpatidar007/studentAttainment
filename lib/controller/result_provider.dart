import 'package:flutter/material.dart';

class ResultProvider extends ChangeNotifier {
  String formattedData = '';
  List<List<TextEditingController>> controllers = [];

  // Function to update formatted data and notify listeners
  void updateFormattedData(String value) {
    formattedData = formatToSingleLine(value);
    populateTableData(formattedData);
    notifyListeners();
  }

  // Function to format data
  String formatToSingleLine(String data) {
    return data.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Function to populate table data
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
        int rowIndex = i ~/ numColumns;
        calculateRowTotal(rowIndex);
        rowControllers.add(controller);
      }
      controllers.add(rowControllers);
    }
    notifyListeners();
  }

  // Function to calculate row total
  void calculateRowTotal(int rowIndex) {
    int total = 0;
    for (int i = 0; i < 5; i++) {
      int value = int.tryParse(controllers[rowIndex][i].text) ?? 0;
      total += value;
    }
    notifyListeners();
  }

  // Function to calculate total for all rows
  void calculateTotal() {
    for (int rowIndex = 0; rowIndex < controllers.length; rowIndex++) {
      calculateRowTotal(rowIndex);
    }
    notifyListeners();
  }
}
