import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../helper.dart';
import './start.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({Key? key}) : super(key: key);

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
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
    helper.setData("work", work);
    // Navigator.pop(context);
    // Navigator.pop(const MyHomePage(title: 'test'));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StartPage()),
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
    _musicPlay('assets/sounds/work.mp3', 1.0);
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
                  image: AssetImage("assets/images/bg5.png"),
                  fit: BoxFit.cover
              ),
            ),
            child: new Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Image(image: AssetImage('assets/images/question-job-with-bg.png'), height: 80),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),),
                Container(
                  height: 160,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              onPressed: () => handleClickNext('chef'),
                              child: Image(
                                  image: AssetImage('assets/images/chef.png'),
                                  width: 150
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
                            Text("طباخ")
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              onPressed: () => handleClickNext('policeman'),
                              child: Image(
                                  image: AssetImage('assets/images/policeman.png'),
                                  width: 150
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
                            Text("شرطي")
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              onPressed: () => handleClickNext('engineer'),
                              child: Image(
                                  image: AssetImage('assets/images/engineer.png'),
                                  width: 150
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
                            Text("مهندس")
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              onPressed: () => handleClickNext('chef'),
                              child: Image(
                                  image: AssetImage('assets/images/chef.png'),
                                  width: 150
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
                            Text("طباخ")
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              onPressed: () => handleClickNext('policeman'),
                              child: Image(
                                  image: AssetImage('assets/images/policeman.png'),
                                  width: 150
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
                            Text("شرطي")
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              onPressed: () => handleClickNext('engineer'),
                              child: Image(
                                  image: AssetImage('assets/images/engineer.png'),
                                  width: 150
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
                            Text("مهندس")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 35),)
              ],
            )
        ),
      ),
    );
  }
}
