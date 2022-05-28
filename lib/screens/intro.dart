import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../helper.dart';
import './register.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // Obtain shared preferences.
  AudioPlayer player = AudioPlayer();
  final inputMobileController = TextEditingController();
  String _textInput = "";
  String _email = "";
  bool _inputError = false;

  Future _musicPlay(soundFile) async{
    // volume ??= 1.0;
    // await player.setVolume(volume);
    ByteData bytes = await rootBundle.load(soundFile); //load sound from assets
    Uint8List soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.playBytes(soundbytes);
    // await player.playBytes(soundbytes);
  }

  Future _musicPlayStop() async{
    int result = await player.stop();
    if(result == 1){ //stop success
      // print("Sound playing successful.");
    }else{
      // print("Error while playing sound.");
    }
  }

  handleClickNext() {
    _musicPlay('assets/sfx/sfxButtonClick.mp3');
    if (inputMobileController.text.isEmpty) {
      setState(() => _inputError = true);
    }
    else {
      _musicPlayStop();
      helper.setData("user", inputMobileController.text);
      // Navigator.pop(context);
      // Navigator.pop(const MyHomePage(title: 'test'));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  }

  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // setState(() => _email = userData);
    // inputMobileController.text = userData;
    // SystemChrome.setEnabledSystemUIOverlays([]);
    FlutterNativeSplash.remove();
    _musicPlay('assets/sounds/mashkool.mp3');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.all(0.0),
          // color: Colors.grey.shade200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg2.png"),
              fit: BoxFit.cover
            ),
          ),
          child: new Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                child: Image(
                    image: AssetImage('assets/icons/icon.png'), height: 150),
              ),
              // Image(image: AssetImage('assets/images/email-mobile.png'), width: 200,),
              Image(
                image: AssetImage('assets/images/start.png'),
                width: 200,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 240, vertical: 16),
                child: Container(
                  // width: 400;
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    // border: Colors.purple,
                    color: Colors.white,
                  ),
                  child: new TextField(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    // textAlignVertical: TextAlignVertical.center,
                    // style: TextStyle(
                    //   fontSize: 18,   // This is not so important
                    // ),
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        // borderSide: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        // borderSide: const BorderSide(color: Colors.red, width: 2.5),
                      ),
                      fillColor: _inputError ? Colors.red[50] : Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      hintText: 'أدخل البريد الالكتروني أو رقم الجوال',
                    ),
                    controller: inputMobileController,
                    onChanged: (String content) {
                      // inputMobileController..text = content;
                      setState(() {
                        _inputError = false;
                        _textInput = content;
                      });
                    },
                  ),
                ),
              ),
              FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: handleClickNext,
                child: Image(
                  image: AssetImage('assets/images/next-green.png'),
                  width: 200
                ),
                // child: Image.asset('assets/images/next-green.png', width: 200),
              ),
              Text(""),
              Text(""),
            ],
          )
        ),
      ),
    );
  }
}
