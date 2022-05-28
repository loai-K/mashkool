import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../helper.dart';
import './start.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AudioPlayer player = AudioPlayer();

  Future _musicPlay(soundFile, volume) async{
    volume ??= 0.7;
    // await player.setVolume(volume);
    player.setVolume(volume);
    ByteData bytes = await rootBundle.load(soundFile); //load sound from assets
    Uint8List soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.playBytes(soundbytes);
    // player.playBytes(soundbytes);
  }

  Future _musicPlayStop() async{
    int result = await player.stop();
  }

  handleClickNext(String work) {
    _musicPlay('assets/sfx/sfxButtonClick.mp3', 0.8);
    // _musicPlayStop();
    // Navigator.pop(context);
    // Navigator.pop(const MyHomePage(title: 'test'));
  }

  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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
                image: AssetImage("assets/images/ScreenSetting.png"),
                fit: BoxFit.cover
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 200),
              ),
              _buttonPreview(100.0, 100.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonPreview(double _height, double _width) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      minimumSize: Size(_width, _height),
      // backgroundColor: Colors.grey,
      padding: EdgeInsets.all(20),
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartPage()),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Image(
            image: AssetImage('assets/images/home.png'), height: 70),
      ),
    );
  }

  Widget _buildButton({required String label, VoidCallback? onPressed}) => Padding(
      padding: EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      )
  );

}
