import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_lab/detail_data_ip.dart';
import 'package:http/http.dart' as http;
import 'package:smart_lab/koneksi.dart';
import 'package:smart_lab/mqtt_client.dart';

class PageUtama extends StatefulWidget {
  const PageUtama({super.key});

  @override
  State<PageUtama> createState() => _PageUtamaState();
}

class _PageUtamaState extends State<PageUtama> {
  late MqttServerClient _client;
  int _selectedIndex = 0;
  String _message = '';
  List<dynamic> _data = [];
  // bool powerOn = false;
  List<String> _ipAddresses = [];
  // List computerClient = [];
  // final TextEditingController ipAddressController = TextEditingController();

  //show data
  // Future<void> showData() async {
  //   final response =
  //       await http.get(Uri.parse(koneksi().url + 'computerClient/show'));
  //   if (response.statusCode == 200) {
  //     if (mounted) {
  //       setState(() {
  //         computerClient = jsonDecode(response.body)['data'];
  //       });
  //     }
  //   } else {
  //     log(response.body);
  //   }
  // }

  //create data
  // Future<void> createData() async {
  //   final response = await http.post(
  //     Uri.parse(koneksi().url + 'computerClient/create'),
  //     body: {
  //       'ip_address': ipAddressController.text,
  //       'status': '0',
  //       'aksi': '0'
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => PageUtama()),
  //         (route) => false);
  //   } else {
  //     log(response.body);
  //   }
  // }

  @override
  void initState() {
    _connectToMqtt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: const Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Smart Lab SMK YPC Tasikmalaya',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            'SIDAK',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     _sendMessage();
              //   },
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue[200],
              //       foregroundColor: Colors.white),
              //   child: Text('Scan Data'),
              // ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[200],
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: TextFormField(
                  //       decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //         hintText: "Search IP Address ......",
                  //         hintStyle: TextStyle(
                  //           color: Colors.black.withOpacity(0.5),
                  //         ),
                  //         prefixIcon: Icon(
                  //           Icons.search,
                  //           size: 25,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        itemCount: _data.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (context, index) {
                          final item = _data[index];
                          bool _powerOn = item['status'] == 0 ? false : true;
                          _ipAddresses.add(item['ip']);
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: ListTile(
                                // onTap: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) => DetailDataIp(),
                                //     ),
                                //   );
                                // },
                                title: Text(
                                  item['ip'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Status: ${item['status'] == 1 ? 'ON' : 'OFF'}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Switch(
                                  value: item['status'] == 0
                                      ? _powerOn = false
                                      : _powerOn = true,
                                  onChanged: (bool value) {
                                    if (mounted) {
                                      setState(() {
                                        _powerOn = value;
                                        _data[index]['status'] = value ? 1 : 0;
                                        // onPower = powerOn == false ? '0' : '1';
                                        // status = powerOn == false ? '0' : '1';
                                        _selectedIndex = index;
                                      });
                                      log(_data[index].toString());
                                    }
                                    _sendMessage();
                                    // editData();
                                  },
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _connectToMqtt() async {
    _client =
        MqttServerClient.withPort('broker.emqx.io', 'mqttx_b9e3e2c8', 1883);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.onSubscribed = onSubscribed;
    final connMessage = MqttConnectMessage()
        .authenticateAs(null, null)
        .withWillTopic('mysmartlabypc/get')
        .withWillMessage('disconnected')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print("EXAMPLE::Mosquitto client connecting....");
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      print('EXAMPLE::client exception - $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
      const topic = 'mysmartlabypc/get';
      _client.subscribe(topic, MqttQos.atLeastOnce);
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${_client.connectionStatus!.state}');
      _client.disconnect();
    }

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      print('Received message payload: ${message.payload.message}');
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      final jsonData = jsonDecode(payload);
      setState(() {
        _data = jsonData;
      });
    });
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  }

  void _sendMessage() {
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
      const topic = 'mysmartlabypc/set';
      String selectedIpAddress = _ipAddresses[_selectedIndex];
      final jsonPayload = {'ip': selectedIpAddress};
      final jsonEncoded = jsonEncode(jsonPayload);
      final builder1 = MqttClientPayloadBuilder();
      builder1.addString(jsonEncoded);
      print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
      _client.publishMessage(topic, MqttQos.atLeastOnce, builder1.payload!);
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${_client.connectionStatus!.state}');
      _client.disconnect();
    }
  }
}

// Future<dynamic> ShowDialogAdd(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(7),
//         ),
//         child: SizedBox(
//           height: 240,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Text("Input New IP Address"),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: TextFormField(
//                       controller: ipAddressController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(
//                           color: Colors.black.withOpacity(0.5),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 20),
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     createData();
//                   },
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[200],
//                       foregroundColor: Colors.white),
//                   child: Text("Add Data"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
