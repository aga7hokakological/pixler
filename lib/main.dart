import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'dart:math' as math;

import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  late int tappedIndex;
  final List<bool> _selected = List.generate(1000, (i) => false);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    tappedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    // final Color color = Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  child: pixelGrid(),
                )
              ),
              ElevatedButton(
                  onPressed: () async {
                    await
                        screenshotController.capture(delay: Duration(milliseconds: 10))
                          .then((capturedImage) {
                            ShowCapturedWidget(context, capturedImage!);
                        }).catchError((onError) {
                          print(onError);
                    });

                    // if (image == null) return;
                    //  await saveImage(image);
              },
                  child: Text(
                "Capture Now"
              )
              ),
            ],
        ),
    );
  }

  Widget pixelGrid() => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 50,
      ),
      shrinkWrap: true,
      itemCount: 1000,
      itemBuilder: (context, i) {
        return Container(
          // color: _selected[i] ? Colors.primaries[math.Random().nextInt(Colors.primaries.length)] : null,
            child: ListTile(
                tileColor: _selected[i] ? Colors.primaries[math.Random().nextInt(Colors.primaries.length)] : null,
                onTap:() {
                  setState(() {
                    _selected[i] = !_selected[i];
                  });
                }));
      });

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  // Future<String> saveImage(Uint8List bytes) async {
  //   final appDir = await pathProvider.getApplicationDocumentsDirectory();
  //
  //   await [Permission.storage].request();
  //   final time = DateTime.now()
  //     .toIso8601String()
  //     .replaceAll('.', '-')
  //     .replaceAll(':', '-');
  //   final name = "screenshot_$time";
  //
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //
  //   final localPath = path.join(appDir.path, name);
  //   return result['filepath'];
  // }
}



