import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_lab/koneksi.dart';
import 'package:smart_lab/page_utama.dart';

class DetailDataIp extends StatefulWidget {
  // final int id;
  const DetailDataIp({super.key});

  @override
  State<DetailDataIp> createState() => _DetailDataIpState();
}

class _DetailDataIpState extends State<DetailDataIp> {
  bool powerOn = false;
  // String? onPower;
  // String? status;
  // Map<String, dynamic> data = {};
  void Function(bool)? onChanged;

  //showDataId
  // Future<void> showDataId() async {
  //   final Response = await http.get(
  //     Uri.parse(koneksi().url + 'computerClient/show/${widget.id}'),
  //   );
  //   if (Response.statusCode == 200) {
  //     if (mounted) {
  //       setState(() {
  //         data = jsonDecode(Response.body)['dataWithId'];
  //       });
  //     }
  //   } else {
  //     log(Response.body);
  //   }
  // }

  //deletaData
  // Future<void> deleteData() async {
  //   final response = await http
  //       .get(Uri.parse(koneksi().url + 'computerClient/delete/${widget.id}'));
  //   if (response.statusCode == 200) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => PageUtama()),
  //         (route) => false);
  //   } else {
  //     log(response.body);
  //   }
  // }

  //editData
  // Future<void> editData() async {
  //   final response = await http.post(
  //       Uri.parse(koneksi().url + 'computerClient/edit/${widget.id}'),
  //       body: {
  //         'aksi': onPower,
  //         'status': status,
  //       });
  //   if (response.statusCode == 200) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => PageUtama()),
  //       (route) => false,
  //     );
  //   } else {
  //     log(response.body);
  //   }
  // }

  @override
  void initState() {
    // showDataId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 50,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Computer Client',
                      // data['ip_address'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      // data['status'] == '0'
                      //     ? 'Status PC: OFF'
                      //     : 'Status PC: ON',
                      powerOn == false ? 'Status PC: OFF' : 'Status PC: ON',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(powerOn == false ? 'Status PC: OFF' : 'Status PC: ON'),
                    CupertinoSwitch(
                      value: powerOn,
                      onChanged: (bool value) {
                        if (mounted) {
                          setState(() {
                            powerOn = value;
                            // onPower = powerOn == false ? '0' : '1';
                            // status = powerOn == false ? '0' : '1';
                          });
                        }
                        // editData();
                      },
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ShowDialogDeleteConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white),
                child: Text("Delete Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> ShowDialogDeleteConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("Are you sure to delete this data?"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          // deleteData();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            foregroundColor: Colors.white),
                        child: Text("Yes"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white),
                        child: Text("No"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
