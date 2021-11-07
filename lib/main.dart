import 'package:flutter/material.dart';
import 'package:mqtt2/mqtt_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test MQTT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //final String title;

  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String recievedText = '...';
  MqttManager _mqtt_manager = MqttManager(setTextHandler: (){});

  void setRecievedText(String recievedText_t) {
    setState(() {
      recievedText = recievedText_t;
      //print(recievedText);
    });
  }

  @override
  void initState() {
    // final MqttManager _mqtt_manager = MqttManager(setTextHandler: (data) {
    //   setState(() {
    //     recievedText = data;
    //     print(recievedText);
    //   });
    // });

    _mqtt_manager = MqttManager(
      setTextHandler: setRecievedText,
    );

    _mqtt_manager.initializeMqtt();
    _mqtt_manager.connect();

    print('initial state');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IoT Project - N Academy'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LED Status: ' + recievedText.toString()),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _mqtt_manager.publish('ON');
                    },
                    child: Text('On'),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _mqtt_manager.publish('OFF');
                    },
                    child: Text('Off'),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                      primary: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
