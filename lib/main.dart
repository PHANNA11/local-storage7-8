import 'package:flutter/material.dart';
import 'package:local_storage/database/view/db_home-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DBHomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var prefs = SharedPreferences.getInstance();
  int? counter;
  List<String> listDay = [];

  Future<void> _incrementCounter() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setInt('num', counter! + 1).then((value) {
      getNumber();
    });
  }

  void setDays() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('days',
        listDay.isEmpty ? <String>['Monday', 'Friday', 'Sunday'] : listDay);
    getListDay();
  }

  void getListDay() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      listDay = prefs.getStringList('days')!;
    });
  }

  void getNumber() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('num') ?? 0;
      print(counter);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDays();
    // getListDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            listDay.length,
            (index) => Card(
                  child: ListTile(title: Text(listDay[index])),
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();
          listDay.add('Saturday');
          prefs.setStringList('days', listDay);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
