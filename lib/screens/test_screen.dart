import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key key}) : super(key: key);

  @override createState() => _State();
}

class _State extends State<TestScreen> {
  int _counter = 0;

  _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  _clearCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override build(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.display4,
          ),
          IconButton(
            icon: Icon(Icons.exposure_plus_1),
            onPressed: _incrementCounter,
          ),
          IconButton(
            icon: Icon(Icons.minimize),
            onPressed: _decrementCounter,
          ),
          IconButton(
            icon: Icon(Icons.exposure_zero),
            onPressed: _clearCounter,
          ),
        ],
      ),
    );
  }
}
