import 'dart:math';

import 'package:flutter/material.dart';

class Captcha extends StatefulWidget {
  final double lebar, tinggi;
  final VoidCallback? onSucceed;

  const Captcha({
    super.key,
    required this.lebar,
    required this.tinggi,
    required this.onSucceed
  });

  @override
  State<StatefulWidget> createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  var random = Random();
  var stokWarna = {
    'merah': Color(0x89ec1c1c),
    'hijau': Color(0x8922b900),
    'biru': Color(0x890088b9),
    'hitam': Color(0x89000000),
  };
  int jumlahTitikMaks = 10;
  double ukuranTitik = 6;
  List<Map> daftarTitik = [];
  var warnaTerpakai = {};
  String warnaYangDitanyakan = 'merah';
  double x = 0, y = 0;

  @override
  void initState() {
    super.initState();
    buatTitik();
    buatPertanyaan();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: SizedBox(
                width: widget.lebar,
                height: widget.tinggi,
                child: ClipRect(
                  child: CustomPaint(
                    painter: CaptchaPainter(daftarTitik),
                  ),
                )),
            onDoubleTap: () {
              setState(() {
                daftarTitik.clear();
                buatTitik();
              });
            },
            onTapDown: (details) {
              setState(() {
                x = details.localPosition.dx;
                y = details.localPosition.dy;
              });
            },
          ),
          Text(
            'Koordinat sentuh: ${x}, ${y}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 2),
          ),
        ],
      ),
    );
  }

  void buatTitik() {
    stokWarna.forEach((key, value) {
      var jumlah = random.nextInt(jumlahTitikMaks + 1);
      if (jumlah == 0) jumlah = 1;
      warnaTerpakai[key] = jumlah;

      for (var i = 0; i < jumlah; i++) {
        var catTitik = Paint()
          ..color = value
          ..style = PaintingStyle.fill;

        var x = random.nextDouble() * widget.lebar;
        if (x + ukuranTitik >= widget.lebar - ukuranTitik) x = x - ukuranTitik;
        var y = random.nextDouble() * widget.tinggi;
        if (y + ukuranTitik > widget.tinggi - ukuranTitik) y = y - ukuranTitik;
        daftarTitik.add({'x': x, 'y': y, 'ukuran': ukuranTitik, 'cat': catTitik});
      }
    });
  }

  void buatPertanyaan() {
      warnaYangDitanyakan = stokWarna.keys.elementAt(random.nextInt(3));
  }
}

class CaptchaPainter extends CustomPainter {
  late List<Map> daftarTitik;

  CaptchaPainter(this.daftarTitik);

  @override
  void paint(Canvas canvas, Size size) {
    var catBingkai = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset(0, 0) & Size(size.width, size.height), catBingkai);

    daftarTitik.forEach((element) {
      canvas.drawCircle(Offset(element['x'], element['y']), element['ukuran'],
          element['cat']);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}