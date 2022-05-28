import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import '../helper.dart';
import './gender.dart';

enum PlayerState { stopped, playing, paused }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AudioPlayer player = AudioPlayer();
  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
  final inputNameController = TextEditingController();
  final _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  var _identifiedLanguage = '';
  late SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  String _textInput = "";
  bool _inputError = false;

  Future _musicPlay(soundFile, volume) async{
    volume ??= 0.8;
    // await player.setVolume(volume);
    player.setVolume(volume);
    ByteData bytes = await rootBundle.load(soundFile); //load sound from assets
    Uint8List soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    if (!_isListening) {
      setState(() {
        playerState = PlayerState.playing;
      });

      await player.playBytes(soundbytes);
    }
    // player.playBytes(soundbytes);
  }

  Future _musicPlayStop() async{
    int result = await player.stop();
    setState(() {
      playerState = PlayerState.stopped;
    });
    if(result == 1){ //stop success
      // print("Sound playing successful.");
    }else{
      // print("Error while playing sound.");
    }
  }

  Future<void> _identifyLanguage(text) async {
    if (text == '') return;
    String language;
    try {
      language = await _languageIdentifier.identifyLanguage(text);
    } on PlatformException catch (pe) {
      if (pe.code == _languageIdentifier.undeterminedLanguageCode) {
        language = 'error: no language identified!';
      }
      language = 'error: ${pe.code}: ${pe.message}';
    } catch (e) {
      language = 'error: ${e.toString()}';
    }

    setState(() {
      _identifiedLanguage = language;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('ar_SA').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  handleClickNext() {
    _musicPlay('assets/sfx/sfxButtonClick.mp3', 0.8);
    if (inputNameController.text.isEmpty) {
      setState(() => _inputError = true);
    }
    else {
      _musicPlayStop();
      helper.setData("name", inputNameController.text);
      // Navigator.pop(context);
      // Navigator.pop(const MyHomePage(title: 'test'));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenderPage()),
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
    _musicPlay('assets/sounds/WhatIsYourName.mp3', 1.0);
    activateSpeechRecognizer();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputNameController.dispose();
    _languageIdentifier.close();
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
              image: AssetImage("assets/images/bg3.png"),
              fit: BoxFit.cover
            ),
          ),
          child: new Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Image(
                    image: AssetImage('assets/images/mashkoola.png'), height: 150),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 240, vertical: 0),
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
                      ),
                      fillColor: _inputError ? Colors.red[50] : Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      hintText: 'أدخل اسمك بصوتك',
                    ),
                    controller: inputNameController,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Image(
                  image: AssetImage('assets/images/voice.png'),
                  width: 200,
                ),
              ),
              Text(""),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                onPressed: handleClickNext,
                child: Image(
                  image: AssetImage('assets/images/next-green.png'),
                  width: 200
                ),
                // child: Image.asset('assets/images/next-green.png', width: 200),
              ),
              Text(""),
            ],
          )
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () => _speechRecognitionAvailable && !_isListening ? startSpeech() : cancelSpeech(),
            tooltip: 'اضغط لتتحدث',
            child: const Icon(Icons.mic),
            backgroundColor: _isListening ? Colors.green : Colors.blue,
          ),
        ),
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

  void startSpeech() => _speech.activate('ar_SA').then((_) {
    _musicPlayStop();
    return _speech.listen().then((result) {
      setState(() {
        _inputError = false;
        _isListening = result;
        _textInput = "";
      });
      inputNameController.text = "";
      // setState(() => _isListening = result);
    });
  });

  void cancelSpeech() => _speech.cancel().then((_) => setState(() => _isListening = false));

  void stopSpeech() => _speech.stop().then((_) {
    setState(() => _isListening = false);
  });

  void onSpeechAvailability(bool result) => setState(() => _speechRecognitionAvailable = result);

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    if (text.isNotEmpty) {
      _identifyLanguage(text);

      if('${_identifiedLanguage[0]}${_identifiedLanguage[1]}' != 'ar') {
        _musicPlay('assets/sounds/talkArabic.mp3', 1.0);
        inputNameController.text = "";
      }
      else {
        inputNameController.text = text;
        setState(() => _textInput = text);
      }
    }
    else {
      if(!_isListening && text.isEmpty) {
        _musicPlay('assets/sounds/noSound.mp3', 1.0);
      }
    }
  }

  void onRecognitionComplete(String text) {
    setState(() => _isListening = false);
  }

  // void errorHandler() => activateSpeechRecognizer();
  void errorHandler() {
    _musicPlay('assets/sounds/noSound.mp3', 1.0);
    cancelSpeech();
    setState(() => _isListening = false);
    activateSpeechRecognizer();
  }
}
