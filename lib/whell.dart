import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:carkapp/main.dart';

class WheelWidget extends StatefulWidget {
  const WheelWidget({Key? key}) : super(key: key);

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget> {
  String newItem = "";
  StreamController<int> controller = StreamController<int>();
  List<String> items = ["En Az", "İki", "Eleman", "Ekleyin"];
  List<String> useritems = [];

  List<FortuneItem> fortuneItems = [];

  @override
  Widget build(BuildContext context) {
    List<Color> renkler = [
      Colors.amber,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.brown,
      Colors.pink,
      Colors.cyan,
      Colors.deepOrange,
      Colors.indigo,
      Colors.lime,
      Colors.teal,
      Colors.yellow,
      Colors.orange,
      Colors.black,
      Colors.blueGrey,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepPurple,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.cyanAccent,
      Colors.tealAccent,
      Colors.yellowAccent,
      Colors.amberAccent,
      Colors.limeAccent,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.deepPurpleAccent,
      Colors.indigoAccent,
      Colors.blueGrey,
      Colors.black,
    ];
    if (useritems.isNotEmpty && useritems.length > 1) {
      fortuneItems = useritems.asMap().entries.map((entry) {
        Color rastgeleRenk = renkler[Random().nextInt(renkler.length)];
        renkler.remove(rastgeleRenk);
        return FortuneItem(
          child: Text(
            entry.value,
            style: TextStyle(fontSize: 22),
          ),
          style: FortuneItemStyle(
            color: rastgeleRenk,
            borderColor: Colors.black,
            borderWidth: 3,
          ),
        );
      }).toList();
    } else {
      fortuneItems = items.asMap().entries.map((entry) {
        Color rastgeleRenk = renkler[Random().nextInt(renkler.length)];
        renkler.remove(rastgeleRenk);
        return FortuneItem(
          child: Text(
            entry.value,
            style: TextStyle(fontSize: 22),
          ),
          style: FortuneItemStyle(
            color: rastgeleRenk,
            borderColor: Colors.black,
            borderWidth: 3,
          ),
        );
      }).toList();
    }
    return Scaffold(
      appBar: topbar(context, yazi: "Çark Uygulaması", size: 20),
      body: Column(
        children: [
          Expanded(
            child: FortuneWheel(
              animateFirst: false,
              hapticImpact: HapticImpact.medium,
              indicators: const [
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: Colors.amber,
                    width: 30,
                    height: 40,
                    elevation: 10,
                  ),
                ),
              ],
              selected: controller.stream,
              items: fortuneItems,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  final random = Random();
                  final selectedIndex = random.nextInt(fortuneItems.length);
                  controller.sink.add(selectedIndex);
                  Future.delayed(
                    Duration(seconds: 4),
                    () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Sonuç"),
                              content: Row(
                                children: [
                                  Text(
                                    "Seçilen Eleman : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  fortuneItems[selectedIndex].child,
                                ],
                              ),
                              contentTextStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Kapat"),
                                ),
                              ],
                            );
                          });
                    },
                  );
                },
                child: Text("Çevir"),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Eleman Ekle"),
                        content: TextField(
                          onChanged: (value) {
                            newItem = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Yeni elemanı giriniz",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                useritems.add(newItem);
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text("Ekle"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("İptal"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Eleman Ekle"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
