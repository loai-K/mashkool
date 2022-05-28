import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../helper.dart';
import './work.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({Key? key}) : super(key: key);

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  AudioPlayer player = AudioPlayer();
  // final inputGenderController = TextEditingController();

  Future _musicPlay(soundFile, volume) async{
    volume ??= 0.8;
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

  handleClickNext(String gender) {
    _musicPlay('assets/sfx/sfxButtonClick.mp3', 0.8);
    // _musicPlayStop();
    helper.setData("gender", gender);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkPage()),
    );
  }

  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _musicPlay('assets/sounds/gender.mp3', 1.0);
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
                  image: AssetImage("assets/images/bg4.png"),
                  fit: BoxFit.cover
              ),
            ),
            child: new Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Image(image: AssetImage('assets/images/question-gender-with-bg.png'), height: 80),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  // color: Colors.amber,
                  child: Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(horizontal: 200, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 0),
                          child: Column(
                            children: [
                              FlatButton(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                onPressed: () => handleClickNext('female'),
                                child: Image(
                                    image: AssetImage('assets/images/girl-purple.png'),
                                    width: 150
                                ),
                                // child: Image.asset('assets/images/next-green.png', width: 200),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 0),
                          child: Column(
                            children: [
                              FlatButton(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                onPressed: () => handleClickNext('male'),
                                child: Image(
                                    image: AssetImage('assets/images/boy-green.png'),
                                    width: 150
                                ),
                                // child: Image.asset('assets/images/next-green.png', width: 200),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),

                )
              ],
            )
        ),
      ),
    );
  }
}
