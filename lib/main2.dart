import 'package:automateit/apps_events.dart';
import 'package:automateit/apps_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: const ExampleApp()));

class ExampleApp extends StatelessWidget {
  const ExampleApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('디바이스 내 앱 목록')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                        builder: (BuildContext context) => AppsListScreen()),
                  );
                },
                child: Text('Applications list')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                        builder: (BuildContext context) => AppsEventsScreen()),
                  );
                },
                child: Text('Applications events'))
          ],
        ),
      ),
    );
  }
}