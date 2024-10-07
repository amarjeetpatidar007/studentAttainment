import 'package:flutter/material.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'package:provider/provider.dart';
import 'package:stud_attain_minor_pro/controller/result_provider.dart';
import 'package:stud_attain_minor_pro/model/objectbox_store.dart';
import 'package:stud_attain_minor_pro/selectWidget.dart';


late ObjectBox objectbox;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ObjectBox
  loadObjectBoxLibraryAndroidCompat();
  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ResultProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SelectPage(),
      ),
    );
  }
}
