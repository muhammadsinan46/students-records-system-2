import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studentrecords/home_screen.dart';
import 'package:studentrecords/student_helper.dart';
import 'package:studentrecords/student_model.dart';

String hiveStudent = 'students';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
   StudentHelper sdntList=StudentHelper();
      sdntList.getStudentList();
    super.initState();
    
  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context)=> StudentHelper())],
      child:  MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
  
 
}
