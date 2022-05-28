import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import '../helper.dart';
import './start.dart';
import './story.dart';
import './tune.dart';
import './listen.dart';
import './mystery.dart';
import './game.dart';

enum PlayerState { stopped, playing, paused }

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  AudioPlayer player = AudioPlayer();
  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
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
  }

  Future _musicPlayStop() async{
    int result = await player.stop();
    setState(() {
      playerState = PlayerState.stopped;
    });
  }

  playActions() {
    _musicPlay('assets/sounds/soundListen.mp3', 1.0);
    Future.delayed(Duration(seconds: 3), (){
      _musicPlay('assets/sounds/playGame.mp3', 1.0);
    });
    Future.delayed(Duration(seconds: 6), (){
      _musicPlay('assets/sounds/readStory.mp3', 1.0);
    });
    Future.delayed(Duration(seconds: 9), (){
      _musicPlay('assets/sounds/playTune.mp3', 1.0);
    });
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

  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _musicPlayStop();

    activateSpeechRecognizer();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _languageIdentifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.all(0.0),
        // color: Colors.grey.shade200,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg8.png"),
              fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Align(
            alignment: Alignment.center,
            child: Text("هيا نلعب معاً"),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: _speechRecognitionAvailable && !_isListening ? () => startSpeech() : () => cancelSpeech(),
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
    setState(() => _textInput = text);

    if (text.isNotEmpty) {
      _identifyLanguage(text);

      if('${_identifiedLanguage[0]}${_identifiedLanguage[1]}' != 'ar') {
        _musicPlay('assets/sounds/talkArabic.mp3', 1.0);
      }
      else {
        switch(_textInput) {
          case "رجوع":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
            );
            break;
          case "الرئيسية":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
            );
            break;
          case "قصة":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoryPage()),
            );
            break;
          case "لعبة":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GamePage()),
            );
            break;
          case "نلعب":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GamePage()),
            );
            break;
          case "لغز":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MysteryPage()),
            );
            break;
          case "لحن":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TunePage()),
            );
            break;
          case "ساعدني":
            playActions();
            break;
          case "مساعدة":
            playActions();
            break;
          case "وداعا":
            SystemNavigator.pop();
            break;
          case "نام":
            SystemNavigator.pop();
            break;
          default:
            _musicPlay('assets/sounds/repeat.mp3', 1.0);
        }
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
