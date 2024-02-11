import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({super.key});

  @override
  State<ShowDataScreen> createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  DatabaseReference? _ref;
  late StreamSubscription<DatabaseEvent> _dataSuscription;
  double power = 0;
  double current = 0;
  double frecuencia = 0;
  String codigo = '';
  double hours = 0;
  bool status = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _dataSuscription.cancel();
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }

  void getData() async {
    try {
      _ref = FirebaseDatabase.instance.ref('Estacion1/data');
      _dataSuscription = _ref!.onValue.listen((DatabaseEvent event) {
        final res = event.snapshot.value;
        final dataAll = jsonEncode(res);
        final decodeData = jsonDecode(dataAll);

        power = decodeData['power'] is int
            ? decodeData['power'].toDouble()
            : decodeData['power'];
        frecuencia = decodeData['frecuencia'] is int
            ? decodeData['frecuencia'].toDouble()
            : decodeData['frecuencia'];
        current = decodeData['current'] is int
            ? decodeData['current'].toDouble()
            : decodeData['current'];
        hours = decodeData['hours'] is int
            ? decodeData['hours'].toDouble()
            : decodeData['hours'];
        codigo = decodeData['code'];
        status = decodeData['status'];
        refresh();
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  void setData(bool bomba) async {
    _ref = FirebaseDatabase.instance.ref('Estacion1/write');
    await _ref!.set({"bomba": bomba});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 270,
                child: _circuleData(
                    power, current, frecuencia, Icons.flash_on, Colors.black54),
              ),
              Positioned(
                top: 210,
                left: 20,
                child: _buttonOn(true),
              ),
              Positioned(
                top: 210,
                right: 20,
                child: _buttonOff(false),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _boxData('Codigos de variador', codigo, Icons.display_settings),
          _boxData('Horas totales', '$hours hrs', Icons.timeline),
        ],
      ),
    );
  }

  Widget _circuleData(
      double value1, double value2, double value3, IconData icon, Color color) {
    return Container(
      width: 250,
      height: 250,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            status == true ? Theme.of(context).primaryColor : Colors.grey[400],
      ),
      child: Container(
        width: 250,
        height: 250,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(status == true ? 'Bomba On' : 'Bomba Off',
                  style: TextStyle(
                      color: status == true ? Colors.green : Colors.black54)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.bolt, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    value1.toStringAsFixed(0),
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(' Voltios',
                      style: TextStyle(fontSize: 16, color: Colors.black54))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flash_on, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    value2.toStringAsFixed(0),
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const Text('  Amp.',
                      style: TextStyle(fontSize: 16, color: Colors.black54))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.signal_cellular_alt, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    value3.toStringAsFixed(0),
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  const Text('  Hz.',
                      style: TextStyle(fontSize: 16, color: Colors.black54))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonOn(bool isOn) {
    return GestureDetector(
      onTap: () {
        if (status == true) {
          null;
        } else {
          _showMyDialog(isOn);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: status == true ? Colors.grey : Colors.green,
        ),
        child: const Icon(Icons.power_settings_new_outlined,
            size: 40, color: Colors.white),
      ),
    );
  }

  Widget _buttonOff(bool isOn) {
    return GestureDetector(
      onTap: () {
        if (status == true) {
          _showMyDialog(isOn);
        } else {
          null;
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: status == true ? Colors.red : Colors.grey,
        ),
        child: const Icon(Icons.power_settings_new_outlined,
            size: 40, color: Colors.white),
      ),
    );
  }

  Widget _boxData(String text, String data, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: Icon(icon, size: 30),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                const SizedBox(height: 5),
                Text(
                  data,
                  style: GoogleFonts.lato(
                      textStyle:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _showMyDialog(bool isOn) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                isOn == true
                    ? const Text('¿Estas seguro de encdender la bomba?')
                    : const Text('¿Estas seguro de apagar la bomba?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('SI',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              onPressed: () {
                setData(isOn);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('NO',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
