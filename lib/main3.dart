import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Deep Link',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Schedule Deep Link'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Time: ${_selectedTime.format(context)}',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Select Time'),
            ),
            ElevatedButton(
              onPressed: _scheduleDeepLink,
              child: Text('Schedule Deep Link'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _scheduleDeepLink() async {

    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final timeUntilScheduled = scheduledTime.difference(now);
    final durationUntilScheduled = Duration(milliseconds: timeUntilScheduled.inMilliseconds);

    await AndroidAlarmManager.oneShot(
      durationUntilScheduled,
      0,
      _launchDeepLink,
      exact: true,
      wakeup: true,
    );
    print('Scheduling deep link');
  }


  void _launchDeepLink() async {
    const deepLink = 'youtube://';
    // ignore: deprecated_member_use
    if (await canLaunch(deepLink)) {
      // ignore: deprecated_member_use
      await launch(deepLink);
    } else {
      print('Unable to launch deep link: $deepLink');
    }
  }
}
