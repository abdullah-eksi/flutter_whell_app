


# Çark Uygulaması

Bu proje, Flutter kullanarak oluşturulmuş bir Çark Uygulaması'dır. Bu uygulama, kullanıcının bir çark etrafında dönen ve rastgele bir elemanı seçen bir animasyon oluşturmasına olanak tanır. Kullanıcılar ayrıca çarka yeni elemanlar ekleyebilirler.

## Gereksinimler

- Flutter SDK
- Dart SDK
- flutter_fortune_wheel: ^1.3.1
- flutter_launcher_icons: "^0.13.1"
  
## Kurulum

1. Flutter SDK'yı [buradan](https://flutter.dev/docs/get-started/install) yükleyin.
2. Projeyi yerel makinenize klonlayın.
   ```bash
   git clone https://github.com/kullaniciadi/carkapp.git
   ```
3. Proje dizinine gidin.
   ```bash
   cd carkapp
   ```
4. Gerekli paketleri yükleyin.
   ```bash
   flutter pub get
   ```

## Çalıştırma

Projeyi çalıştırmak için aşağıdaki komutu kullanın:
```bash
flutter run
```

## Proje Yapısı

### main.dart

Bu dosya, uygulamanın giriş noktasıdır. `MyApp` sınıfı, uygulamanın genel yapısını tanımlar ve `WheelWidget` bileşenini ana ekran olarak ayarlar.
## Metodlar ve Fonksiyonlar
- **`topbar`**: Bu metod, topbar için oluşturulmuş bir widget metodudur.
- **`WheelWidget`**: Bu metod sayesinde farklı dosyada çark widgetimizi olusturup kod karmasasının onune geçmek için:
```dart
import 'package:flutter/material.dart';
import 'package:carkapp/whell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Çark Uygulaması',
      home: WheelWidget(),
    );
  }
}

AppBar topbar(BuildContext context, {String yazi = "Ana Sayfa", int size = 20}) {
  return AppBar(
    title: Text(
      yazi,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.amber,
  );
}
```

### whell.dart

Bu dosya, çark widget'ını ve işlevselliğini tanımlar. `WheelWidget` sınıfı, çarkın nasıl görüneceğini ve nasıl çalışacağını belirler.

#### Metodlar ve Fonksiyonlar

- **`build`**: Bu metod, widget ağacını oluşturur ve `FortuneWheel` bileşenini ve diğer UI bileşenlerini içerir.
- **`onPressed`**: İki farklı düğme işlevini tanımlar:
  - Çarkı çevirme ve seçilen elemanı gösterme
  - Kullanıcıdan yeni eleman ekleme

```dart
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
      // Diğer renkler...
    ];

    // Çark elemanlarını güncelleme
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
                        },
                      );
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
```

## Özellikler

- Çark üzerinde rastgele eleman seçimi.
- Kullanıcı tarafından yeni eleman eklenebilmesi.
- Seçilen elemanın gösterilmesi.

## Lisans

Bu proje MIT Lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakınız.

