import 'package:cowin/function.dart';
import 'package:cowin/states.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CowinList',
      home: StateSelect(),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/tracker': (context) => MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // int secs = 0;
  // int listsize = 0;
  // int oldsize = 0;
  // Timer timer;
  // Timer funrun;

  TextEditingController t = TextEditingController();
  // @override
  // initState() {
  //   super.initState();

  //   var initializationSettingsAndroid =
  //       new AndroidInitializationSettings("@mipmap/ic_launcher");
  //   var initializationSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: onSelectNotification);
  //   final oneSec = const Duration(seconds: 1);
  //   timer = Timer.periodic(oneSec, (Timer t) {
  //     secs++;
  //     if (secs % 10 == 0) {
  //       print(secs);
  //       setState(() {});
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   timer.cancel();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;

    print(args);
    // Future _showNotificationWithoutSound() async {
    //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    //       'your channel id', 'your channel name', 'your channel description',
    //       playSound: false,
    //       importance: Importance.max,
    //       priority: Priority.high);
    //   var iOSPlatformChannelSpecifics =
    //       new IOSNotificationDetails(presentSound: false);
    //   var platformChannelSpecifics = new NotificationDetails(
    //       android: androidPlatformChannelSpecifics,
    //       iOS: iOSPlatformChannelSpecifics);
    //   await flutterLocalNotificationsPlugin.show(
    //     0,
    //     'CVCs have been added/removed.',
    //     'Click to view the current centers.',
    //     platformChannelSpecifics,
    //     payload: 'No_Sound',
    //   );
    // }

    // void fun() {
    //   print(secs);

    // final oneSec = const Duration(seconds: 1);
    // funrun = Timer.periodic(oneSec, (Timer t) => fun());

    return Scaffold(
      appBar: AppBar(
        title: Text("Cowin Tracker (18-45)"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
              ),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              );
            } else if (snapshot.hasData) {
              // oldsize = listsize;
              final list = snapshot.data;
              // listsize = list.length;
              // if (secs % 10 == 0) {
              //   if (listsize != oldsize) {
              //     _showNotificationWithoutSound();
              //   }
              // }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                            "Displays the available centers for the next 7 days from the given date."),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Date",
                            hintText:
                                'Enter a date (a number is enough. eg:3 or 24)'),
                        controller: t,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text("Set date")),
                    SizedBox(
                      height: 20,
                    ),
                    if (list.length == 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                              "Currently no vaccinations for the 18-45 age group for this given date."),
                        ),
                      ),
                    for (var item in list)
                      Card(
                        child: ListTile(
                          title: Text(
                              "${item.name}. Available: ${item.availableCapacity}"),
                          subtitle: Text("${item.vaccine}"),
                        ),
                      ),
                  ],
                ),
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: fetchCowin(t.text, args),
      ),
    );
  }

  // Future onSelectNotification(String payload) async {}
}
