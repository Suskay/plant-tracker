import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'Plant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Watering Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Your Plants'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Plant> plants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                plants = [];
                setState(() {});
              })
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            for (Plant plant in plants)
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.lightGreen.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: SizedBox(
                              width: 370,
                              height: 200,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Name: " +
                                          plant.name +
                                          "\nWatering Interval: " +
                                          plant.wateringInterval.inSeconds.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        child: Image.file(plant.image)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_createRoute(plants)).then(onGoBack);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  onGoBack(dynamic value) {
    setState(() {});
  }
}

Route _createRoute(List<Plant> plants) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Page2(plants: plants),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatefulWidget {
  final List<Plant> plants;

  Page2({Key key, @required this.plants}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  TextEditingController plantNameController = new TextEditingController();
  TextEditingController waterIntervalController = new TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add your Plant'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 100,
              alignment: Alignment.center,
              child: TextField(
                controller: plantNameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name your Plant',
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 100,
              alignment: Alignment.center,
              child: TextField(
                controller: waterIntervalController,
                obscureText: false,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Watering Interval',
                ),
              ),
            ),
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(_image),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new FloatingActionButton(
                      heroTag: null,
                      onPressed: getImage,
                      tooltip: 'Pick Image',
                      child: Icon(Icons.add_a_photo),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        Navigator.pop(
                            context,
                            widget.plants.add(new Plant(plantNameController.text,
                                new Duration(seconds: int.parse(waterIntervalController.text)), _image)));
                      },
                      child: const Icon(Icons.add),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
